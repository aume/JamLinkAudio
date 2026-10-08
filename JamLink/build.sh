#!/bin/bash
# Builds the two JamLink audio drivers (Universal, macOS 11+) from the
# unmodified BlackHole source in this repository:
#
#   JamLinkSend.driver    "JamLink Send"    apps play into it -> JamLink -> peers
#   JamLinkReturn.driver  "JamLink Return"  peers -> JamLink -> apps record it
#
# Usage: JamLink/build.sh <output-dir> <path-to-JamLink.icns> [version] [build-number]
# The drivers are left unsigned; JamLink's release script signs them.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(dirname "$HERE")"
OUT="$(mkdir -p "$1" && cd "$1" && pwd)"
ICON="$2"
VERSION="${3:-1.0.0}"
BUILD_NUMBER="${4:-1}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

PLUGIN_TYPE="443ABAB8-E7B3-491A-B985-BEB9187030DB"   # kAudioServerPlugInTypeUUID

build_driver () {
    local name="$1" bundle_id="$2" factory_uuid="$3"

    xcodebuild -quiet -project "$REPO/BlackHole.xcodeproj" -target BlackHole -configuration Release \
        SYMROOT="$WORK/sym" OBJROOT="$WORK/obj" CONFIGURATION_BUILD_DIR="$WORK/$name" \
        PRODUCT_NAME="$name" PRODUCT_BUNDLE_IDENTIFIER="$bundle_id" \
        MARKETING_VERSION="$VERSION" MACOSX_DEPLOYMENT_TARGET=11.0 \
        ARCHS="arm64 x86_64" ONLY_ACTIVE_ARCH=NO \
        GCC_PREFIX_HEADER="$HERE/$name.h" GCC_PRECOMPILE_PREFIX_HEADER=NO \
        CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" DEVELOPMENT_TEAM=""

    local driver="$WORK/$name/$name.driver"
    local plist="$driver/Contents/Info.plist"

    # Our own build number (JamLink compares it to offer updates) and our own
    # plug-in factory UUID, so these never collide with a real BlackHole.
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "$plist"
    /usr/libexec/PlistBuddy -c "Delete :CFPlugInFactories" "$plist"
    /usr/libexec/PlistBuddy -c "Add :CFPlugInFactories dict" "$plist"
    /usr/libexec/PlistBuddy -c "Add :CFPlugInFactories:$factory_uuid string BlackHole_Create" "$plist"
    /usr/libexec/PlistBuddy -c "Delete :CFPlugInTypes:$PLUGIN_TYPE" "$plist"
    /usr/libexec/PlistBuddy -c "Add :CFPlugInTypes:$PLUGIN_TYPE array" "$plist"
    /usr/libexec/PlistBuddy -c "Add :CFPlugInTypes:$PLUGIN_TYPE:0 string $factory_uuid" "$plist"

    # JamLink branding only: the BlackHole name and artwork may not be used
    # for modified builds.
    # Ship our notice and the GPL text; not BlackHole's README/changelog.
    rm -f "$driver/Contents/Resources/BlackHole.icns" "$driver/Contents/Resources/README.md" \
          "$driver/Contents/Resources/CHANGELOG.md" "$driver/Contents/Resources/VERSION"
    cp "$ICON" "$driver/Contents/Resources/JamLink.icns"
    cp "$REPO/JAMLINK.md" "$driver/Contents/Resources/JAMLINK.md"

    rm -rf "$OUT/$name.driver"
    ditto "$driver" "$OUT/$name.driver"
    echo "built $OUT/$name.driver"
}

build_driver JamLinkSend   com.spiral.jamlink.driver.send   5D4A3BB1-7F45-4A17-BA1B-07BF2A3CBD28
build_driver JamLinkReturn com.spiral.jamlink.driver.return 891BCB27-2B42-4A7A-A04F-F18827EE8AA9

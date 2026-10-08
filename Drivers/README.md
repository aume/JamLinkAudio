# JamLink audio drivers

This folder builds the two virtual audio devices used by
[JamLink](../README.md) from BlackHole v0.7.2 by Existential Audio Inc., under
the GNU General Public License v3.0 (see `LICENSE` here, which also covers
Existential Audio's trademark terms). The upstream history is on this
repository's `jamlink` branch.

They are **not** BlackHole and are not made or endorsed by Existential Audio.

## Changes from upstream BlackHole

The driver source (`BlackHole/BlackHole.c`) is unmodified. JamLink adds:

- `JamLink/JamLinkSend.h`, `JamLink/JamLinkReturn.h`: build-time settings
  (names, bundle IDs, 8 channels, which side of each device is visible).
- `JamLink/build.sh`: builds both drivers Universal for macOS 11+, and after
  building gives each its own version number and plug-in factory UUID and
  replaces the BlackHole icon with JamLink's.

| Driver | Visible to other apps | Hidden device used by JamLink |
|---|---|---|
| JamLinkSend.driver | "JamLink Send" (output) | "JamLink Send (for JamLink)" (input) |
| JamLinkReturn.driver | "JamLink Return" (input) | "JamLink Return (for JamLink)" (output) |

## Building

    Drivers/JamLink/build.sh <output-dir> <path-to-JamLink.icns> [version] [build-number]

JamLink's CMake build copies the results (from `build-drivers/` by
default) into `JamLink.app`, which installs them on request.

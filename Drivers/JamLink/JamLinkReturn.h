// JamLink Return - build settings for BlackHole.c (included as a prefix header).
//
// The JamLink app writes audio received from its peers into the hidden mirror
// device; other apps record it from "JamLink Return".
#define kDriver_Name                "JamLinkReturn"
#define kHas_Driver_Name_Format     false
#define kPlugIn_BundleID            "com.spiral.jamlink.driver.return"
#define kPlugIn_Icon                "JamLink.icns"
#define kManufacturer_Name          "JamLink (based on BlackHole by Existential Audio)"
#define kNumber_Of_Channels         8

#define kDevice_Name                "JamLink Return"
#define kDevice_IsHidden            false
#define kDevice_HasInput            true
#define kDevice_HasOutput           false

#define kDevice2_Name               "JamLink Return (for JamLink)"
#define kDevice2_IsHidden           true
#define kDevice2_HasInput           false
#define kDevice2_HasOutput          true

#define kCanBeDefaultSystemDevice   false

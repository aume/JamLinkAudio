// JamLink Send - build settings for BlackHole.c (included as a prefix header).
//
// Other apps (DAWs, Zoom, OBS, browsers...) play into "JamLink Send"; the
// JamLink app reads the same audio from the hidden mirror device and streams
// it to its peers.
#define kDriver_Name                "JamLinkSend"
#define kHas_Driver_Name_Format     false
#define kPlugIn_BundleID            "com.spiral.jamlink.driver.send"
#define kPlugIn_Icon                "JamLink.icns"
#define kManufacturer_Name          "JamLink (based on BlackHole by Existential Audio)"
#define kNumber_Of_Channels         8

#define kDevice_Name                "JamLink Send"
#define kDevice_IsHidden            false
#define kDevice_HasInput            false
#define kDevice_HasOutput           true

#define kDevice2_Name               "JamLink Send (for JamLink)"
#define kDevice2_IsHidden           true
#define kDevice2_HasInput           true
#define kDevice2_HasOutput          false

// Never pick this up as the alert/system-sound device.
#define kCanBeDefaultSystemDevice   false

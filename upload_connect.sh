#!/bin/sh

#------------------------------------------------------------------------------------------------
# Params
#------------------------------------------------------------------------------------------------

echo 'Upload to App Store Connect'

ARCHIVE_PATH=$1
IPA_PATH=$2
TEAMID=$3

#------------------------------------------------------------------------------------------------
#Export ipa
#------------------------------------------------------------------------------------------------

# app-store, development, enterprise, ad-hoc
EXPORT_METHOD=app-store
#export or upload
DESTINATION=upload

ExportOptionTemplate='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>%s</string>
    <key>teamID</key>
    <string>%s</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>destination</key>
    <string>%s</string>
</dict>
</plist>'

ExportOption="./customUploadConnect.plist"
printf "$ExportOptionTemplate" $EXPORT_METHOD $TEAMID $DESTINATION > $ExportOption

xcodebuild \
    -exportArchive \
    -archivePath $ARCHIVE_PATH \
    -exportOptionsPlist $ExportOption \
    -allowProvisioningUpdates YES
    -exportPath $IPA_PATH \

osascript -e 'display notification "RealCasino2" with title "Upload Success"'

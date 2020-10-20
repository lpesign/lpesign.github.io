#!/bin/sh

#------------------------------------------------------------------------------------------------
# Params
#------------------------------------------------------------------------------------------------

SCHEMA_NAME="Unity-iPhone"
#Release, Debug
CONFIGURATION=Release


FOLDER_PATH=$1
WORKSPACE=$2
ARCHIVE_PATH=$3
IPA_PATH=$4
IPA_NAME=$5
TEAMID=$6

echo $FOLDER_PATH
echo $WORKSPACE
echo $ARCHIVE_PATH
echo $IPA_PATH
echo $TEAMID


#------------------------------------------------------------------------------------------------
# Archive project
#------------------------------------------------------------------------------------------------

echo 'Archive Project'

xcodebuild \
 -workspace $WORKSPACE \
 -scheme $SCHEMA_NAME archive \
 -configuration $CONFIGURATION \
 -archivePath $ARCHIVE_PATH || exit 1

osascript -e 'display notification "RealCasino2" with title "Archvie Success"'

#------------------------------------------------------------------------------------------------
# Export ipa
#------------------------------------------------------------------------------------------------
sleep 0.5

echo 'Export ipa'

# app-store, development, enterprise, ad-hoc
EXPORT_METHOD=ad-hoc
#export or upload
DESTINATION=export

ExportOptionTemplate='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>%s</string>
    <key>teamID</key>
    <string>%s</string>
    <key>thinning</key>
    <string>&lt;thin-for-all-variants&gt;</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>destination</key>
    <string>%s</string>
</dict>
</plist>'

ExportOption="./customExport.plist"
printf "$ExportOptionTemplate" $EXPORT_METHOD $TEAMID $DESTINATION > $ExportOption

xcodebuild \
    -exportArchive \
    -archivePath $ARCHIVE_PATH \
    -exportOptionsPlist $ExportOption \
    -exportPath $IPA_PATH \
    -allowProvisioningUpdates YES

mv ${IPA_PATH}Apps/Unity-iPhone.ipa ${IPA_PATH}${IPA_NAME}.ipa
rm -rf "${IPA_PATH}Apps"
rm "${IPA_PATH}app-thinning.plist"
rm "${IPA_PATH}App Thinning Size Report.txt"
rm "${IPA_PATH}DistributionSummary.plist"
rm "${IPA_PATH}ExportOptions.plist"
rm "${IPA_PATH}Packaging.log"

osascript -e 'display notification "RealCasino2" with title "Export Success"'
exit 0

## Launch Deamons (aka cron for OSX)

Copy the plist files to /Library/LaunchDaemons:

    cp -r *.plist /Library/LaunchDaemons/

Load launchd with these defintions:

    launchctl load /Library/LaunchDaemons/com.different.*.plist

You can uload these defintions using:

    launchctl unload /Library/LaunchDaemons/com.different.*.plist

# ----------------------------------------------------------------
# macOS Fixer eXtention for some errors and warnings
# Nick "nekkitl" Ognev, 2023
set MACFX_VERSION "2023.0522"
# ----------------------------------------------------------------
function macfx_update --argument argv
    switch $argv[2]
        case self
            set API_URL "https://api.nekkit.xyz/macfx/ver"
            if ping -q -c 1 -W 1 google.com >/dev/null
                set api_version (curl -s $API_URL)
                if test "$api_version" != "$MACFX_VERSION"
                    echo 'macFX have update! Shell I update to '$api_version'? [y/n]'
                    read macfx_confirm
                    if test "$macfx_confirm" = y
                        wget 'https://api.nekkit.xyz/macfx/app' ~/.config/fish/functions/macfx.fish
                    end
                end
            end
        case all
            echo 'Get apps list...'
            brew update
            echo 'Starting upgrade apps and libs...'
            brew upgrade
            echo 'Cleanup cache...'
            brew cleanup
            echo 'Starting self-upgrade...'
            macfx_update self
            echo 'Update fish completions...'
            fish_update_completions
            echo 'Update location DB...'
            sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
            echo 'Done.'
        case locate
            sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
            echo 'Done.'
        case fish
            fish_update_completions
        case '*'
            echo 'Wake up, Neo...'
    end
end
# ----------------------------------------------------------------
function macfx_lib
    echo '. macOS Fixer eXtention ['$MACFX_VERSION']
├── App tools:
│   ├── discord - Show all devices in app.
│   ├── xattr - the easy solution, if app dont launch by many ## reasons.
│   └── msf - Add MSF support to fish 3.*
├── Update funcs:
│   └── update
│          ├── all - Update all
│          ├── self - Update self (macfx)
│          ├── fish - Update fish and completions via man
│          └── locate - Update locate DB
├── Services management:
│   ├── spell - SpellChk service
│   ├── airdrop - AirDrop enabler via eth0 (if available Bluetooth)
│   └── rdbug - restarts Remote Desktop services
└── System tools:
    ├── rtcsnd - Fix RTC on hackintosh systems.
    ├── tm - easy cleanup manager of Timeshift.
    ├── tm - easy cleanup manager of Timeshift.
    └── jenv - List and select Java Environment
    '
end
# ---------- Discord Devices not seen fix ------------------------
function macfx_discord
    codesign --remove-signature '/Applications/Discord.app/Contents/Frameworks/Discord Helper (Renderer).app/Contents/MacOS/Discord Helper (Renderer)'
    sudo codesign --remove-signature /Applications/Discord.app/Contents/Frameworks/Discord\ Helper\ \(GPU\).app /Applications/Discord.app/Contents/Frameworks/Discord\ Helper\ \(Plugin\).app /Applications/Discord.app/Contents/Frameworks/Discord\ Helper\ \(Renderer\).app /Applications/Discord.app/Contents/Frameworks/Discord\ Helper.app
end
# ----------------------------------------------------------------
function macfx_msf_fish_helper
    wget "https://api.nekkit.xyz/macfx/msf" -O '~/.config/fish/functions/msf.fish'
    source
    echo 'Done. Try MSF in terminal.'
end
# ----------------------------------------------------------------
function macfx_du_se --argument argv
    if test (count $argv[2]) -eq 0
        echo '. macOS Fixer eXtention
└── duse - macOS Secure Erase for any disk
    ├── [level] - From 0 to 4 levels of erasing, higher level - most secure.
    │    └── [disk] - Disk indentifier from listing.
    └── ls - List disks'
    else
        if test (count $argv[2]) -eq 1
            diskutil secureErase $argv[2] /dev/$args[3]
        else
            switch $argv[2]
                case ls
                    set disk_list (diskutil list | awk '{print $2,$NF}')
                    echo $disk_list | sed 's/\/dev\///g'

            end
        end
    end
end

# ----------------------------------------------------------------
function macfx_jenv --argument argv
    if test (count $argv[2]) -eq 0
        echo '. macOS Fixer eXtention
└── jenv - Java Environment Selector
    ├── ls - List Java Environment
    └── set - Set Java Environment version'
    else
        switch $argv[2]
            case ls
                /usr/libexec/java_home -V
            case set
                set -xU JAVA_HOME (/usr/libexec/java_home -v $argv[3])
        end
    end
end
# ----------------------------------------------------------------
function macfx_timeshift --argument argv
    if test (count $argv[2]) -eq 0
        echo '. macOS Fixer eXtention
└── tm - TimeShift Manager
    ├── list - List all snapshots or on selected disk
    ├── clear - Clear all snapshots or on selected disk
    └── backup
        ├── list - List all backups or on selected disk
        └── clear - Clear all backups or on selected disk'
    else
        switch $argv[2]
            case list
                if test (count $argv[3]) -eq 0
                    set listdisk = (ls /Volumes)
                    set -e listdisk[1]
                    tmutil listlocalsnapshots /
                    for i in $listdisk
                        tmutil listlocalsnapshots (echo '/Volumes/'$i'/')
                    end
                    set -e listdisk
                else
                    tmutil listlocalsnapshots (echo '/Volumes/'$argv[3]'/')
                end
            case clear
                if test (count $argv[3]) -eq 0
                    set listdisk = (ls /Volumes)
                    set -e listdisk[1]
                    sudo tmutil deletelocalsnapshots /
                    for i in $listdisk
                        sudo tmutil deletelocalsnapshots (echo '/Volumes/'$i'/')
                    end
                    set -e listdisk
                else
                    sudo tmutil deletelocalsnapshots (echo '/Volumes/'$argv[3]'/')
                end
            case backup
                switch $argv[3]
                    case list
                        if test (count $argv[4]) -eq 0
                            set listdisk (ls /Volumes)
                            for i in $listdisk
                                tmutil listbackups (echo '/Volumes/'$i'/')
                            end
                            set -e listdisk
                        else
                            tmutil listbackups (echo '/Volumes/'$argv[3]'/')
                        end
                    case clear
                        if test (count $argv[4]) -eq 0
                            set listdisk (ls /Volumes)
                            for i in $listdisk
                                sudo tmutil delete (echo '/Volumes/'$i'/')
                            end
                            set -e listdisk
                        else
                            sudo tmutil delete (echo '/Volumes/'$argv[3]'/')
                        end
                end
        end
    end
end
function macfx_xattributes --argument argv
    if test -z $argv[2]
        echo '[path/to/app] needed.
example: /Applications/your-broken.app'
    else
        sudo xattr -r -c $argv[2]
        echo 'Done.'
    end
end
function macfx_airdrop --argument argv
    if test (count $argv[2]) -eq 0
        echo '. macOS Fixer eXtention
└── airdrop - Controller AirDrop via eth0
    ├── on - On AirDrop via eth0
    └── off - Off AirDrop via eth0'
    else
        switch $args[2]
            case on
                defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
                killall Finder
            case off
                defaults write com.apple.NetworkBrowser BrowseAllInterfaces 0
                killall Finder
        end
    end
end

# ----------------------------------------------------------------
# ----------------------------------------------------------------
# ----------- Main manager of input args -------------------------
# ----------------------------------------------------------------
# ----------------------------------------------------------------
function macfx_argv_manager --argument argv
    switch $argv[1]
        case discord
            macfx_discord
        case xattr
            macfx_xattributes $argv
        case msf
            macfx_msf_fish_helper
        case jenv
            macfx_jenv $argv
        case tm
            macfx_timeshift $argv
        case rdbug
            killall "Remote Desktop"
            echo Restarted.
        case spell
            launchctl stop com.apple.applespell
            launchctl start com.apple.applespell
            echo Restarted.
        case update
            macfx_update $argv
        case airdrop
            macfx_airdrop $argv
        case '*'
            macfx_lib
    end
end
# ----------------------------------------------------------------
function macfx
    macfx_update
    macfx_argv_manager $argv
end


# ----------------------------------------------------------------
complete -c macfx -f
set -l macfx_execList discord rtcsnd msf fishup jenv xattr tm rdbug spell list set airdrop duse update
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a discord -d 'Show all devices in app.'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a rtcsnd -d 'Fix RTC on hackintosh systems.'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a msf -d 'Add MSF support to fish 3.*'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a fishup -d 'Update fish completions via man'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a jenv -d 'List and select Java Environment'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a xattr -d 'the easy solution, if app dont launch by many reasons.'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a tm -d 'easy cleanup manager of Timeshift.'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a rdbug -d 'Restarts Remote Desktop services'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a spell -d 'SpellChk service'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a airdrop -d 'AirDrop enabler via eth0 (if available Bluetooth)'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a duse -d 'macOS Secure Erase for any disk'
complete -c macfx -n "not __fish_seen_subcommand_from $macfx_execList" -a update -d 'Some updates in one place'

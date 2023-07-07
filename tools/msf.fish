function msf
    echo 'Type "msf help" for more information'
    switch $argv[1]
        case install
            echo 'Installing MSF...'
            curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb >msfinstall && chmod 755 msfinstall && ./msfinstall
        case update
            echo 'Updating MSF...'
            /opt/metasploit-framework/bin/msfupdate
        case help
            echo "MetaSploit Wrapper
            install - installation via official script
            help - show this help
            update - update MSF package
            module [sys/usr] - Go to folder of modules MSF package in system or user folders.
            venom - launch venom package"
        case venom
            /opt/metasploit-framework/bin/msfvenom
        case module
            switch $argv[2]
                case usr
                    cd ~/.msf4/modules/
                    echo 'MetaSploit Modules folder in User.'
                    echo (pwd)
                case sys
                    cd /opt/metasploit-framework//embedded/framework/modules/
                    echo 'MetaSploit Modules folder in System.'
                    echo (pwd)
                case '*'
                    echo 'usr - User folder\nsys - System folder'
            end
        case '*'
            /opt/metasploit-framework/bin/msfconsole
    end
end

# ----------------------------------------------------------------
complete -c msf -f
set -l execCommands update help module venom install
complete -c msf -n "not __fish_seen_subcommand_from $execCommands" -a update -d 'Update MSF package'
complete -c msf -n "not __fish_seen_subcommand_from $execCommands" -a module -d 'Go to folder of modules MSF package in system or user folders'
complete -c msf -n "not __fish_seen_subcommand_from $execCommands" -a help -d 'Show this help'
complete -c msf -n "not __fish_seen_subcommand_from $execCommands" -a venom -d 'Launch venom'
complete -c msf -n "not __fish_seen_subcommand_from $execCommands" -a install -d 'Install MSF package via official installation script'

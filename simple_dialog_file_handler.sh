#!/bin/bash

#=========================================================
#author: René Muhl
#from: Leipzig, Germany
#last change: 10.5.2013
#email: ReneM{dot}github{at}gmail{dot}com
#=========================================================
#Description:
#   The script provides handling configuration
#   files during installing and manging OpenStack components.
#   You can also look into the logfiles to detect the errors
#   in your configuration.
#
#   The advantage of this script is to look at a
#   central point in all configuration and log files.
#=========================================================



#user must be root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

#test if dialog is installed
hash dialog 2>/dev/null || { echo "\"dialog\" isn't installed.\nInstall \"dialog\" \"(sudo apt-get install dialog) and run the script again!";
    exit 1; }


_temp="/tmp/answer.$$"
dialog 2>$_temp
VER='0.01'
menu=main
currentLog=""

### show version 
version() {
    dialog --backtitle " simple dialog file handler " \
           --msgbox " Version $VER\na simple dialog file handler \n 
           - for easy file handling of OpenStack components\n " 9 52
}


### Text Box sample - show file test.txt
tailbox() {
echo $currentLog;
    dialog --backtitle "Dialog - TailBox sample"\
           --title " viewing File: "$currentLog" "\
           --tailbox "$currentLog" 40 120
}

### File Select sample 
file_select() {
    dialog --backtitle "Dialog - fselect sample"\
           --title " use [blank] key to select "\
           --fselect "$HOME/" 10 60 2>$_temp

    result=`cat $_temp`
    dialog --msgbox "\nYou selected:\n$result" 9 52
}

### File Select of config files
file_select_config_files() {
menu=config;
    dialog --backtitle "Dialog - fselect sample"\
           --begin 3 10 --title " use [blank] key to select "\
           --fselect "/etc/" 10 60 2>$_temp

    result=`cat $_temp`
    dialog --msgbox "\nYou selected:\n$result" 9 52
}

### File Select of log files
file_select_log_files() {
menu=log;
    dialog --backtitle "Dialog - fselect sample"\
           --begin 3 10 --title " use [blank] key to select "\
           --fselect "/var/log/" 10 60 2>$_temp

    result=`cat $_temp`
    dialog --msgbox "\nYou selected:\n$result" 9 52
}



### show config files of installed components
show_config_files() {
menu=config;
    dialog --backtitle " simple dialog file handler " --title " config files "\
        --cancel-label "Quit" \
        --menu "Move using [UP] [DOWN], [Enter]
to select the files you want to edit it" 17 60 10\
    1 "/etc/cinder/cinder.conf"\
    2 "/etc/cinder/api-paste.ini"\
    3 "/etc/glance/glance-api.conf"\
    4 "/etc/glance/glance-api-paste.ini"\
    5 "/etc/glance/glance-registry.conf"\
    6 "/etc/glance/glance-registry-paste.ini"\
    7 "/etc/keystone/keystone.conf"\
    8 "/etc/nova/api-paste.ini"\
    9 "/etc/nova/nova.conf"\
    10 "/etc/nova/nova-compute"\
    11 "/etc/openstack-dashboard/local_settings.py"\
    12 "/etc/swift/proxy-server.conf"\
    13 "/etc/swift/swift.conf"\
    14 "/etc/quantum/api-paste.ini"\
    15 "/etc/quantum/dhcp_agent.ini"\
    16 "/etc/quantum/l3_agent.ini"\
    17 "/etc/quantum/metadata_agent.ini"\
    18 "/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini"\
    19 "/etc/quantum/quantum.conf"\
    Other "open other files"\
    Back "go back to main menu"\
    Quit "Exit program" 2>$_temp
        
    opt=${?}
    if [ $opt != 0 ]; then rm $_temp; exit; fi
    menuitem=`cat $_temp`
    echo "menu=$menuitem"
    case $menuitem in
        1) vi /etc/cinder/cinder.conf;;
        2) vi /etc/cinder/api-paste.ini;;
        3) vi /etc/glance/glance-api.conf;;
        4) vi /etc/glance/glance-api-paste.ini;;
        5) vi /etc/glance/glance-registry.conf;;
    6) vi /etc/glance/glance-registry-paste.ini;;
    7) vi /etc/keystone/keystone.conf;;
    8) vi /etc/nova/api-paste.ini;;
    9) vi /etc/nova/nova.conf;;
    10) vi /etc/nova/nova-compute.conf;;
        11) vi /etc/openstack-dashboard/local_settings.py;;
        12) vi /etc/proxy-server.conf;;
    13) vi /etc/swift/swift/swift.conf;;
        14) vi /etc/quantum/api-paste.ini;;
        15) vi /etc/quantum/dhcp_agent.ini;;
        16) vi /etc/quantum/l3_agent.ini;;
        17) vi /etc/quantum/metadata_agent.ini;;
        18) vi /etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini;;
        19) vi /etc/quantum/quantum.conf;;
        Other) file_select_config_files;;
        Back) main_menu;;
        Quit) rm $_temp; exit;;
    esac
}

### show log files of installed components
show_log_files() {
menu=log;
    dialog --backtitle " simple dialog file handler " --title " log files "\
        --cancel-label "Quit" \
        --menu "Move using [UP] [DOWN], [Enter]
to select the files you want to edit it" 17 60 10\
    1 "/var/log/cinder/cinder-api.log"\
    2 "/var/log/cinder/cinder-scheduler.log"\
    3 "/var/log/cinder/cinder-volume.log"\
    4 "/var/log/glance/api.log"\
    5 "/var/log/glance/registry.log"\
    6 "/var/log/keystone/keystone.log"\
    7 "/var/log/nova/nova-api.log"\
    8 "/var/log/nova/nova-cert.log"\
    9 "/var/log/nova/nova-compute.log"\
    10 "/var/log/nova/nova-conductor.log"\
    11 "/var/log/nova/nova-consoleauth.log"\
    12 "/var/log/nova/nova-manage.log"\
    13 "/var/log/nova/nova-network.log"\
    14 "/var/log/nova/nova-scheduler.log"\
    15 "/var/log/quantum/dhcp-agent.log"\
    16 "/var/log/quantum/l3-agent.log"\
    17 "/var/log/quantum/linuxbridge-agent.log"\
    18 "/var/log/quantum/metadata-agent.log"\
    19 "/var/log/quantum/server.log"\
    20 "/var/log/swift/...???"\
    Other "open other files"\
    Back "go back to main menu"\
    Quit "Exit program" 2>$_temp
        
    opt=${?}
    if [ $opt != 0 ]; then rm $_temp; exit; fi
    menuitem=`cat $_temp`
    echo "menu=$menuitem"
    case $menuitem in
        1) currentLog="/var/log/cinder/cinder-api.log" && tailbox;;
        2) currentLog="/var/log/cinder/cinder-scheduler.log" && tailbox;;
        3) currentLog="/var/log/cinder/cinder-volume.log" && tailbox;;
        4) currentLog="/var/log/glance/api.log" && tailbox;;
        5) currentLog="/var/log/glance/registry.log" && tailbox;;
        6) currentLog="/var/log/keystone/keystone.log" && tailbox;;
        7) currentLog="/var/log/nova/nova-api.log" && tailbox;;
        8) currentLog="/var/log/nova/nova-cert.log" && tailbox;;
        9) currentLog="/var/log/nova/nova-compute.log" && tailbox;;
        10) currentLog="/var/log/nova/nova-conductor.log" && tailbox;;
        11) currentLog="/var/log/nova/nova-consoleauth.log" && tailbox;;
        12) currentLog="/var/log/nova/nova-manage.log" && tailbox;;
        13) currentLog="/var/log/nova/nova-network.log" && tailbox;;
        14) currentLog="/var/log/nova/nova-scheduler.log" && tailbox;;
        15) currentLog="/var/log/quantum/dhcp-agent.log" && tailbox;;
        16) currentLog="/var/log/quantum/l3-agent.log" && tailbox;;
        17) currentLog="/var/log/quantum/linuxbridge-agent.log" && tailbox;;
        18) currentLog="/var/log//var/log/quantum/metadata-agent.log" && tailbox;;
    19) currentLog="/var/log//var/log/quantum/server.log" && tailbox;;
        20) currentLog="/var/log/swift/..." && tailbox;;
        Other) file_select_log_files;;
        Back) main_menu;;
        Quit) rm $_temp; exit;;
    esac
}




### create main menu
main_menu() {
menu=main;
    dialog --backtitle " simple dialog file handler " --title " Main Menu - V. $VER "\
        --cancel-label "Quit" \
        --menu "Move using [UP] [DOWN], [Enter]
to select the type of file you want to handle with" 17 60 10\
        Config "show OpenStack config files"\
        Log "show OpenStack log files"\
        Other "open other files"\
        Version "Show program version info"\
        Quit "Exit program" 2>$_temp
        
    opt=${?}
    if [ $opt != 0 ]; then rm $_temp; exit; fi
    menuitem=`cat $_temp`
    echo "menu=$menuitem"
    case $menuitem in
        Config) show_config_files;;
        Log) show_log_files;;
        Other) file_select;;
        Version) version;;
        Quit) rm $_temp; exit;;
    esac
}



while true; do
    case $menu in
         main) main_menu;;
         config) show_config_files;;
         log) show_log_files;;
    esac
done





#!/bin/bash

function domain_pref(){
    echo "Enter Name"
    read name

    #user authentication

    if [[ $name == $(whoami) ]]; then
        if groups "$name" | grep -qw "mentees"; then
            read -p "Enter Roll No: " rollNumber
            echo "Enter domain preference (Webdev, Appdev, Sysad) line by line. Leave blank if none "
            prefs=("" "" "")
            for i in 0 1 2;do
                read -r pref
                prefs[$i]=$pref
                if [ $pref != '' ]; then
                    sudo mkdir /home/core/mentees/$name/$pref
                    echo -e "$pref\n" >> /home/core/mentees/$name/domain_pref.txt
                fi
            done
        echo "$rollNumber $name ${prefs[0]} ${prefs[1]} ${prefs[2]}" >> /home/core/mentees_domain.txt
        fi
    fi
}

alias domainPref='domain_pref'
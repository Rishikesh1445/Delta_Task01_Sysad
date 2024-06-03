#!/bin/bash

#some permission changes are done in permit function atlast using setfacl

function corefile(){
    sudo useradd -m -s /bin/bash -d /home/core core
    sudo mkdir /home/core/mentors /home/core/mentees
    sudo mkdir /home/core/mentors/Webdev /home/core/mentors/Appdev /home/core/mentors/Sysad
    sudo touch /home/core/mentees_domain.txt
    sudo chmod -R 777 /home/core
    echo "had:123" | sudo chpasswd
}

function mentees(){
    sudo groupadd mentees
    while read line1
    do
        menteeName=$(echo "$line1" | cut -d " " -f 1)
        sudo useradd -m -s /bin/bash -d /home/core/mentees/$menteeName $menteeName
        sudo usermod -g mentees $menteeName
        sudo touch /home/core/mentees/$menteeName/domain_pref.txt
        sudo touch /home/core/mentees/$menteeName/task_completed.txt
        sudo touch /home/core/mentees/$menteeName/task_submitted.txt
        echo "$menteeName:123" | sudo chpasswd
        sudo chmod -R 777 /home/core/mentees/$menteeName
        sudo setfacl -R -m g:$menteeName:rwx /home/core/mentees/$menteeName
    done < menteeDetails.txt
    sudo chgrp mentees /home/core/mentees_domain.txt
    sudo chmod g+w /home/core/mentees_domain.txt
}

function mentors(){
    sudo groupadd mentors
    while read line2
    do
        name=$(echo "$line2" | cut -d " " -f 1)
        domain=$(echo "$line2" | cut -d " " -f 2)
        case $domain in
            "web")
                sudo useradd -m -s /bin/bash -d /home/core/mentors/Webdev/$name $name
                sudo touch /home/core/mentors/Webdev/$name/allocatedMentees.txt
                sudo mkdir /home/core/mentors/Webdev/$name/submittedTasks
                sudo mkdir /home/core/mentors/Webdev/$name/submittedTasks/task_01 /home/core/mentors/Webdev/$name/submittedTasks/task_02 /home/core/mentors/Webdev/$name/submittedTasks/task_03
                echo "$name:123" | sudo chpasswd
                sudo chmod -R 777 /home/core/mentors/Webdev/$name
                sudo setfacl -R -m g:$name:rwx /home/core/mentors/Webdev/$name
            ;;
            "app")
                sudo useradd -m -s /bin/bash -d /home/core/mentors/Appdev/$name $name
                sudo touch /home/core/mentors/Appdev/$name/allocatedMentees.txt
                sudo mkdir /home/core/mentors/Appdev/$name/submittedTasks
                sudo mkdir /home/core/mentors/Appdev/$name/submittedTasks/task_01 /home/core/mentors/Appdev/$name/submittedTasks/task_02 /home/core/mentors/Appdev/$name/submittedTasks/task_03
                echo "$name:123" | sudo chpasswd
                sudo chmod -R 777 /home/core/mentors/Appdev/$name
                sudo setfacl -R -m g:$name:rwx /home/core/mentors/Appdev/$name
            ;;
            "sysad")
                sudo useradd -m -s /bin/bash -d /home/core/mentors/Sysad/$name $name
                sudo touch /home/core/mentors/Sysad/$name/allocatedMentees.txt
                sudo mkdir /home/core/mentors/Sysad/$name/submittedTasks
                sudo mkdir /home/core/mentors/Sysad/$name/submittedTasks/task_01 /home/core/mentors/Sysad/$name/submittedTasks/task_02 /home/core/mentors/Sysad/$name/submittedTasks/task_03
                echo "$name:123" | sudo chpasswd
                sudo chmod -R 777 /home/core/mentors/Sysad/$name
                sudo setfacl -R -m g:$name:rwx /home/core/mentors/Sysad/$name
                ;;
            *) echo "Invalid";;
        esac
		sudo usermod -g mentors $name
    done < mentorDetails.txt
}

function permit(){
    sudo setfacl -R -m u:root:rwx /home
    sudo setfacl -R -m u:core:rwx /home
    sudo setfacl -m g:mentees:x /home/core /home/core/mentees
    sudo setfacl -m g:mentees:w /home/core/mentees_domain.txt
    sudo setfacl -R -x g:mentees /home/core/mentors
    sudo setfacl -m g:mentors:rx /home/core /home/core/mentors /home/core/mentors/Webdev /home/core/mentors/Appdev /home/core/mentors/Sysad
    sudo setfacl -R -m g:mentors:rx /home/core/mentees
}

corefile > /dev/null 2>&1   
mentees > /dev/null 2>&1
mentors > /dev/null 2>&1

alias userGen='corefile; mentees; mentors; permit'
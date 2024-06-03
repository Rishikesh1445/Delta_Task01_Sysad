#!/bin/bash

function submitTask(){
    echo "Enter Name"
    read name
    
    #user authentication

    if [[ $name == $(whoami) ]]; then
        #if mentee uses

        if groups "$name" | grep -qw "mentees"; then
            read -p "which domain task to submit: (Webdev, Appdev, Sysad)" domain
            read -p "which task: (task_01, task_02, task_03)" task

            if [[ -z "$(ls -A /home/core/mentees/$name/$domain/$task)" ]];then
                sudo mkdir /home/core/mentees/$name/$domain/$task
            else
                echo "File already exist"
            fi
            
            #Erasing the file so that it can be updated in the same format given
            truncate -s 0 task_submitted.txt

            for i in Sysad Appdev Webdev;do
                echo -e "\n$i" >> /home/core/mentees/$name/task_submitted.txt
                for j in task_01 task_02 task_03;do
                    if [[ -d /home/core/mentees/$name/$i/$j/ ]];then
                        echo -e "\n\t$j: y" >> /home/core/mentees/$name/task_submitted.txt
                    else
                        echo -e "\n\t$j: n" >> /home/core/mentees/$name/task_submitted.txt
                    fi
                done
            done
        fi

        #if mentor uses
        if groups "$name" | grep -qw "mentors"; then
            read -p "which domain (Webdev, Appdev, Sysad): " domain
            while read line1
            do
                menteeName=$(echo "$line1" | cut -d " " -f 1)
                for i in task_01 task_02 task_03;do
                    if [[ -d /home/core/mentees/$menteeName/$domain/$i/ ]];then
                        ln -s /home/core/mentees/$menteeName/$domain/$i /home/core/mentors/$domain/$name/submittedTasks/$i/$menteeName
                    fi
                    if [[ -n "$(ls -A /home/core/mentees/$menteeName/$domain/$i)" ]];then
                        echo -e "$domain $i: completed\n" >> /home/core/mentees/$menteeName/task_completed.txt
                    fi
                done
            done < /home/core/mentors/$domain/$name/allocatedMentees.txt
        fi
    fi
}

alias submitTask='submitTask'
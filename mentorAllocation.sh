#!/bin/bash

function mentorAllocation(){
    if [[ $(whoami) == "core" ]]; then
        declare -A web
        declare -A app
        declare -A sysad
        while read line1 
        do
            Name=$(echo "$line1" | cut -d " " -f 1)
            Domain=$(echo "$line1" | cut -d " " -f 2)
            CapacityString=$(echo "$line1" | cut -d " " -f 3)
            case $Domain in
                "web") web[$Name]=$((CapacityString));;
                "app") app[$Name]=$((CapacityString));;
                "sysad") sysad[$Name]=$((CapacityString));;
                *) echo "Invalid";;
            esac
        done < mentorDetails.txt

        while read line2
        do
            rollNumber=$(echo "$line2" | cut -d " " -f 1)
            name=$(echo "$line2" | cut -d " " -f 2)
            pref1=$(echo "$line2" | cut -d " " -f 3)
            pref2=$(echo "$line2" | cut -d " " -f 4)
            pref3=$(echo "$line2" | cut -d " " -f 5)
            for i in $pref1 $pref2 $pref3;do
                if [[ -n "$i" ]]; then
                    case $i in
                        "Webdev")
                            for j in "${!web[@]}";do
                                if [ $((web[$j])) -gt 0 ]; then
                                    web[$j]=$((web[$j] -1))
                                    echo "$name $rollNumber" >> /home/core/mentors/Webdev/"$j"/allocatedMentees.txt                                
                                    break
                                fi
                            done
                            ;;
                        "Appdev")
                            for k in "${!app[@]}";do
                                if [ $((app[$k])) -gt 0 ]; then
                                    app[$k]=$((app[$k] -1))
                                    echo "$name $rollNumber" >> /home/core/mentors/Appdev/"$k"/allocatedMentees.txt                                
                                    break
                                fi
                            done
                            ;;
                        "Sysad")
                            for l in "${!sysad[@]}";do
                                if [ $((sysad[$l])) -gt 0 ]; then
                                    sysad[$l]=$((sysad[$l] -1))
                                    echo "$name $rollNumber" >> /home/core/mentors/Sysad/"$l"/allocatedMentees.txt                                
                                    break
                                fi
                            done
                            ;;
                        *) echo "Invalid";;
                    esac
                fi
            done
        done < /home/core/mentees_domain.txt
    fi
}

alias mentorAllocation='mentorAllocation'
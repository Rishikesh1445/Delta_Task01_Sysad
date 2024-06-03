#!/bin/bash

#Global variable to keep record when core used last time
declare -a submitted_mentee_details

function displayStatus(){
    if [[ $(whoami) == "core" ]]; then
        #for command line argument
        domain="$1"

        declare -A submitted_web=( [task_01]=0 [task_02]=0 [task_03]=0 )
        declare -A submitted_app=( [task_01]=0 [task_02]=0 [task_03]=0 )
        declare -A submitted_sysad=( [task_01]=0 [task_02]=0 [task_03]=0 )
        declare -A menteeCount_domain=( [Webdev]=0 [Appdev]=0 [Sysad]=0)
        declare -a current_submitted_mentee_details
        #changed output from last time core used this alias
        declare -a changed
        #changed output filtered by domain
        declare -a changed_web
        declare -a changed_app
        declare -a changed_sysad
        
        #logic: submitted means task directory exist ; domain directory exist, then add one in total count
        while read line1
        do
            name=$(echo "$line1" | cut -d " " -f 2)
            for i in Webdev Appdev Sysad;do
                for j in task_01 task_02 task_03;do
                    if [[ -d /home/core/mentees/$name/$i/$j/ ]]; then
                        case $i in
                            "Webdev") ((submitted_web[$j]+=1));;
                            "Appdev") ((submitted_app[$j]+=1));;
                            "Sysad") ((submitted_sysad[$j]+=1));;
                            *) ;;
                        esac
                        current_submitted_mentee_details+=("$name-$i-$j")
                    fi
                done
                if [[ -d /home/core/mentees/$name/$i/ ]]; then
                    ((menteeCount_domain[$i]+=1))
                fi
            done
        done < /home/core/mentees_domain.txt

        #global variable updated and changes detected
        for element in "${current_submitted_mentee_details[@]}";do
            if ! [[ ${submitted_mentee_details[*]} == *" $element "* ]];then
                submitted_mentee_details+=("$element")
                changed+=("$element")
            fi
        done

        for element1 in "${changed[@]}";do
            if [[ $element1 == *"Webdev"* ]];then
                changed_web+=("$element1")
            fi
        done

        for element2 in "${changed[@]}";do
            if [[ $element2 == *"Appdev"* ]];then
                changed_app+=("$element2")
            fi
        done
        
        for element3 in "${changed[@]}";do
            if [[ $element3 == *"Sysad"* ]];then
                changed_sysad+=("$element3")
            fi
        done

        #Looks big, it's just coz of long names. Just calculating percentage and output given based on arguement
        case $domain in
            "")
                echo "Submitted Percentage
                Task 1: $(( submitted_web[task_01]+submitted_app[task_01]+submitted_sysad[task_01]*100/menteeCount_domain[Webdev]+menteeCount_domain[Appdev]+menteeCount_domain[Sysad])) %
                Task 2: $(( submitted_web[task_02]+submitted_app[task_02]+submitted_sysad[task_02]*100/menteeCount_domain[Webdev]+menteeCount_domain[Appdev]+menteeCount_domain[Sysad])) %
                Task 3: $(( submitted_web[task_03]+submitted_app[task_03]+submitted_sysad[task_03]*100/menteeCount_domain[Webdev]+menteeCount_domain[Appdev]+menteeCount_domain[Sysad])) %
                Mentees who submitted task since last visited: "
                echo "${changed[@]}"
            ;;
            "Webdev")
                echo "Submitted Percentage for Webdev
                Task 1: $(( submitted_web[task_01]*100/menteeCount_domain[Webdev])) %
                Task 2: $(( submitted_web[task_02]*100/menteeCount_domain[Webdev])) %
                Task 3: $(( submitted_web[task_03]*100/menteeCount_domain[Webdev])) %
                Mentees who submitted task in Webdev domain since last visited: "
                echo "${changed_web[@]}"
            ;;
            "Appdev")
                echo "Submitted Percentage for Appdev
                Task 1: $(( submitted_app[task_01]*100/menteeCount_domain[Appdev])) %
                Task 2: $(( submitted_app[task_02]*100/menteeCount_domain[Appdev])) %
                Task 3: $(( submitted_app[task_03]*100/menteeCount_domain[Appdev])) %
                Mentees who submitted task in Appdev domain since last visited: "
                echo "${changed_app[@]}"
            ;;
            "Sysad")
                echo "Submitted Percentage for Sysad
                Task 1: $(( submitted_sysad[task_01]*100/menteeCount_domain[Sysad])) %
                Task 2: $(( submitted_sysad[task_02]*100/menteeCount_domain[Sysad])) %
                Task 3: $(( submitted_sysad[task_03]*100/menteeCount_domain[Sysad])) %
                Mentees who submitted task in Sysad domain since last visited: "
                echo "${changed_sysad[@]}"
            ;;
            *);;
        esac
    fi
}

alias displayStatus='displayStatus'  
#use this alias like displayStatus (or) displayStatus Sysad 
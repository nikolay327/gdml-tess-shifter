#!/bin/bash

#######################################
# Rotate the coordinates of all vertices of all tessellated solids in a GDML file, and write the result in a new GDML file.
# First rotate about the x-axis, then the y-axis, then the z-axis.
# Arguments:
#   GDML file to be changed, a path.
#   GDML file to be written into, a path.
#   phix, the rotation angle about the x-axis (in degrees).
#   phiy, the rotation angle about the y-axis (in degrees).
#   phiz, the rotation angle about the z-axis (in degrees).
# Returns
#   0 if successful, non-zero if fails.
#######################################
function rotate-coord
{
    if [[ $# -ne 5 ]]
    then
        echo "Please only supply 5 arguments!"
        return 1
    fi

    if [[ ! $1 =~ .gdml$ ]]
    then
        echo "${1} is not a GDML file."
        return 2
    fi

    if [[ ! -s $1 ]]
    then
        echo "${1} does not exist or empty."
        return 3
    fi

    local File
    if [[ $(realpath ${1}) == $(realpath ${2}) ]]
    then
        echo "The file to be written into is the same as the input file. Creating a backup in ${1}.backup..."
        cat $1 > ${1}.backup

        File=${1}.backup
    else
        File=${1}
    fi

    if [[ ! -f $2 ]]
    then
        touch $2
    else
        echo "$2 already exists. Creating a backup in ${2}.backup..."
        cat $2 > ${2}.backup
        > $2
    fi

    local Rot
    Rot=$(grep "<position name=" ${File} \
        | awk -v CONVFMT=%.18g -v phix=$3 \
        'BEGIN {FS="\""}{\
        pi=atan2(0, -1); y=$6*cos(pi*phix/180)-$8*sin(pi*phix/180);\
        z=$6*sin(pi*phix/180)+$8*cos(pi*phix/180)}\
        {print $1"\""$2"\""$3"\""$4"\""$5"\""y"\""$7"\""z"\""$9"\""$10"\""$11}')

    Rot=$(awk -v CONVFMT=%.18g -v phiy=$4 \
        'BEGIN {FS="\""}{\
        pi=atan2(0, -1); x=$4*cos(pi*phiy/180)+$8*sin(pi*phiy/180);\
        z=-$4*sin(pi*phiy/180)+$8*cos(pi*phiy/180)}\
        {print $1"\""$2"\""$3"\""x"\""$5"\""$6"\""$7"\""z"\""$9"\""$10"\""$11}'\
         <<< ${Rot})

    Rot=$(awk -v CONVFMT=%.18g -v phiz=$5 \
        'BEGIN {FS="\""}{\
        pi=atan2(0, -1); x=$4*cos(pi*phiz/180)-$6*sin(pi*phiz/180);\
        y=$4*sin(pi*phiz/180)+$6*cos(pi*phiz/180)}\
        {print $1"\""$2"\""$3"\""x"\""$5"\""y"\""$7"\""$8"\""$9"\""$10"\""$11}'\
         <<< ${Rot})

    local Line
    local Counter=0
    while IFS= read -r Line
    do
        if [[ ${Line} =~ define ]]
        then
            ((Counter+=1))
        fi

        if [[ ${Counter} -eq 1 ]]
        then
            echo "${Line}" 1>> $2

            local Line2
            while IFS= read -r Line2
            do
                echo "${Line2}" 1>> $2
            done <<< ${Rot}
        else
            echo "${Line}" 1>> $2
        fi
    done < <(grep -v "<position name=" ${File})

    return 0
}

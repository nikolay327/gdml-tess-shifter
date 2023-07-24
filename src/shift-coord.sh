#!/bin/bash

#######################################
# Shift the coordinates of all vertices of a tessellated solid contained in a GDML file containing only ONE tesselated solid, write the result in a new GDML file.
# Arguments:
#   GDML file to be changed, a path.
#   GDML file to be written into, a path.
#   dx, the new x-coordinate is x-dx.
#   dy, the new y-coordinate is y-dy.
#   dz, the new z-coordinate is z-dz.
# Returns
#   0 if successful, non-zero if fails.
#######################################
function shift-coord
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
            done < <(grep "<position name=" ${File} \
                | awk -v CONVFMT=%.18g -v dx=$3 -v dy=$4 -v dz=$5 \
                'BEGIN {FS="\""}{x=$4-dx; y=$6-dy; z=$8-dz}{print $1"\""$2"\""$3"\""x"\""$5"\""y"\""$7"\""z"\""$9"\""$10"\""$11}')
        else
            echo "${Line}" 1>> $2
        fi
    done < <(grep -v "<position name=" ${File})

    return 0
}

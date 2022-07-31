#!/bin/bash

function parse_yaml {
    local prefix=$2
    local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
    sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
    awk -F$fs '{
        indent = length($1)/2;
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
            vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
            printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
        }
    }'
}

# eval - construct command by concatenating arguments
# will put CONFIG_ in front of each variable finded in config.yml (it is the $2 and $prefix in function parse_yaml) line 4 and line 15.
eval $(parse_yaml config.yml "CONFIG_")


# each value from yml will be separated by "_" on your script call.
# example:
#
#  keyA:
#    elementB: valueB
#  
#

echo "$CONFIG_keyA_elementB"
echo "$CONFIG_keyD_elementD_elementE_elementF"

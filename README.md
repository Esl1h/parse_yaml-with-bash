# parse_yaml-with-bash
How to parse and use yaml file in bash/shell script

create this function:
```shell
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
```

In the beginning of your script, call `eval` to concate arguments

`eval $(parse_yaml config.yml "CONFIG_")`

This eval line will put CONFIG_ in front of each variable finded in config.yml (it is the \$2 and $prefix in function parse_yaml) line 4 and line 15 from my parse_example.sh.

The config.yaml is on the same path that the .sh, you can create or modify the function to another yaml file (or put in a variable) and change the prefix.


Each value from yml will be separated by "_" on your script call.
 example:

```yaml
  keyA:
    elementB: valueB
  
```

And `echo "$CONFIG_keyA_elementB"` will return `valueB`

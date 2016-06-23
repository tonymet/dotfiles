# list the unique keys in local redis
function tt-cn-keys(){
  redis-cli keys \*|awk '{print $1}' |perl -ne 'print "$1\n" if /([a-z]+)\./'|sort|uniq -c
}
# list endpoints
#
function wanip(){
  dig +short myip.opendns.com @resolver1.opendns.com
}


# fibonacci
function fib() {
	local a c
	local -F1 b
	a=0 ; b=1
	print $a
	repeat 100
	do
		print "${b%.*}"
		c=$a
		a=$b
		((b = c + b))
	done
}

function rman(){
  docs=~/tigertext/lib/redis-doc/commands
  if [[ ! -f $docs/$1.md ]]; then
    echo "$1 command not found. "
    ls $docs
    return -1
  fi
  ronn -m $docs/$1.md
}

function urldecode(){
	python -c "import sys;import urllib;print urllib.unquote(''.join(sys.stdin.readlines())).decode('utf8') "
}

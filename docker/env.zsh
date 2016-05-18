if which docker-machine>/dev/null && [[ `docker-machine status default` -ne 'Stopped' ]] ;then
	eval $(docker-machine env default)
fi

# list the unique keys in local redis
function http-codes(){
	node -p  "require('http').STATUS_CODES"
}

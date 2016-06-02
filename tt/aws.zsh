# aws functions
#
function tt-instances(){
	case $1 in 
		"dev/cn")
			aws --profile=tigertext.tonym ec2 describe-instances --filters 'Name=tag:Services,Values=*cn*' 'Name=tag:Environment,Values=development'|jq '.Reservations[].Instances[].PublicDnsName'
		;;
		"prod/cn")
			aws --profile=tigertext.tonym ec2 describe-instances --filters 'Name=tag:Services,Values=*cn*' 'Name=tag:Environment,Values=production'|jq '.Reservations[].Instances[]'
		;;
		*)
			echo "we don't know nothing about $1"
		;;
	esac
}

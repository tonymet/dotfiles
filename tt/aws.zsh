# aws functions
#
function tt-instances(){
	case $1 in 
		"dev/cn")
			aws --profile=tigertext.$USER ec2 describe-instances --filters 'Name=tag:Services,Values=*cn*' 'Name=tag:Environment,Values=development'|jq '.Reservations[].Instances[].PublicDnsName'
		;;
		"dev/paging")
			aws --profile=tigertext.$USER ec2 describe-instances --filters 'Name=tag:Services,Values=*pag*' 'Name=tag:Environment,Values=development'|jq '.Reservations[].Instances[].PublicDnsName'
		;;
		"prod/paging")
			aws --profile=tigertext.$USER ec2 describe-instances --filters 'Name=tag:Services,Values=*pag*' 'Name=tag:Environment,Values=production'|jq '.Reservations[].Instances[].Tags[]|select(.Key | contains("Name"))|.Value';
		;;
		"prod/cn")
			aws --profile=tigertext.$USER ec2 describe-instances --filters 'Name=tag:Services,Values=*cn*' 'Name=tag:Environment,Values=production'|jq '.Reservations[].Instances[].Tags[]|select(.Key | contains("Name"))|.Value';
		;;
		*)
			echo "we don't know nothing about $1"
			return -1
		;;
	esac
}

# list endpoints
#
function tt-endpoints(){
	case $1 in
		"all")
			aws --profile=tigertext.$USER route53 list-resource-record-sets --hosted-zone-id Z9I8ODW49EQEN|jq '.ResourceRecordSets[].Name'
		;;
		*)
			aws --profile=tigertext.$USER route53 list-resource-record-sets --hosted-zone-id Z9I8ODW49EQEN|jq ".ResourceRecordSets[]|select(.Name|contains(\"$1\"))|.Name"
			return -1
		;;
	esac
}


function tt-version(){
	case $1 in
		"js_sdk")
			for n in qa uat dev stag; do
				echo $n ; curl -sL https://$n-sdk.tigertext.me/v1/sdk.js|egrep 'build-number'|head -n 1
			done
		;;
		"web-console")
			for n in qa uat dev stag; do
				echo $n ; curl -s https://$n-console.tigertext.me/git.info
			done
		;;
		*)
			echo "we dont' know nothing about $1"
			return -1
		;;
	esac
}
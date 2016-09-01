# aws functions
#
function tt-instances(){
	case $1 in 
		"dev/cn")
			aws --profile=tigertext.$USER ec2 describe-instances --filters 'Name=tag:Services,Values=*cn*' 'Name=tag:Environment,Values=development'|jq '.Reservations[].Instances[].PublicDnsName'
		;;
		"uat/all")
			aws --profile=tigertext.$USER ec2 describe-instances  --filters 'Name=tag:Environment,Values=uat'|jq '.Reservations[].Instances[].Tags[]|select(.Key|contains("Name"))|.Value'
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
		"all/redis")
			aws --profile=tigertext.$USER ec2 describe-instances --filters 'Name=tag:Services,Values=*redis*' |jq '.Reservations[].Instances[].Tags[]|select(.Key | contains("Name"))|.Value';
		;;
		"all/paging")
			aws --profile=tigertext.$USER ec2 describe-instances --filters 'Name=tag:Services,Values=*paging*' |jq '.Reservations[].Instances[].Tags[]|select(.Key | contains("Name"))|.Value';
		;;
		"all/webdata")
			aws --profile=tigertext.$USER ec2 describe-instances --filters 'Name=tag:Name,Values=*webdata*' |jq '.Reservations[].Instances[].Tags[]|select(.Key | contains("Name"))|.Value';
		;;
		"all/uscc")
			aws --profile=tigertext.$USER ec2 describe-instances --filters 'Name=tag:Name,Values=*uscc*' |jq '.Reservations[].Instances[].Tags[]|select(.Key | contains("Name"))|.Value';
		;;
		"qa/all")
			aws --profile=tigertext.$USER ec2 describe-instances --filters 'Name=tag:Environment,Values=qa' |jq '.Reservations[].Instances[].Tags[]|select(.Key | contains("Name"))|.Value';
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
			echo 'prod' ; curl -s https://home.tigertext.com/git.info
		;;
		"web-cn")
			for n in qa uat dev stag; do
				echo $n ; curl -s https://$n-console.tigertext.me/cn/git.info
			done
			echo 'prod' ; curl -s https://home.tigertext.com/cn/git.info
		;;
		"uscc")
			ssh -t aries ssh uscc.tigertext.me 'sh -c \"ls --sort time /mnt/opt/releases/uscc_billing\"'|head -n 1
		;;
		*)
			echo "we dont' know nothing about $1"
			return -1
		;;
	esac
}


function tt-verizon-env(){
	case $1 in
		"start")
			aws --profile=ttwebdev/ametzidis opsworks start-stack --stack-id=0ff85b28-d31c-4b92-b2a3-af2bf889daaf
		;;
		"stop")
			aws --profile=ttwebdev/ametzidis opsworks stop-stack --stack-id=0ff85b28-d31c-4b92-b2a3-af2bf889daaf
		;;
		*)
			echo "$1 is not supported"
			return -1
		;;
	esac



}

# open security group to my ip
function tt-vpn(){
	sgs=(sg-41fb453b)

	for g in $sgs; do
		echo "opening $g"
		aws ec2 --profile=ttwebdev.$USER authorize-security-group-ingress --protocol tcp --port 0-65535 --cidr $(dig +short myip.opendns.com @resolver1.opendns.com)/32 --group-id sg-41fb453b
	done
}

function microsites-hosts-prod () { 
 aws opsworks describe-instances --stack-id=fcd99bfa-f27f-473e-a8b7-d81998d818ba|jq '.Instances[].PublicDns'|grep -v null|sed s/\"//g
} # Error!
function microsites-hosts-stage () { 
 aws opsworks describe-instances --stack-id=725b0f16-b3d5-4dcf-a1e5-b1e5a7af515f|jq '.Instances[].PublicDns'|grep -v null|sed s/\"//g
} # Error!

# archive a dir into an archive tar file.
# used often with old src repos
function archive-dir () {
	dir=$(basename $1)
	if ( [[ -d $dir ]] && tar -zcf archive/$dir.tgz $dir); then
		rm -rf $dir
	fi
}


#!/bin/bash
REGION=us-east-1
# ... List of endpoints ...

endpoints=(
#Red Hat Endpoints
"sso.redhat.com 443"
"registry.redhat.io 443"
# quay Endpoints
"quay.io 443"
# *.quay.io
"cdn.quay.io 443"
"cdn01.quay.io 443"
"cdn02.quay.io 443"
"cdn03.quay.io 443"
"quay-registry.s3.amazonaws.com 443"
"cm-quay-production-s3.s3.amazonaws.com 443"
"cart-rhcos-ci.s3.amazonaws.com 443"
"openshift.org 443"
"registry.access.redhat.com 443"
"console.redhat.com 443"
"sso.redhat.com 443"
"pull.q1w2.quay.rhcloud.com 443"
"cdn01.q1w2.quay.rhcloud.com 443"
#"*.q1w2.quay.rhcloud.com 443"

# Telemetry Endpoints
"cert-api.access.redhat.com 443"
"api.access.redhat.com 443"
"infogw.api.openshift.com 443"
"console.redhat.com 443"
"observatorium.api.openshift.com 443"

#Amazon Endpoints
"ec2.amazonaws.com 443"
"events.amazonaws.com 443"
"iam.amazonaws.com 443"
"route53.amazonaws.com 443"
"sts.amazonaws.com 443"
"tagging.us-east-1.amazonaws.com 443"
"ec2.${REGION}.amazonaws.com 443"
"elasticloadbalancing.${REGION}.amazonaws.com 443"
"servicequotas.${REGION}.amazonaws.com 443"
#"servicequotas.${REGION}.amazonaws.com 80"
"tagging.${REGION}.amazonaws.com 443"
#"tagging.${REGION}.amazonaws.com 80"
# "*.s3.dualstack.${REGION}.amazonaws.com 443"
"s3.dualstack.${REGION}.amazonaws.com 443"

# Openshift Endpoint
"mirror.openshift.com 443"
"storage.googleapis.com/openshift-release 443"
"api.openshift.com 443"

# SRE and Mgmt Endpoint
"api.pagerduty.com 443"
"events.pagerduty.com 443"
"api.deadmanssnitch.com 443"
"nosnch.in 443"

# "*.osdsecuritylogs.splunkcloud.com 443"
"inputs1.osdsecuritylogs.splunkcloud.com 9997"
"inputs2.osdsecuritylogs.splunkcloud.com 9997"
"inputs3.osdsecuritylogs.splunkcloud.com 9997"
"inputs4.osdsecuritylogs.splunkcloud.com 9997"
"inputs5.osdsecuritylogs.splunkcloud.com 9997"
"inputs6.osdsecuritylogs.splunkcloud.com 9997"
"inputs7.osdsecuritylogs.splunkcloud.com 9997"
"inputs8.osdsecuritylogs.splunkcloud.com 9997"
"inputs9.osdsecuritylogs.splunkcloud.com 9997"
"inputs10.osdsecuritylogs.splunkcloud.com 9997"
"inputs11.osdsecuritylogs.splunkcloud.com 9997"
"inputs12.osdsecuritylogs.splunkcloud.com 9997"
"inputs13.osdsecuritylogs.splunkcloud.com 9997"
"inputs14.osdsecuritylogs.splunkcloud.com 9997"
"inputs15.osdsecuritylogs.splunkcloud.com 9997"
"http-inputs-osdsecuritylogs.splunkcloud.com 443"
"sftp.access.redhat.com 22"

# Language Framework
# "maven.org 443"
# "apache.org 443"
# "npmjs.com 443"
# "openshift.io 443"
# "openshift.org 443"
# "docker.io 443"
# "docker.org 443"
# "rubygems.org 443"
# "cpan.org 443"
# "githubusercontent.com 443"
# "githubapp.com 443"
# "cloudfront.net 443"
# "fabric8.io 443"
# "codehaus.org 443"
# "sonatype.org 443"
# "jboss.org 443"
# "jenkins-ci.org 443"
# "jenkins.io 443"
# "bintray.com 443"
# "spring.io 443"
# "eclipse.org 443"
# "fusesource.com 443"
# "eclipse.org 443"
# "quay.io 443"

# Add other domain based on your configuration
#"okta.com 443"


)


RED='\033[0;31m'
NC='\033[0m' # No Color

for endpoint_with_port in "${endpoints[@]}"; do
    domain_and_path="${endpoint_with_port% *}"
    port="${endpoint_with_port#* }"
    
    domain=$(echo $domain_and_path | awk -F/ '{print $1}')
    path=$(echo $domain_and_path | awk -F/ '{print $2}')
    url="https://${domain}:${port}/${path}"
    echo "-----------------------------------"
    echo "Testing connectivity to $url..."
    
    # Always use nc
    if nc -vzw1 $domain $port 2>&1 | grep -q 'succeeded'; then
        echo "Successfully connected to $url using nc"
    else
        echo -e "${RED}Failed to connect to $url using nc${NC}"
    fi

    # Use curl too if there is a path and port is 443
    if [ ! -z "$path" ] && [ "$port" == "443" ]; then
        if curl --connect-timeout 5 --silent --head --fail "$url" > /dev/null 2>&1; then
            echo "Successfully connected to $url using curl"
        else
            echo -e "${RED}Failed to connect to $url using curl${NC}"
        fi
    fi
done

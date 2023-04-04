# ROSA endpoint verifier
Many organizations use firewalls to control egress traffic. For a successful deployment, ROSA requires configuring the firewall to grant access to the domain and port combinations provided in the following link: https://docs.openshift.com/rosa/rosa_planning/rosa-sts-aws-prereqs.html#osd-aws-privatelink-firewall-prerequisites_rosa-sts-aws-prereqs.
To check that your firewall configuration is good for a seamless installtion you can run the following script and tune your firewall based on the result

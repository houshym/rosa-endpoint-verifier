# ROSA endpoint verifier

Many organizations use firewalls to control egress traffic. To achieve a smooth and successful deployment of [ROSA clusters with PrivateLink](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa-aws-privatelink-creating-cluster.html), it's important to configure your firewall properly for ROSA(Red Hat OpenShift on AWS). ROSA clusters with PrivateLink requires configuring the firewall to grant access to the domain and port combinations provided in the following link: https://docs.openshift.com/rosa/rosa_planning/rosa-sts-aws-prereqs.html#osd-aws-privatelink-firewall-prerequisites_rosa-sts-aws-prereqs.

To verify that your firewall is configured correctly, you can create an ec2 instance in all of the subnet that is created for ROSA cluster and run the following script and make any necessary adjustments based on the results. Be sure to update the REGION environment variable with the correct value before running the script.

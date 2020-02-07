#### README ####

Now add AWS credentials to the source.txt file and source it using...

	. source.txt"

Also export AWS_SECRET_ACCESS_KEY and AWS_ACCESS_KEY_ID credentials.

Requires the id_rsa and id_rsa.pub from the /data/terraform_keys directory on
the Jenkins VM to be placed into /root/terraform on the 'Terraform Master Node'.

Then run...
	terraform init; terraform apply -auto-approve
	kubeone config print > config.yaml; kubeone install config.yaml -t .
	export KUBECONFIG=$PWD/mycluster-kubeconfig

...and when finished, destroy it by...

	kubeone reset config.yaml -t .; terraform destroy -auto-approve

For the Metrics service/pod to run on all of the control nodes and to allow the master VM
to take control, the following is required to be run on just one of the initial control
plane nodes...

	kubectl taint nodes --all node-role.kubernetes.io/master-


IAM POLICY

A potential IAM policy is below. There are improvements to be had but it works...

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "iam:GetRole",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "arn:aws:iam::[AWS USER ID NUMBER]:instance-profile/mycluster-host"
        }
    ]
}


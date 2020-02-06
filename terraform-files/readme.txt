#### README ####

Now add AWS credentials to the source.txt file and source it using...

	. source.txt"

Also export AWS_SECRET_ACCESS_KEY and AWS_ACCESS_KEY_ID credentials.

Then run...
	terraform init; terraform apply -auto-approve
	kubeone config print > config.yaml; kubeone install config.yaml -t .
	export KUBECONFIG=$PWD/mycluster-kubeconfig

...and when finished, destroy it by...

	kubeone reset config.yaml -t .; terraform destroy -auto-approve

For the Metrics service/pod to run on each of the control nodes the following is required to be run
on each of those nodes..."

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


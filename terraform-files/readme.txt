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

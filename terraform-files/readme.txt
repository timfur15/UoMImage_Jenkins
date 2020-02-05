#### README ####


Now add AWS credentials to the source.txt file and source it using...

	. source.txt

..and then run...

	terraform init; terraform apply -auto-approve; kubeone install config.yaml -t.

...and destroy by...

	kubeone reset config.yaml -t .; terraform destroy -auto-approve"

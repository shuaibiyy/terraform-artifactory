# Terraformed Artifactory

Deploy [JFrog Artifactory](https://www.jfrog.com/artifactory/) in a [docker container](https://github.com/mattgruter/dockerfile-artifactory) on an AWS EC2 instance using [Terraform](https://www.terraform.io/).

Artifactory data including artifacts are stored in S3. This is achieved by mounting an S3 bucket on the instance's `/data` directory using [s3fs](https://github.com/s3fs-fuse/s3fs-fuse), and then mounting the same directory as a data volume in the Artifactory container.

The terraform script stores the terraform state remotely in an S3 bucket. The Makefile by default sets up a copy of the remote state if it doesn’t exist and then runs either `terraform plan` or `terraform apply` depending on the target.

## Usage

Before you run the Makefile, you should set the following environment variables to authenticate with AWS:
```
$ export AWS_ACCESS_KEY_ID= <your key> # to store and retrieve the remote state in s3.
$ export AWS_SECRET_ACCESS_KEY= <your secret>
$ export AWS_DEFAULT_REGION= <your bucket region e.g. us-west-2>
$ export TF_VAR_access_key=$AWS_ACCESS_KEY # exposed as access_key in terraform scripts
$ export TF_VAR_secret_key=$AWS_SECRET_ACCESS_KEY # exposed as secret_key in terraform scripts
```

You need to change the default values of `s3_bucket` and `key_name` terraform variables defined in `variables.tf` or set them via environment variables:
```
$ export TF_VAR_s3_bucket=<your s3 bucket>
$ export TF_VAR_key_name=<your keypair name>
```
You also need to change the value of `STATEBUCKET` in the Makefile to match that of the `s3_bucket` terraform variable.

### Run 'terraform plan'

    make

### Run 'terraform apply'

    make apply

Upon completion, terraform will output the DNS name of Artifactory, e.g.:
```
artifactory_instance = [ ec2-54-244-233-202.us-west-2.compute.amazonaws.com ]
```
You can then reach Artifactory via your browser at `http://ec2-54-244-233-202.us-west-2.compute.amazonaws.com`.

## Acknowledgements

* The Makefile idea (and the Makefile itself) is taken from this [blog post](http://karlcode.owtelse.com/blog/2015/09/01/working-with-terraform-remote-statefile/).
* The docker image is taken from [this docker hub repo](https://hub.docker.com/r/mattgruter/artifactory/).

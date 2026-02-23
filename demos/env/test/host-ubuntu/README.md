<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Ubuntu host machine testing

This test scenario runs a sequence of checks using AWS automation to start a environment, run the demo setup and check output. A few test cases are defined below and then power user directions to run the scenarios.

## Overview

The testing is assuming it is executed from a x86_64 Chromebook Linux or other Linux environment with VS Code installed.

1) Grab the environment with tools

   - Initially there is a branch with fixups to the upstream project -
       `git clone https://github.com/matthew-l-weber/aws-terraform-dev-container.git`
   - Note: Long term, should be using this `git clone https://github.com/awslabs/aws-terraform-dev-container.git`

2) Make sure your environment has a working docker

    ```bash
    sudo usermod -aG docker $USER
    newgrp docker
    docker run hello-world
    mkdir -p ~/.aws ~/.ssh ~/.azure ~/.config/gcloud
    ```

3) Run `code aws-terraform-dev-container`

   - When/if prompted install the dev-container extension.  Then re-open in container.
   - If errors, hit `><` in vscode and try opening in container again

4) `` ctrl - shift - ` `` to get a bash console (after this, you can switch between the terraform consoles and bash on the right)

    `git clone https://github.com/elisa-tech/wg-aerospace.git`

5) Navigate in a browser where you're logged into aws and click on your username in the upper right, then security creds and scroll down to setup access tokens.  Use those to put in the prompts from the following commands back in the console.

   `aws configure`

6) Setup and run the terraform configuration and test a host

    ```bash
    terraform init -upgrade
    terraform plan
    terraform apply -auto-approve
    ```

7) If success, wait a couple mins and you'll see the output noting test success.  This runs our user.sh which executes native tests of the project

   - At this point, if you need the creds or info on the remote machine, run the apply again and it will verify/list it.
   - The remote machine is still running.  The terraform output shows you the ssh command to connect to the remote system.
   - The terraform output also gives a one line to dump the user.sh that was ran to do the success/fail of the sequence

8) You can check instance and uptime at aws container console

   `aws ec2 describe-instances --query "Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,LaunchTime:LaunchTime}" --output table | grep -v "terminated"`

9) When done and ready to remove all AWS items setup

   `terraform destroy -auto-approve`

   To completely remove all temp files

   `cd demos/env/test/host-ubuntu && rm -rf .terraform* terraform.tfstate* *.tfplan*`

10) Verify things actually are gone

    `aws ec2 describe-instances --query "Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,LaunchTime:LaunchTime}" --output table | grep -v "terminated"`

Note there is lint setup that can be executed in this folder.

```bash
# Make sure to be in the folder with this readme as not all files
# in the project will pass lint yet.
cd demos/env/test/host-ubuntu
pre-commit run --files *
```

## Test cases

The above sequence once active passes the first case commented out below.  With terraform, the following additional sequences will adjust the deployment to test a series of Ubuntu configurations.  The steps after apply above, would still be valid once finishing this sequence.  (e.g., check state and don't leave stuff running.)

NOTE: For each apply, you can dive into cloud init output which has test output (last line from terraform on a successful run.)  On fail, you need to run again w/ disabled log checker via a var to get into the failed system `-var="enable_log_checker=false"` (it doesn't rerun the apply and just drops through to give you connect info.)

You should see output like this from the log as success and if things fail, the fail prints the last few lines from the same log ready for debug.  Success takes `~160 seconds` when these notes were captured so threshold for fail is `200 seconds` in [main.tf](./main.tf).

```txt
JUnit Report generated: test-results-system.xml
JUnit Report moved to: /demo/copilot/src/tests/../../../test-results/
Tests Completed Successfully.
Cloud-init v. 25.2-0ubuntu1~24.04.1 finished at Sun, 08 Feb 2026 14:31:10 +0000. Datasource DataSourceEc2Local.  Up 147.13 seconds
```

### Procedures

```bash
## Test ARM64 - latest stable - Already covered in initial setup
# terraform apply -auto-approve -var="instance_type=t4g.small" -var="ami_id=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"

## Test x86_64 - latest stable -
terraform destroy -auto-approve && terraform apply -auto-approve -var="instance_type=t3a.small" -var="ami_id=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"

# Test ARM64 - older env
terraform apply -auto-approve -var="instance_type=t4g.small" -var="ami_id=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"
(Current "BAD" test case fails but tools/build/run work when manually tested)

# Test x86_64 - older env
terraform apply -auto-approve -var="instance_type=t3a.small" -var="ami_id=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
(Current "BAD" test case fails but tools/build/run work when manually tested)

# Test Docker already installed - Check log for these vs the auto check
terraform destroy -auto-approve && terraform apply -auto-approve -var="instance_type=t3a.small" -var="ami_id=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" -var="user_script=test-docker-present.sh" -var="enable_log_checker=false"
terraform destroy -auto-approve && terraform apply -auto-approve -var="instance_type=t3a.small" -var="ami_id=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" -var="user_script=test-docker-present.sh" -var="enable_log_checker=false"
terraform destroy -auto-approve && terraform apply -auto-approve -var="instance_type=t3a.small" -var="ami_id=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" -var="user_script=test-normal-case.sh" -var="enable_log_checker=false"
```

For new tests, you can find AMIs using a command line this at the container's bash console.

```bash
aws ec2 describe-images --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-*" "Name=state,Values=available" --query 'Images[*].[ImageId,Name]' --output table

aws ec2 describe-images --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-*" "Name=state,Values=available" --query 'Images[*].[ImageId,Name]' --output table
```

## AWS cheat sheet

List instances

`aws ec2 describe-instances --query "Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,LaunchTime:LaunchTime}" --output table | grep -v "terminated"`

Stop and Start instances

```
aws ec2 stop-instances --instance-ids <your-instance-id>
aws ec2 start-instances --instance-ids <your-instance-id>

```

Change instance type

```
# Stop

aws ec2 modify-instance-attribute --instance-id <your-instance-id> --instance-type "{\"Value\": \"t4g.small\"}"

# t4g.small
# t4g.xlarge

# Start
```

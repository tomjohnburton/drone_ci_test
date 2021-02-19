# Drone CI
This repo contains a terraform config to set up a server and runner for drone CI. 

## Set up
**Clone the repo**
```
git clone https://github.com/tomjohnburton/drone_ci_test
```

**Create a `secrets` file**
```
cp secrets.example secrets
```

**Create Github OAuth Application**
![github oauth](https://docs.drone.io/screenshots/github_application_create.png)

**Populate the secrets**

The Drone server is configured using environment variables. This article references a subset of configuration options, defined below. See Configuration for a complete list of configuration options.

`DRONE_GITHUB_CLIENT_ID`
Required string value provides your GitHub oauth Client ID generated in the previous step.

`DRONE_GITHUB_CLIENT_SECRET`
Required string value provides your GitHub oauth Client Secret generated in the previous step.

`DRONE_RPC_SECRET`
```
openssl rand -hex 16 
```

`DRONE_SERVER_HOST`
Required string value provides your external hostname or IP address. If using an IP address you may include the port. For example drone.company.com.

`DRONE_SERVER_PROTO`
Required string value provides your external protocol scheme. This value should be set to http or https. This field defaults to https if you configure ssl or acme.

**Configure variables**

Update the variables in `terraform/variables.tf`.

**Import your default vpc**

For simplicity, the runners are configured in your AWS default VPC. You'll need 
to import it to your `tfstate`.
```
$ cd terraform
$ cd terraform import aws_default_vpc.default vpc-<YOUR_VPC_ID>
```


**Create the server and runners**

```
$ terraform plan -out tfplan
$ terraform apply "tfplan"
```

**Activate your repo**

Head to the url you have specified in previous steps.
Authorize the OAuth app and click on the repo you would like to activate.
You can use this repo to test the set-up is working.

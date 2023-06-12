
# Wild Ryde Serverless App

A project taken from an AWS workshop, based on Serverless architecture. This repo will launch a Serverless application, "Wild Ryde" using a few AWS services such as:

- Amplify
- Cognito
- Lambda
- API Gateway
- DynamoDB

The link to the tutorial can be found towards the end of thsi file. In the workshop, they used the AWS console for the project but we decided to create it all using IaC (Terraform).

***The Static Web Hosting***

_AWS Amplify hosts static web resources including HTML, CSS, JavaScript, and image files which are loaded in the user's browser._

***User Management*** 

_Amazon Cognito provides user management and authentication functions to secure the backend API._

***Serverless Backend***

_Amazon DynamoDB provides a persistence layer where data can be stored by the API's Lambda function._

***RESTful API***

_JavaScript executed in the browser sends and receives data from a public backend API built using Lambda and API Gateway._

## Screenshots

![image](https://github.com/Rizi21/serverless-project-final/assets/93591225/894315c4-4460-4186-a55e-3ab32599abd1)



## Installation

Fork this repo and pull a copy locally on your machine. Ensure you have an AWS account set up (may incur small charges during the project if left running), Terraform installed on your CLI, an IDE (VS Code is my preference).

You will require an access token from your GitHub account, that can be fed into the Amplify.tf file as a variable. _Please ensure you take necessary precautions and use best practices when dealing with credentials._

Once you have set up your access token, run the following commands from the top level of your repo;


```hcl
  Terraform init
  Terraform plan
  Terraform apply $REF Your access token variable file
  Terraform destroy $REF Your access token variable file
```
***Please remember to destroy all resources once complete!***

If you run the commands above for each AWS services folder found at the top level, this will create all the services within a few minutes and the App will be live and hosted on AWS Amplify.
    
## Tech Stack

**Client:** CSS, JS, HTML

**Server:** AWS


## Documentation

[serverless wild-ryde-app](https://aws.amazon.com/getting-started/hands-on/build-serverless-web-app-lambda-apigateway-s3-dynamodb-cognito/)



## Authors

- [@Rizi21](https://github.com/Rizi21))
- [@abdullahbajwa1](https://github.com/abdullahbajwa1)
- [@M-Ryhan-W](https://github.com/M-Ryhan-W)

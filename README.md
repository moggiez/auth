# Auth

Infrastructure for setting up Authentication & Authorization for moggies.io with AWS Cognito.

Main parts:

- Infrastructure code - provides Cognito infrastructure, but also lambda triggerd by Cognito, a DNS record in Route53
- Lambdas - triggers fired upon different events in the user lifecycle like: user has confirmed account, user will be sent a confirmation email, user will be sent a password recovery email

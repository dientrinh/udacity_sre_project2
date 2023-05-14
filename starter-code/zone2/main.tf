locals {
   account_id = data.aws_caller_identity.current.account_id

   name   = "udacity"
   region = "us-west-1"
   tags = {
     Name      = local.name
     Terraform = "true"
   }
 }

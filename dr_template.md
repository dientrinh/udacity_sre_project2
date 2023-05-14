# Infrastructure

## AWS Zones
1 - Zone 1 (Region: us-east-2): 
  AZs: us-east-2a, us-east-2b, us-east-2c
2 - Zone 2 (Region: us-west-2): 
  AZs: us-west-1a, us-west-1b

## Servers and Clusters
- 1 Web server running in each region. Web servers are running in auto scalling group
- 1 EKS cluster
- 2 RDS clusters. Primary cluster in zone1 and replica cluster in zone2. Each cluster runs 2 rds instances. 1 read instance, 1 write instance
### Table 1.1 Summary
| Asset       | Purpose                                                                                                                    | Size                                                                   | Qty                                                             | DR                                                                                                           |
|-------------|----------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|-----------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| Asset name  | Brief description                                                                                                          | AWS size eg. t3.micro (if applicable, not all assets will have a size) | Number of nodes/replicas or just how many of a particular asset | Identify if this asset is deployed to DR, replicated, created in multiple locations or just stored elsewhere |
| AMI         | Used to create web server running on EC2                                                                                   | Not applicable                                                         | 2                                                               | Deploy in both us-east and us-west-1 regions                                                                 |
| Github repo | Code based repo to manage, track and review code of IAC code and other stuff such as screenshots, docs etc                 | Not applicable                                                         | 1                                                               | Deploy in both us-east and us-west-1 regions                                                                 |
| Key Pairs   | Key to provide the administration access to web server instance in EC2                                                     | Not applicable                                                         | 2                                                               | Implement in both us-east and us-west-1 regions                                                              |
| EC2         | Instances to run the web server and EKS cluster nodes                                                                      | t3.micro for web server  & t3.medium for node group                    | 10                                                              | Implement in both us-east and us-west-1 regions                                                              |
| RDS cluster | A cluster to manage database instances running database for web server                                                     | Not applicable                                                         | 2                                                               | Deploy Primary RDS in us-east-2 and replica RDS in us-west-1                                                 |
| RDS instance| Store database and provide connectivity for web server                                                                     | db.t2.small                                                            | 4                                                               | Deploy Primary RDS in us-east-2 and replica RDS in us-west-1                                                 |
| EKS cluster | Run Kubernetes to organize, operate, scale container applications                                                          | Not applicable                                                         | 2                                                               | Deploy in both us-east and us-west-1 regions                                                                 |
| EKS nodes   | A node group is one or more EC2 that are deployed in an EC2 Auto Scaling group. Pods are scheduled on Node                 | t3.medium                                                              | 4                                                               | Deploy in both us-east and us-west-1 regions                                                                 |
| VPC         | Isolated area on AWS where you can launch AWS resources in a virtual network that you define| CIDR range                   | Not applicable                                                         | 2                                                               | Deploy in both us-east and us-west-1 regions                                                                 |
| ALB         | Distributes end-users incoming traffic across multiple targets                                                             | Not applicable                                                         | 2                                                               | Deploy in both us-east and us-west-1 regions                                                                 |
  

### Descriptions
- AMI: An master image in AWS which is used to create web server running on EC2. We are 2 AMIs for 2 regions(us-east-2, us-west-1). AMIs are clone from AMI which Udacity provided.
- Github repo : My personal repo which is used to manage, track and review code of IAC code and provide the access the instructors of Udacity to review the submit project code.
- Key Pairs: AWS key to able to access EC2 web server. Created 2 key pairs in 2 regions named udacity to use to access web server running on EKS
- EC2 : AWS Cloud instance to run web server and EKS node. Each region will run at least 3 instances for web server and 2 instances for EKS for HA
- RDS cluster: AWS RDS cluster to manage database instances. Create 2 clusters in 2 regions. The primary cluster in us-east-2 and the replica cluster in us-west-1
- RDS instance: Database intance running in RDS cluster which store database and provide connectivity for web server. Each regions will have 2 instances. 1 for write and 1 for read
- EKS cluster: Kubernetes cluster running on AWS. Create 2 clusters in 2 regions(us-east-2, us-west-1). EKS version is 1.25
- EKS nodes: Amazon EKS managed node groups automate the provisioning and lifecycle management of nodes (Amazon EC2 instances) for Amazon EKS Kubernetes clusters. With Amazon EKS managed node groups, you don't need to separately provision or register the Amazon EC2 instances that provide compute capacity to run your Kubernetes applications. You can create, automatically update, or terminate nodes for your cluster with a single operation. Node updates and terminations automatically drain nodes to ensure that your applications stay available.
- VPC: A virtual private network setup in a 2 regions for the infrastructure. Create 2 VPCs in 2 regions(us-east-2, us-west-1). A VPC contains network parts such as subnets, firewalls, IP addresses, and more..
- ALB: Elastic Load Balancing automatically distributes your incoming traffic across multiple targets, such as EC2 instances, containers, and IP addresses, in one or more Availability Zones. It monitors the health of its registered targets, and routes traffic only to the healthy targets. Elastic Load Balancing scales your load balancer capacity automatically in response to changes in incoming traffic.

## DR Plan
### Pre-Steps:
List steps you would perform to setup the infrastructure in the other region. It doesn't have to be super detailed, but high-level should suffice.
1. Configure zone1 and zone2 with the same configurations.
2. Ensure the infrastructure is set up and working in the DR site..
3. Using infrastructure as code with Terraform to provisioning infrastructure

## Steps:
You won't actually perform these steps, but write out what you would do to "fail-over" your application and database cluster to the other region. Think about all the pieces that were setup and how you would use those in the other region
1 - Create a cloud load balancer and point DNS to the load balancer. This way you can have multiple instances behind 1 IP in a region. During a failover scenario, you would fail over the single DNS entry at your DNS provider to point to the DR site. This is much more intelligent than pointing to a single instance of a web server.
2 - Have a replicated database and perform a failover on the database. While a backup is good and necessary, it is time-consuming to restore from backup. In this DR step, you would have already configured replication and would perform the database failover. Ideally, your application would be using a generic CNAME DNS record and would just connect to the DR instance of the database.



# 1. ECS with ALB, RDS and SecretsManager

    a. Infrastructure Requirements:
        i. ECS
            1. Create an ECS Cluster with the service running in Private
            Subnets.
            2. Services
                a. WordPress Docker Image
                b. Custom microservice (a lightweight Node.js
                application responding with “Hello from
                Microservice”). Share the Node.js code and DockerFile
                too.

            3. Setup auto scaling based on CPU and Memory.
        
        ii. RDS
            1. Choose the appropriate instance type to be used by
            WordPress as a database.
            2. Create custom user and password in RDS to be used with
            Wordpress that do not auto rotate.
            3. Configure automated backups.
            4. RDS instance should be deployed in the Private Subnets.

        iii. SecretsManager

            1. Store the RDS database credentials as secrets.

        iv. IAM and Security

            1. Configure the ECS task definition to use the secrets stored
            in AWS SecretsManager, ensuring the WordPress securely
            connects to the RDS instance.
            2. Use IAM roles to grant the ECS service the necessary
            permissions to access secrets from AWS SecretsManager.
            3. Security Groups should be the least privilege.

        v. Application Load Balancer (ALB) & Domain Mapping
            1. Set up an Application Load Balancer (ALB) in Public
            Subnets to handle incoming HTTP/HTTPS traffic.
            2. Set up SSL certificate. The website should not open HTTP.
            3. HTTP traffic should be redirected to HTTPS.
            4. Configure the ALB to associate with a domain name.
            "wordpress.<domain-name>"
            "microservice.<domain-name>"
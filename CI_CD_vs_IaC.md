# CI/CD vs Infrastructure as Code (IaC)

## Overview

**CI/CD (Continuous Integration/Continuous Deployment)** and **IaC (Infrastructure as Code)** are complementary DevOps practices that serve different purposes but often work together in modern software delivery pipelines.

---

## Key Differences

| Aspect | CI/CD | IaC |
|--------|-------|-----|
| **Primary Purpose** | Automate software build, test, and deployment | Automate infrastructure provisioning and configuration |
| **Focus** | Application code lifecycle | Infrastructure lifecycle |
| **What it manages** | Code compilation, testing, artifact creation, deployment | Servers, networks, databases, cloud resources |
| **When it runs** | On code commits, scheduled builds | On infrastructure changes, initial setup |
| **Outcome** | Deployed application | Provisioned and configured infrastructure |

---

## CI/CD Tools

### BitBucket Pipelines

**What it is:** Built-in CI/CD service integrated with Atlassian BitBucket for automating builds and deployments.

#### Key Features
- **Integrated with BitBucket:** Native integration with BitBucket repositories
- **YAML Configuration:** Pipeline defined in `bitbucket-pipelines.yml`
- **Docker-based:** Each step runs in a Docker container
- **Branch-specific pipelines:** Different pipelines for different branches
- **Built-in deployments:** Track deployments across environments

#### Strengths
- ✅ Seamless integration with BitBucket repositories
- ✅ No additional setup required if using BitBucket
- ✅ Built-in Docker support
- ✅ Simple YAML syntax
- ✅ Integrated with Jira for tracking

#### Limitations
- ❌ Locked into Atlassian ecosystem
- ❌ Limited customization compared to Jenkins
- ❌ Monthly build minutes limits on free tier
- ❌ Less flexible than dedicated CI/CD tools

#### Example Configuration
```yaml
# bitbucket-pipelines.yml
image: maven:3.8.1

pipelines:
  default:
    - step:
        name: Build and Test
        caches:
          - maven
        script:
          - mvn clean install
          - mvn test
    
  branches:
    master:
      - step:
          name: Build and Test
          script:
            - mvn clean package
      - step:
          name: Deploy to Production
          deployment: production
          script:
            - pipe: atlassian/aws-elasticbeanstalk-deploy:1.0.0
              variables:
                AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
                AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
                APPLICATION_NAME: 'my-app'
                ENVIRONMENT_NAME: 'production'
```

---

### Jenkins

**What it is:** Open-source automation server for building, testing, and deploying software with extensive plugin ecosystem.

#### Key Features
- **Extensible Plugin Architecture:** 1800+ plugins available
- **Pipeline as Code:** Jenkinsfile (Declarative or Scripted)
- **Distributed Builds:** Master-agent architecture
- **Freestyle & Pipeline Jobs:** Multiple job types
- **Blue Ocean UI:** Modern, visual pipeline interface

#### Strengths
- ✅ Highly customizable and extensible
- ✅ Large community and plugin ecosystem
- ✅ Self-hosted (full control)
- ✅ Supports complex workflows
- ✅ Integration with virtually any tool
- ✅ Free and open-source

#### Limitations
- ❌ Requires infrastructure to host
- ❌ Complex setup and maintenance
- ❌ UI can be outdated (without Blue Ocean)
- ❌ Plugin compatibility issues
- ❌ Steep learning curve

#### Example Pipeline
```groovy
// Jenkinsfile
pipeline {
    agent any
    
    tools {
        maven 'Maven 3.8.1'
        jdk 'JDK 11'
    }
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        APP_NAME = 'my-app'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/user/repo.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    docker.build("${APP_NAME}:${BUILD_NUMBER}")
                }
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
            }
        }
    }
    
    post {
        success {
            slackSend color: 'good', message: "Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
        failure {
            slackSend color: 'danger', message: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
    }
}
```

---

## Infrastructure as Code (IaC) Tools

### Terraform

**What it is:** Declarative IaC tool for provisioning and managing infrastructure across multiple cloud providers using HashiCorp Configuration Language (HCL).

#### Key Features
- **Multi-Cloud Support:** AWS, Azure, GCP, and 1000+ providers
- **Declarative Syntax:** Describe desired state, not steps
- **State Management:** Tracks infrastructure state
- **Plan & Apply:** Preview changes before applying
- **Modules:** Reusable infrastructure components

#### Strengths
- ✅ Cloud-agnostic (works across providers)
- ✅ Large provider ecosystem
- ✅ Strong community and documentation
- ✅ Immutable infrastructure approach
- ✅ Clear dependency management
- ✅ Preview changes before applying

#### Limitations
- ❌ State file management complexity
- ❌ Steep learning curve for HCL
- ❌ Not ideal for configuration management
- ❌ Limited error handling
- ❌ Can be verbose for complex setups

#### Example Configuration
```hcl
# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# Subnet
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public[0].id
  
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name        = "${var.project_name}-app-server"
    Environment = var.environment
  }
  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              EOF
}

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output
output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}
```

```hcl
# variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
```

---

### Ansible

**What it is:** Agentless configuration management and automation tool using YAML playbooks for configuring and managing servers.

#### Key Features
- **Agentless:** Uses SSH, no agents required
- **YAML Playbooks:** Simple, human-readable syntax
- **Idempotent:** Safe to run multiple times
- **Modules:** 1000+ built-in modules
- **Inventory Management:** Group and manage hosts

#### Strengths
- ✅ Simple to learn and use
- ✅ No agent installation required
- ✅ Excellent for configuration management
- ✅ Great for application deployment
- ✅ Procedural approach (step-by-step)
- ✅ Strong community support

#### Limitations
- ❌ Less suitable for infrastructure provisioning
- ❌ Can be slow for large-scale operations
- ❌ SSH dependency (network overhead)
- ❌ Limited state tracking
- ❌ Procedural nature can lead to drift

#### Example Playbook
```yaml
# deploy_application.yml
---
- name: Deploy Java Application
  hosts: app_servers
  become: yes
  vars:
    app_name: my-spring-app
    app_version: 1.0.0
    app_port: 8080
    java_version: 11

  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
      when: ansible_os_family == "Debian"

    - name: Install Java
      apt:
        name: "openjdk-{{ java_version }}-jdk"
        state: present
      when: ansible_os_family == "Debian"

    - name: Create application directory
      file:
        path: "/opt/{{ app_name }}"
        state: directory
        mode: '0755'

    - name: Create application user
      user:
        name: appuser
        system: yes
        shell: /bin/false
        home: "/opt/{{ app_name }}"

    - name: Download application JAR
      get_url:
        url: "https://artifacts.company.com/{{ app_name }}-{{ app_version }}.jar"
        dest: "/opt/{{ app_name }}/{{ app_name }}.jar"
        mode: '0644'
      notify: restart application

    - name: Create systemd service file
      template:
        src: templates/app.service.j2
        dest: "/etc/systemd/system/{{ app_name }}.service"
        mode: '0644'
      notify: 
        - reload systemd
        - restart application

    - name: Enable and start application service
      systemd:
        name: "{{ app_name }}"
        enabled: yes
        state: started

    - name: Configure firewall
      ufw:
        rule: allow
        port: "{{ app_port }}"
        proto: tcp
      when: ansible_os_family == "Debian"

    - name: Install and configure nginx
      block:
        - name: Install nginx
          apt:
            name: nginx
            state: present

        - name: Configure nginx reverse proxy
          template:
            src: templates/nginx.conf.j2
            dest: "/etc/nginx/sites-available/{{ app_name }}"
          notify: restart nginx

        - name: Enable nginx site
          file:
            src: "/etc/nginx/sites-available/{{ app_name }}"
            dest: "/etc/nginx/sites-enabled/{{ app_name }}"
            state: link

        - name: Start nginx
          systemd:
            name: nginx
            state: started
            enabled: yes

  handlers:
    - name: reload systemd
      systemd:
        daemon_reload: yes

    - name: restart application
      systemd:
        name: "{{ app_name }}"
        state: restarted

    - name: restart nginx
      systemd:
        name: nginx
        state: restarted
```

```yaml
# inventory.yml
all:
  children:
    app_servers:
      hosts:
        app-server-1:
          ansible_host: 10.0.1.10
        app-server-2:
          ansible_host: 10.0.1.11
    web_servers:
      hosts:
        web-server-1:
          ansible_host: 10.0.2.10
  
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

---

## When to Use What

### Use CI/CD (BitBucket/Jenkins) When:
- ✅ Automating application build and test processes
- ✅ Deploying application code changes
- ✅ Running automated tests
- ✅ Creating build artifacts
- ✅ Implementing deployment pipelines
- ✅ Continuous delivery of software updates

### Use IaC (Terraform/Ansible) When:
- ✅ Provisioning cloud infrastructure
- ✅ Configuring servers and systems
- ✅ Managing infrastructure at scale
- ✅ Ensuring consistency across environments
- ✅ Version controlling infrastructure
- ✅ Implementing disaster recovery

---

## How They Work Together

### Typical DevOps Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                    COMPLETE DEVOPS PIPELINE                      │
└─────────────────────────────────────────────────────────────────┘

1. INFRASTRUCTURE PROVISIONING (Terraform)
   ↓
   └─→ Create VPC, Subnets, Security Groups
   └─→ Provision EC2 instances, Load Balancers
   └─→ Set up RDS databases, S3 buckets
   └─→ Configure networking and DNS

2. CONFIGURATION MANAGEMENT (Ansible)
   ↓
   └─→ Install required software (Java, Docker, etc.)
   └─→ Configure system settings
   └─→ Set up monitoring agents
   └─→ Apply security hardening

3. CI/CD PIPELINE (Jenkins/BitBucket)
   ↓
   └─→ Developer commits code
   └─→ CI triggers build and tests
   └─→ Create Docker images
   └─→ Push to artifact repository
   └─→ Deploy to provisioned infrastructure
   └─→ Run smoke tests
   └─→ Notify team

4. ONGOING UPDATES
   ↓
   ├─→ Application changes → CI/CD pipeline
   └─→ Infrastructure changes → Terraform + Ansible
```

### Integration Example

```groovy
// Jenkinsfile with Terraform and Ansible integration
pipeline {
    agent any
    
    stages {
        stage('Provision Infrastructure') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform apply tfplan'
                    script {
                        env.APP_SERVER_IP = sh(
                            script: 'terraform output -raw instance_public_ip',
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }
        
        stage('Configure Servers') {
            steps {
                dir('ansible') {
                    sh """
                        ansible-playbook -i '${env.APP_SERVER_IP},' \
                        configure_server.yml
                    """
                }
            }
        }
        
        stage('Build Application') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Deploy Application') {
            steps {
                dir('ansible') {
                    sh """
                        ansible-playbook -i '${env.APP_SERVER_IP},' \
                        deploy_application.yml \
                        -e "app_jar_path=../target/app.jar"
                    """
                }
            }
        }
    }
}
```

---

## Tool Comparison Matrix

| Feature | BitBucket Pipelines | Jenkins | Terraform | Ansible |
|---------|-------------------|---------|-----------|---------|
| **Primary Use** | CI/CD | CI/CD | Provisioning | Configuration |
| **Learning Curve** | Easy | Medium-Hard | Medium | Easy-Medium |
| **Setup Complexity** | Very Easy | Medium-Hard | Easy | Easy |
| **Hosting** | Cloud | Self-hosted | CLI | CLI |
| **Language** | YAML | Groovy/DSL | HCL | YAML |
| **Idempotent** | N/A | N/A | Yes | Yes |
| **State Management** | N/A | N/A | Yes | No |
| **Agent Required** | No | Yes (agents) | No | No |
| **Multi-Cloud** | N/A | N/A | Yes | Yes |
| **Best For** | BitBucket users | Complex pipelines | Infrastructure | Server config |

---

## Best Practices

### CI/CD Best Practices
1. **Keep pipelines fast** - Parallel execution, cache dependencies
2. **Fail fast** - Run quick tests first
3. **Pipeline as Code** - Version control pipeline definitions
4. **Immutable artifacts** - Build once, deploy many times
5. **Environment parity** - Keep dev/staging/prod similar
6. **Automate testing** - Unit, integration, e2e tests
7. **Secure secrets** - Use vault or secrets management
8. **Monitor pipelines** - Track metrics and failures

### IaC Best Practices
1. **Version control everything** - All IaC code in Git
2. **Use modules/roles** - DRY principle, reusability
3. **Separate environments** - Different state files/inventories
4. **Plan before apply** - Review changes before execution
5. **Remote state** - Store Terraform state remotely
6. **Idempotent operations** - Safe to run multiple times
7. **Documentation** - Comment complex logic
8. **Testing** - Use tools like Terratest, Molecule

---

## Real-World Example: E-commerce Application

### Infrastructure Setup (Terraform)
```hcl
# Create VPC, Subnets, Security Groups
# Provision EKS cluster
# Set up RDS PostgreSQL database
# Configure ALB (Application Load Balancer)
# Set up S3 for static assets
# Create ElastiCache for Redis
```

### Server Configuration (Ansible)
```yaml
# Install Kubernetes CLI tools
# Configure monitoring (Prometheus, Grafana)
# Set up log aggregation (ELK stack)
# Apply security policies
# Configure backup jobs
```

### Application Deployment (Jenkins)
```groovy
# Build Spring Boot application
# Run unit and integration tests
# Build Docker image
# Push to ECR
# Deploy to EKS using Helm
# Run smoke tests
# Update deployment tracking
```

---

## Choosing the Right Tool

### Choose BitBucket Pipelines if:
- Already using BitBucket for source control
- Need simple, straightforward CI/CD
- Want minimal setup and maintenance
- Working with small to medium projects
- Prefer cloud-hosted solution

### Choose Jenkins if:
- Need maximum flexibility and customization
- Have complex build requirements
- Want self-hosted solution
- Need extensive plugin ecosystem
- Have dedicated DevOps team

### Choose Terraform if:
- Provisioning multi-cloud infrastructure
- Need strong state management
- Want declarative infrastructure definition
- Require infrastructure versioning
- Working with cloud resources

### Choose Ansible if:
- Configuring existing servers
- Need simple, agentless automation
- Deploying applications
- Managing configuration drift
- Prefer procedural approach

---

## Common Pitfalls

### CI/CD Pitfalls
- ❌ Overly complex pipelines
- ❌ Hardcoded secrets and credentials
- ❌ No rollback strategy
- ❌ Insufficient testing in pipeline
- ❌ Not monitoring pipeline health

### IaC Pitfalls
- ❌ Manual changes to managed infrastructure
- ❌ Not using version control
- ❌ Shared state file conflicts (Terraform)
- ❌ Not testing infrastructure changes
- ❌ Ignoring configuration drift

---

## Conclusion

**CI/CD and IaC are complementary, not competing technologies:**

- **CI/CD (BitBucket, Jenkins)** focuses on automating the software delivery lifecycle
- **IaC (Terraform, Ansible)** focuses on automating infrastructure and configuration management

**The modern DevOps stack typically includes:**
- **Terraform** for infrastructure provisioning
- **Ansible** for configuration management and application deployment
- **Jenkins or BitBucket Pipelines** for CI/CD orchestration
- Integration between all three for end-to-end automation

**Key Takeaway:** Use Terraform to create infrastructure, Ansible to configure it, and Jenkins/BitBucket to build and deploy your applications on that infrastructure.

---

## Additional Resources

### Official Documentation
- [BitBucket Pipelines Docs](https://support.atlassian.com/bitbucket-cloud/docs/get-started-with-bitbucket-pipelines/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Terraform Registry](https://registry.terraform.io/)
- [Ansible Documentation](https://docs.ansible.com/)

### Learning Resources
- Jenkins Pipeline Tutorial
- Terraform Associate Certification
- Ansible for DevOps (Book)
- CI/CD Best Practices

### Community
- Jenkins Community Forum
- Terraform Discuss
- Ansible Google Group
- DevOps Stack Exchange

---

*Last Updated: February 2026*

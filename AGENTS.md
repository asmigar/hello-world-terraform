# 🧠 AGENTS.md: Repository Constraints & Conventions

## 🔴  Critical Security/Networking Constraints (High Signal)

*   **SG to SG Communication:** Internal traffic (e.g., from ECS services to monitoring services) **must** be secured using Security Group IDs (`aws_security_group.id`), **never** broad CIDR blocks.
*   **ECS Task Ingress:** The ECS service (`ecs-container` SG) is secured to only accept traffic from the Load Balancer's security group (`aws_security_group.allow_http_lb.id`). General internet ingress is blocked.
*   **EC2 Node Management:** Remote management via SSH to the EC2 nodes (`ecs_node_sg`) is only permissible via the dedicated `ec2-instance-connect-endpoint` security group, which requires a specific, non-standard `aws_vpc_security_group_egress_rule` for connection back.
*   **Outbound Traffic:** For the primary container workload, generalized Internet egress is explicitly restricted (see `ecs-container` SG). All outbound communication must pass through required and defined internal Security Group relationships, not public internet access.

## ⚙️ Operational Environment (High Signal)

*   **Tooling:** This repository is not configured via standard Terraform CLI; it must be managed using **Terragrunt** wrappers (e.g., `terragrunt run-all`). Do not attempt direct `terraform` commands at the top level.


## 🛠️ Agent Usage Directives

*   **Trust Code:** Trust the Terraform configuration (`*.tf`) as the source of truth for resource constraints (e.g., specific SG rules). Do not guess network topology.
*   **Scope:** This repository defines mostly the infrastructure layer; it does contain application business logic which is under [here](infra/modules/docker_image/src).

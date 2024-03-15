# Terraform Modules Repository

Welcome to the Terraform Modules Repository! This repository contains a collection of reusable Terraform modules for various purposes such as provisioning resources on AWS, installing applications on Kubernetes, executing scripts through SSH, and more.

## Table of Contents

- [Modules](#modules)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Modules

### AWS Modules

- **[alarm_to_sns](./aws/alarm_to_sns/README.md)**: Terraform module for sending CloudWatch alarms to SNS topics on AWS.
- **[glue_subnets](./aws/glue_subnets/README.md)**: Terraform module for creating subnets for AWS Glue resources.
- **[new_role_creator](./aws/new_role_creator/README.md)**: Terraform module for creating new IAM roles on AWS.
- **[new_user_creator](./aws/new_user_creator/README.md)**: Terraform module for creating new IAM users on AWS.
- **[route53_records](./aws/route53_records/README.md)**: Terraform module for managing Route 53 DNS records on AWS.
- **[send_sns_to_teams](./aws/send_sns_to_teams/README.md)**: Terraform module for sending SNS notifications to Microsoft Teams on AWS.

### Kubernetes Modules

- **[argocd](./argocd/README.md)**: Terraform module for installing ArgoCD on Kubernetes clusters.

### SSH Modules

- **[ssh-execute](./ssh-execute/README.md)**: Terraform module for executing scripts through SSH connections.

## Usage

Each module includes a README file with detailed documentation on usage and configuration options. Additionally, the `examples` folder in each module contains Terraform configurations that demonstrate how to use the module.

To use a module, follow these steps:

1. Navigate to the module directory of your choice.
2. Refer to the README file for instructions on how to use the module and configure its inputs.
3. Explore the `examples` folder to find sample Terraform configurations (`terragrunt.hcl`) that demonstrate the module's usage.

## Contributing

Contributions to this repository are welcome! If you have ideas for new modules or improvements to existing ones, please open an issue or pull request on GitHub.

For guidelines on contributing, please refer to the [CONTRIBUTING.md](CONTRIBUTING.md) file.

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

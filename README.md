####	Terragrunt

**Terragrunt** is a thin wrapper for Terraform that implements the practices advocated by the Terraform: Up and Running book. We've found **Terragrunt** helpful as it encourages versioned modules and reusability for different environments with some handy features, including recursive code execution in subdirectories.



```

├── development
├── production
│   ├── route53
│   │   └── terragrunt.hcl
│   └── vpc
│       └── terragrunt.hcl
└── terraform-modules
    ├── route53
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── vpc
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```



Terragrunt version v0.27.1

Terraform v0.14.4
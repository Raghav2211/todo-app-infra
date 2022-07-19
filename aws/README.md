# Deploy Todo Application
- [v1.0.0](v1_0_0.md)
- [v2.0.0](v2_0_0.md)

## Folder layout 
```
.
├── lab
│   ├── global
│   │   └── route53
│   └── us-east-2
│       └── dev
│           ├── apps
│           │   ├── external-dns
│           │   └── todo
│           │       └── templates
│           ├── database
│           │   ├── mongo
│           │   │   └── todo
│           │   └── mysql
│           │       └── todo
│           ├── eks
│           └── vpc
├── modules
│   ├── alb
│   ├── apps
│   │   ├── external-dns
│   │   └── values
│   ├── asg
│   ├── database
│   │   ├── mongo
│   │   └── mysql
│   │       └── example
│   ├── eks
│   │   └── examples
│   │       └── complete-cluster
│   ├── network
│   │   ├── example
│   │   │   └── complete-network
│   │   └── test
│   └── tf-state
├── packer
│   └── todo
│       ├── scripts
│       └── services
├── remote-state
│   └── lab
│       └── us-east-2
└── test
```
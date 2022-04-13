# azdo-terraform-pipeline-templates
Azure Pipelines templates repo for Terraform pipelines

Examples and documentation:
* [Parameters for infrastructure configuration pipelines](docs/infrastructure_params.md)
* [Example template usage for infrastructure configuration pipelines](docs/infrastructure_example.md)
* [Parameters for module build pipelines](docs/module_params.md)
* [Example template usage for module build pipelines](docs/module_example.md)

## Updating these templates

1. Create a feature branch. Recommend including the major.minor version in the name i.e. feature/6.2/my-new-feature
2. Thorougly test the feature branch from a test repository to ensure Terraform infra and module pipelines will continue to function (if this is not a breaking change which would result in a new major version number).
3. Submit a PR to master branch. Once the PR is approved the pipeline will run linting and upon successful merge to master will tag the repo with your current major.minor.patch version. Patch is a automatic counter managed by the pipeline.
4. You will need to manually create the stable tag i.e. v6.2-stable. If this is not the first v6.2 revision, you will first need to delete the existing v6.2-stable. Always include the exact major.minor.patch version in the description of the stable tag.

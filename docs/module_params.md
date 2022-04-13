# Parameters for Terraform module builds

Any parameters where the default states "n/a" means that the pipeline will not run unless you supply a valid value.

## Common parameters
| Name | Type | Default | Description |
|---|---|---|---|
| tfe_token | string | $(tfe_team_token) | A Terraform API token with permissions to the workspace being used. Also allows access to the private Terraform module registry. |
| module_team_name | string | n/a | The name of the team that owns and supports the module. i.e. "myteam". Please don't put "core-myteam-etc" as this just makes the name of the module longer than necessary. |
| module_provider | string | n/a | The name of the provider required by the module, i.e. "azurerm" |
| module_name | string | n/a | The name of the module. i.e. "aks" |
| module_version_number | string | n/a | The version number of the module. Must be different each time the module is published. |
| terraform_version | string | n/a | The version of Terraform to use with Terratest. |
| arm_credentials | object | [] | Azure SPN credentials to be used by Terratest. |
| terratest_timeout | string | "30m" | Timeout for Terratest. Must be enough to allow the entire test to run. |
| golang_version | string | "1.16.5" | The golang version to be used with Terratest. Must be 1.16.0 or higher. |

## Uncommon parameters

| Name | Type |  Default | Description |
|---|---|---|---|
| tf_run_dir | string | "examples/build" | Directory to use when performing a plan/apply. In a module pipeline this is used by Terratest. |
| module_root_dir | string | $(System.DefaultWorkingDirectory) | The root directory of the module. Nornmally this shoud be left alone and will be the root directory of the module repository. |
| tests_dir | string | "test" | Folder in the module repository that contains the Terratest code to be used in the pipeline. |
| build_any_branch | string | "no" | Allows the pipeline to build and publish modules in non-main branches if test stage completes successfully. |
| test_pre_steps | stepList | [] | Optional pipeline steps to inject before test stage steps are run. |
| stage_name_prefix | string | "" | Optional stage name prefix. Only really useful if you're building multiple modules in the same repo which is not typical or recommnded. |
| stage_depends_on | object | [] | Used to make sure templated steps depend on user supplied stages. |
| vault_approle_name | string | "" | Optional Vault approle name to be used to retrieve secrets from Vault inside Terratest. |
| source_directory | string | $(Build.SourcesDirectory) | The source directory for the module code. |

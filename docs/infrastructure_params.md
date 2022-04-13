# Parameters for Terraform infrastructure configurations

Any parameters where the default states "n/a" means that the pipeline will not run unless you supply a valid value.

## Common parameters
| Name | Type | Default | Description |
|---|---|---|---|
| tfe_token | string | $(tfe_team_token) | A Terraform API token with permissions to the workspace being used. Also allows access to the private Terraform module registry. |
| terraform_version | string | n/a | The version of Terraform to use in the pipeline stages. If using a TFE remote backend with remote exection mode this will also set the remote workspace to use this version. |
| workspace | string | n/a | The workspace name. Will be appended to the value of "prefix" defined in backend.tf. |
| azdo_approval_environment | string | n/a | The Azure DevOps approval environment to use for the deploy (apply). |
| arm_credentials | object | [] | Azure SPN credentials |
| tfvars_files | object | [] | Terraform variable definition file paths. Path is relative to the root of the repository. |


## Uncommon parameters

| Name | Type |  Default | Description |
|---|---|---|---|
| tf_run_dir | string | "/" | The directory to run Terraform in. Default is root directory of the repository. |
| depends_on | object | [] | Optional dependency for first generated stage. |
| apply_timeout | string | 60 | Timeout for the pipeline run. For long running resources, set the timeout time in minutes as required. |
| apply_any_branch | string | "no" | Optional and potentially dangerous. Allows "apply" stage to run without approvals as long as the workspace name does not contain "prod". |
| tfe_environment | string | prod | The environment determines which TFE host to use for remote runs and state storage. |
| tf_execution_mode | string | local | The execution mode, local or remote. The default is remote but local is recommended going forward. This only applies when using TFE. |
| venafi_user | string | '' | Required only if needing to use the Venafi provider in Terraform. Must include venafi_user AND venafi_pass to function. |
| venafi_pass | string | '' | Required only if needing to use the Venafi provider in Terraform. Must include venafi_user AND venafi_pass to function. |
| pre_steps | object | [] | Optional pre-steps. |
| post_apply_steps | object | [] | Optional post-apply steps. |

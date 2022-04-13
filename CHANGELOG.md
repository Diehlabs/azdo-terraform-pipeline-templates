# CHANGELOG

## v6.2
If using 6.x templates these are the oldest you should be using.
* Add ability to use tvfars files to supply variables.
* Removed auto-generation of remote backend configuration file.
* Removed tflint, if desired this can be done client side.
* Removed optional yaml variables parameter. There's no need to do this anymore with the new tfvars_files parameter. Variables from other sources such as Azure DevOps repositories or variable groups must still use a terraform.auto.tfvars.template file for pipeline token replacement and will complicate working with state and plans locally.

## v6.1
* Add arm_credentials parameter for infra and module templates. Allows passing of SPN detauls for use as environment variables, which means you can remove SPN variables from the AzureRM provider block. User can authenticate using Azure CLI for local plans without altering source code.
* Go mod and sum files can now be included in source code for Terratest to allow control over Go module versions.

## v6.0
* Add combined stages files to generate all necessary related stages, simplifying consumer pipelines.
* Add jobs to be consumed by new stages.
* Change all variables and parameters to snake case for consistency.
* Combine infrastructure test and plan steps to reduce repeat operations and speed up pipeline runs.
* Use filename .tflint.hcl (standard) versus tflint_config.hcl. Works with both until next templates version for backward compatibility.
* The default golang version for Terratest is now 1.16.12. You will need to update your tests to account for syntax differences.
* Removed Terrascan
* Added Checkov
* Added pipeline caching for the .terraform folder created by `terraform init`
* Added templates for interacting with HashiCorp Vault
* Removed variable substition in *.go files (bad practice)
* Added dynamic TFE token for publishing modules
* Added apply_timeout param to infra stages with a default of 60 (minutes)

## v5.5.0
* Add Vault approle env vars - if pipeline vars are supplied, these will be added to the env during Terratest.

## v5.4.0
General
* Added check for TFE_TOKEN variable in step-terraformrc.yml to allow users to easier identify a missing value.
* Added tests for templates themselves to reduce amount of manual testing required with template updates. This work will be ongoing.
* Add steps to delete tags - will be used later for automated testing of pipeline templates themselves
* Add pre-commit config file
* Add pipeline that executes the pre-commit hooks

Infrastructure Templates
* Updated so that the tf_run_dir is a function stage-specific parameter. This allows users to store one more more configurations in specific sub folders. Requires terraform.auto.tfvars.template files in each subdirectory. Must be set on both plan and apply stages.
* Added TF_PLUGIN_CACHE_DIR variable to reduce downloads of providers.
* Added optional pre_steps and depends_on parameters for stages.

Module Templates
* Pipeline will tag main branch with the module version number after a succesful publish.
* Added depends_on param for stage-tfmodule-test.yml.
* Add optional variable_file parameter for module publish stage to allow publish to specifiec module registries.
* Add steps to tag module repo with module version after successful publish.

## v5.3.0
Module Templates
* Added task to download and run the terratest_log_parser.
* Added task to publish the terratest results.
* Change Go test execution from the Go task to bash script to accomodate piping the output to tee.

## v5.2.0
* Re-add apply_any_branch param for apply stages. Will not allow function if the workspace name contains "prod".
* Updated jq params when displaying JSON in pipeline logs.
* Use unique names for pipeline artifacts to prevent issues in pipelines using multiple plan/apply stages.

## v5.1.0
Policy Templates
* Added templates for Azure policy pipelines.
## v5.0.0
Infrastructure Templates
* Add ability to perform local runs as well as remote.
* Changed pipeline var names back to snake case for easier consumption as env vars in steps.

## v4.3.2
Module Templates
* Added TFLint
* Added Terrascan
* Removed remote workpsaces for Terratest

## 06.23.2021
* Added terrascan as an optional step.

## 05.21.2021
* Added tflint as optional step.

## 05.17.2021
* Removed token replacemnet for tfvars files not having .template extension.
* Added token replacement for tfvars.json files.
* Add escapeType: auto to token replacement task.
* Changed required pipeline variable names to camel case for consistency.

## 04.30.2021
* Removed apply only on master or main branch.
* Added apply only if not Build.Reason == PullRequest.
* Added variable substitution for any .tfvars or .tfvars.json file. All will have .auto. added.
* Added depends on for plan -> apply stages.
* Removed defaults for "stages" paramter to ensure they are supplied by the consumer pipeline.
* Added parallelism option for Terraform. Will specify demands: localRuns to get the correct build agents automatically.
* Added ability to specify TF_LOG - log level for Terraform.
* Change default value of "tfe_token" parameter on stage templates from $(tfeToken) to %(tfe_token).
* Added condition to apply stage to only run if plan stage succeeded.

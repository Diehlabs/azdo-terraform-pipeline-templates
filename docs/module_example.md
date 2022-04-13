```yaml
trigger:
  batch: 'true'
  branches:
    include:
    - '*'
  paths:
    exclude:
      - README.md

pool:
  name: Ubuntu

resources:
  repositories:
    - repository: templates
      type: git
      name: Diehlabs/azdo-terraform-pipeline-templates
      ref: refs/tags/v6.2-stable

variables:
# This shared group should have been created by PlaaS for you.
# This group contains a secret variable named "tfe_team_token" that will be passed
#  in to the templates.
- group: <my team name>-shared

# These environment variable groups should have been created by PlaaS for you.
# environments: dev, prod, etc
# You can define your client ID, client secret and subscription IDs here.
- group: <my team name>-<environment name>

stages:
  - template: terraform-module.yml@templates
    parameters:
      # This assumes you have the variable tfe_team_token supplied in a variable group (i.e. - group: <my team name>-shared)
      tfe_token: $(tfe_team_token)
      terraform_version: '1.1.7'
      terratest_timeout: 15m
      module_provider: azurerm
      module_team_name: enablingtech
      module_name: nsg
      module_version_number: '1.0.0'
      arm_credentials:
        # The following assumes you've got the three referenced variables supplied in the pipeline, in a variable group (i.e. - group: <my team name>-<environment name>).
        CLIENT_ID: $(az_client_id)
        CLIENT_SECRET: $(az_client_secret)
        SUBSCRIPTION_ID: $(az_sub_id)
        # The tenant ID can be defined anywhere, it should be the same for all users.
        TENANT_ID: 'e45cbcc1-1860-449a-a18b-35812285b3b5'
```

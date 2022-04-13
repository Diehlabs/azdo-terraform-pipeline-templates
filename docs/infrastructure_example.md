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
- group: <my team name>-dev

# The same thing is done for prod variables here.
- group: <my team name>-prod

- name: tf_cli_version
  value: '0.15.5'

# The tenant ID can be defined anywhere, it should be the same for all users.
# Since we're using the same tenant ID across mutiple stages defining it as
#   a variable here allows us to re-use the same value wihtout the chance of
#   mis-typing it.
- name: az_tenant_id
  value: 'e45cbcc1-1860-449a-a18b-35812285b3b5'

# The following stages will produce 3 identical configurations in 3 different environments.
# Any variablized settings will differ by supplying an environment specific variables (tfvars) file to each stage.
# Any variable values that are the same among environments are supplied in a common tfvars file.
stages:
- template: terraform-infra.yml@azdo-terraform-pipeline-templates
  parameters:
    workspace: dev
    azdo_approval_environment: <my team name>-iac-nonprod
    terraform_version: '1.1.7' # overriding the default of $(tf_cli_version) so we can experiment with a new version in dev environment.
    tfvars_files:
      - variables/dev.tfvars
    arm_credentials:
      TENANT_ID: $(az_tenant_id)
      # The following parameters assume you've supplied these variables in a specific variable group (i.e. - group: <my team name>-dev)
      CLIENT_ID: $(az_client_id_dev)
      CLIENT_SECRET: $(az_client_secret_dev)
      SUBSCRIPTION_ID: $(az_sub_id_dev)

- template: terraform-infra.yml@azdo-terraform-pipeline-templates
  parameters:
    workspace: test
    azdo_approval_environment: <my team name>-iac-nonprod
    terraform_version: $(tf_cli_version)
    tfvars_files:
      - variables/test.tfvars
      - variables/common.tfvars
    arm_credentials:
      TENANT_ID: $(az_tenant_id)
      # The following parameters assume you've supplied these variables in a specific variable group (i.e. - group: <my team name>-dev)
      CLIENT_ID: $(az_client_id_test)
      CLIENT_SECRET: $(az_client_secret_test)
      SUBSCRIPTION_ID: $(az_sub_id_test)

- template: terraform-infra.yml@azdo-terraform-pipeline-templates
  parameters:
    workspace: prod
    azdo_approval_environment: <my team name>-iac-prod
    terraform_version: $(tf_cli_version)
    tfvars_files:
      - variables/prod.tfvars
      - variables/common.tfvars
    arm_credentials:
      TENANT_ID: $(az_tenant_id)
      # The following parameters assume you've supplied these variables in a specific variable group (i.e. - group: <my team name>-prod)
      CLIENT_ID: $(az_client_id_prod)
      CLIENT_SECRET: $(az_client_secret_prod)
      SUBSCRIPTION_ID: $(az_sub_id_prod)
```

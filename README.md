# This is the Samesoup. But on different plates

> **Disclaimer**: This project make use of the project factory module. It makes use of the concept of a seed project that will create other project with a service account. Please read here: https://github.com/terraform-google-modules/terraform-google-project-factory how to setup the **seed** project. Without it you won't be able to use this project with cloudbuild.

> **Note for Googlers**: The demo env needs a specific configuration for the billing. Please contact me if you have any questions.


To run this project you will need to set the following vars in a cloudbuild (or manually):

| Required | Terraform Name| Cloudbuild Name  | Example Value | Description |
|:---:|---|---|---|---|
| ✅ | billing_account | _BILLING_ACCOUNT | 01234A-0995B9-1FACB1  | Billing account required to create the project |
| ✅ | org_id | _ORG_ID | 1234543452 | The Organization ID of the project |
| ✅ | project_name | _PROJECT_NAME | samesoup | The Name of the project (It doesn't need to be unique) |
| ❌ | folder_id | _FOLDER_ID | 1234567898765  | The ID of the folder that owns the project |
| ❌ | (set up manually) | _TFSTATE_BUCKET | bucketname | The name of the bucket that will retain the terraform state, used in Cloudbuild (but highly suggested for anyone)|

## Via Cloudbuild (preferred)
1) Into your seed project setup the repository from where to source the code. 
If you want you can fork this project and follow this [guide](https://cloud.google.com/build/docs/automating-builds/github/build-repos-from-github).
2) Following this example enable the needed substitution (via ui or via the console.)

## Manually:

To Run the Terraform manually, run the following command (substitute the value below):

```bash
  terraform init

  terraform plan \
    -var='project_name=samesoup' \
    -var='org_id=1234543452' \
    -var='billing_account=01234A-0995B9-1FACB1' \
    -var='folder_id=1234567898765'

  terraform apply \
    -var='project_name=samesoup' \
    -var='org_id=1234543452' \
    -var='billing_account=01234A-0995B9-1FACB1' \
    -var='folder_id=1234567898765'
```


## TODO:
- Certificate with ACME (Google Certificate is too slow to propagate on demo )
- GKE to Anthos
This repository serves as a skeleton for integrating a CI-CD for python code (python functions) that will be deployed into a
**prd** and **dev** **App Function** in Azure.

For its use, some infrastructure components need to be deployed. A terraform file containing the infrastructure is
located in the folder *infrastructure*. The terraform file will deploy a resource group, two service plans
 (*dev* & *prd*), two App Functions (*dev* & *prd*) and storage account will be deployed.

Before starting make sure that *terraform* and *azure-cli* are configured and ready to use with your Azure subscription.
1. Install [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

2. Install [azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)<br/>
3. Loggin into azure with the command:
```console
az login
```

---
### Deploying Infrastructure

To initialize the terraform files run the following command inside the **infrastructure** folder containing the
 ***.tf** files:
```console
terraform init
```

Once the terraform file have been initialized you can run the following commands:<br/><br/>

To deploy the configuration run:
```console
terraform apply
```

To delete/destroy the configuration deployed run:
```console
terraform destroy
```

---
### Getting the publish profiles

Two instances of Azure App Functions were deployed, now you need to get the *Publish Profile* credentials.
For it go to:  *Azure Portal -> Resource group -> App Function -> Overview -> Get publish profile* and store their
 content as a secret named ```AZURE_APP_FUNCTION_PUBLISH_PROFILE``` in the repository. You will need two 
[environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
 named *prd* and *dev*. 

This will allow you to deploy your code from different branches to the production or development instances of your App 
Functions.
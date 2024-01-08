# b3-gr5

install packer


az ad sp create-for-rbac --role Contributor --scopes /subscriptions/c56aea2c-50de-4adc-9673-6a8008892c21/resourceGroups/b3-gr5 --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"

{
  "client_id": "a9b915c8-a0fa-4873-ae4c-8ac6960d5039",
  "client_secret": "w3S8Q~h1YInFo4dQH6ZMFvOKpZXVCIJgVBS_yboO",
  "tenant_id": "16763265-1998-4c96-826e-c04162b1e041"
}
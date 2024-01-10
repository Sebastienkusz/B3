# b3-gr5

install packer


az ad sp create-for-rbac --role Contributor --scopes /subscriptions/c56aea2c-50de-4adc-9673-6a8008892c21/resourceGroups/b3-gr5 --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"

{
  "client_id": "493f3ff4-90dc-49fb-9577-1490818ba371",
  "client_secret": "KER8Q~hd1-BkjxXts2zlLWWRUqF9UB6dzP11TceF",
  "tenant_id": "16763265-1998-4c96-826e-c04162b1e041"
}

  provisioner "file" {
  source = "index.html"
  destination = "/var/www/html/index.html"
  }

    provisioner "shell" {
     inline = ["sudo rm /var/www/html/index.nginx-debian.html", "sudo mv ./index.html /var/www/html/index.nginx-debian.html"]
    }
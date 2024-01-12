# Création d'une image de VM
Pour créer une image personnalisée, nous pouvons utiliser **Packer**.

**Packer** permet de créer des images de machine virtuelle à partir d'une configuration déclarative.

### Installation de Packer
---------------------------
Dans un premier temps, nous devons installer **Packer** dans notre terminal avec les commandes suivantes.

    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

    sudo apt-get update && sudo apt-get install packer

### Création du fichier Packer pour notre image personnalisée
--------------------------------------------------------------
Vous pouvez vous aider de la documentation fournit par **Packer** pour créer votre propre image en partant d'une base grâce à ce lien.

https://developer.hashicorp.com/packer/integrations/hashicorp/azure

### Création des informations d'authentification azure 
--------------------------------------------------------
Nous devons rentrer la commande ci-dessous pour créer les informations d'authentification à ajouter au fichier pour se connecter à notre souscription Azure.

    az ad sp create-for-rbac --role Contributor --scopes /subscriptions/c56aea2c-50de-4adc-9673-6a8008892c21/resourceGroups/b3-gr5 --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"

### Création de l'image sur Azure
---------------------------------
Quand le fichier Packer est terminé, nouos pouvons maintenant créer l'image sous azure que nous utiliserons ultérieurement pour une nouvelle machine virtuelle grâce aux commandes suivantes.

    Packer validate < nom du fichier > 
    Packer fmt < nom du fichier >
    Packer init < nom du fichier >
    Packer build < nom du fichier >

Cette dernière commande, "Packer build", procédera à la création de l'image souhaitée.

Nous pourrons utiliser cette image à l'avenir pour des déploiements personnalisés en spécifiant la ressource dans notre code terraform.

#### "Merci qui? merci Tony!"
<img src="https://i.pinimg.com/736x/52/1f/d4/521fd4024a40c107f68ce64e128fef02.jpg" alt="">

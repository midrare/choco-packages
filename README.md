# choco-packages
My collection of [Chocolatey](https://community.chocolatey.org/packages) packages.

This repository is automatically managed using [chocolatey-au](https://github.com/chocolatey-community/chocolatey-au).


**Dev Environment**  
```nushell
# https://docs.chocolatey.org/en-us/create/create-packages/#push-your-package
sudo choco config set --name defaultPushSource --value https://push.chocolatey.org/

# get api key from: https://community.chocolatey.org/account
sudo choco apikey --key xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx --source https://push.chocolatey.org/

# for automating package version updates
sudo choco install chocolatey-au
```

**Build**  
```nushell
cd $REPO_DIR
ls **/*.nuspec | get name | path dirname | each { cd $in; choco pack; } 
```

**Update**  
```pwsh
cd $REPO_DIR

# requires chocolatey-au
# can also call with alias `updateall`
Update-AUPackages
```

<sub>See [chocolatey-au docs](https://github.com/chocolatey-community/chocolatey-au) for more info.</sub>


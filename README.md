# RANDONET-OPENSHIFT
This project provides an example of how to run a ASP.NET application on Windows Server 2016
and expose its application via a service for consumption by cloud native applications deployed along side it.

### Requirements
* Openshift 4.4+ Cluster With CNV operator installed
* Access to a Windows Server 2016+ ISO accessible via HTTP
* Persistant Storgae availible (pre provisioned or dynamically created)


### Dependencies
* [Randonet](github.com/kobutton/randonet) ASP.NET application for IIS on Windows Server
* [Visualizer](github.com/kobutton/visualizer) Cloud Native Python Application That consumes Randonet data.

### Instructions
1. Create the randonet project for this application `oc new-project randonet`
2. Create the vm using the openshift template. 
        
         curl https://raw.githubusercontent.com/kobutton/randonet-openshift/master/randonet-servervm-template.yml | oc process -p STORAGE_CLASS=<Storage class name> -p WINDOWS_ISO=<uri of windows server iso> -f - | oc apply -f -

3. Login to to the openshift web console and navigate to the newly created vm and install vanilla windows.
    * VirtIO Drivers are required in order to install windows. 
      Refer to this link [Installing VirtIO drivers during Windows installation](https://docs.openshift.com/container-platform/4.4/cnv/cnv_virtual_machines/cnv-installing-virtio-drivers-on-new-windows-vm.html#cnv-installing-virtio-drivers-installing-windows_cnv-installing-virtio-drivers-on-new-windows-vm)
4. Create a password for administrator when prompted.
5. In a powershell administrator terminal execute the following:

        D:\virtio-win-gt-x64.msi
        F:\RANDONET.PS1
        #Optionaly to ensure app is working run
        curl localhost


6. We are now done configuring our legacy application. Now create an openshift service to expose randonet to the
   project. 

        curl https://raw.githubusercontent.com/kobutton/randonet-openshift/master/randonet-service.yml | oc apply -f - 

7. Follow the install instructions for visualizer (listed in dependencies)
        





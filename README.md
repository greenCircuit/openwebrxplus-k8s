# About 
Deploying openwebrxplux inside k8s using helm chart and passing through usb devices to the cluster

# Setup
## Use just kubectl 
Simpler deployments since don't need to install additional dependencies, but can cause security problems since running pods in privileged mode 
- `kubectl apply -f deployPrivileged.yaml` will create simple deployment without any additional installation. The application will be visible at localhost:8073


## Use akri custom resources
### About
More graceful management of of hardware devices inside k8s. Can specify exact devices that want attach to pod. 
- Docs: https://docs.akri.sh/
- How to use akri: https://medium.com/@hampusc/how-to-attach-usb-devices-to-kubernetes-pods-using-akri-19fb70d41f1e
- `./getAkriHc.sh` will install Akri helm chart
- Need to install Akri helm chart before continuing with below steps

### Finding usb devices
Need to add your devices to inside values files for device be attached inside pod. Thats how akri is able to provide devices to pods
values.yaml
```yaml
akriConfig:
  configurationName: akri-sdr
  usbDevices:  
    - idVendor: 0bda
      idProduct: "2838"
```
helm templated config after install helm chart
```yaml
apiVersion: akri.sh/v0
kind: Configuration
metadata:
  name: akri-sdr
spec:
  capacity: 1
  discoveryHandler:
    discoveryDetails: |
      groupRecursive: true # Recommended unless using very exact udev rules
      udevRules:
      - ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838"
    name: udev

```

Run `lsusb`, Ex. for rtl-sdr will get:
```
    Bus 001 Device 009: ID 0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T
    0bda = idVendor
    2838 = idProduct
```
Add your device to values.yaml and pod will be able to use this device

If want other pods using device need to add this spec, just attach akri as resources
```yaml
      containers:
        - name: openwebrx
          resources:
            requests:
              akri.sh/akri-sdr: "1"
            limits:
              akri.sh/akri-sdr: "1"
```

### Helm install 
Modify values.yaml to add more devices
- `helm upgrade --install --create-namespace openwebrx -n radio ./chart` 

### Kubectl install
Modify akri-sdr config map to add your  devices inside akriSdrExample.yaml
- `kubectl apply -f akriSdrExample.yaml`
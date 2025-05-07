# About 
Deploying openwebrxplux inside k8s using helm chart 

# Setup
### Use just k8s
- `kubectl apply -f deploy` will create simple deployment without any additional installation


### Use akri custom resources
- Docs: https://docs.akri.sh/
- How to use akri: https://medium.com/@hampusc/how-to-attach-usb-devices-to-kubernetes-pods-using-akri-19fb70d41f1e
- more graceful management of usb attachment to k8s
- ./getAkriHc.sh will install Akri helm chart
- `helm upgrade --install openwebrx ./chart` or if want to specify namespace `helm upgrade --install openwebrx -n your_name_space ./chart`
- might need to additional values if using Akri, when trying to use additional usb devices
    - default value is for RTL-SDR
    - .Values.akriConfig.usbDevices[]
    - need to know usb vendorId and productId (use `lsusb` to get it)


# TODO
- additional config so can configure openwebrx (map, default frequencies, profile, etc...)
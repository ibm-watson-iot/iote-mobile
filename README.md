# IoT for Electronics Mobile Application

## Overview
IoT for Electronics is an integrated end-to-end solution (made of multiple services and applications) that enables your apps to communicate with, control, analyze, and update connected electronics.  

The IoT for Electronics Mobile App is a demo app for interacting with the IBM IoT for Electronics solution. The app enables you to use your mobile device to view the status of and send commands to the simulated appliances that you created in the IoT for Electronics Starter app.

## Try it
To try the mobile app, you need to perform the following tasks:

1. Download the source code for the mobile app and import into Xcode.
2. Generate the mobile app .ipa file.
3. Install the mobile app on an iOS device.
4. Connect the mobile app to your IoT for Electronics organization in Bluemix.

### Prerequisites
Required:
- An [IBM Bluemix](https://console.ng.bluemix.net/) account. A 30 day trial account is free.
- The IoT for Electronics Starter app registered in Bluemix.
- Simulated appliances created in the Starter app and registered with the platform (using instructions found in the Starter app).
- Apple XCode.
- An iOS mobile device.

### Generating the mobile app .ipa file

1. Download the mobile app source files from the [IoT for Electronics GitHub location](https://github.com/ibm-watson-iot/iote-mobile) onto a computer on which XCode is installed.
2. Double click on the provisioning profile file to import it into Xcode.
3. Create an archive file using Xcode. For instructions, see Xcode documentation.
4. Export the archive file to an IPA file. For instructions, see Xcode documentation.


### Installing the app on your mobile device    
1. Connect your iOS device to your computer.
2. In Xcode, choose **Window > Devices** and select your device.
3. In the Installed Apps table, click Add (+).
4. Select the app file and click **Open**.

### Getting started with the mobile app
1. On your phone, start the IoT for Electronics mobile app.
2. Scroll through the introduction, and then click **Try It Out**.
3. Scan the QR code that is available in the Starter app on your computer to connect your phone to the cloud.  
4. Register your simulated appliances in the mobile app using QR codes.


- [IoT for Electronics Starter](https://new-console.ng.bluemix.net/docs/starters/IotElectronics/iotelectronics_overview.html)
- [Watson IoT](https://internetofthings.ibmcloud.com)
- [IBM Bluemix](https://console.ng.bluemix.net/)
- [IoT Recipes](https://developer.ibm.com/iot/)
- [IoT Quickstart](http://quickstart.internetofthings.ibmcloud.com/#/)
- [Node-RED](http://nodered.org/)
- [MQTT](http://mqtt.org/)

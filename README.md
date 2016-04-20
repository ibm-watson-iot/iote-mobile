# IoT for Electronics Mobile Application

## Overview
IBM IoT for Electronics is an integrated end-to-end solution (made of multiple services and applications) that enables your apps to communicate with, control, analyze, and update connected electronics.  

The IoT for Electronics Mobile App is a sample source code for interacting with the IBM IoT for Electronics solution. The app enables you to use your mobile device to view the status of and send commands to the simulated appliances that you created in the IoT for Electronics Starter app.

This sample source code for IoT for Electronics is intended solely for use with an Apple iOS product and intended to be used in conjunction with officially licensed Apple development tools and further customised and distributed under the terms and conditions of your licensed Apple iOS Developer Program or your licensed Apple iOS Enterprise Program.

## Prerequisites
Required:
- An [IBM Bluemix account](https://console.ng.bluemix.net/). A 30 day trial account is free.
- The [IoT for Electronics Starter app](https://new-console.ng.bluemix.net/catalog/starters/iot-for-electronics-starter/) registered in Bluemix.
- Simulated appliances created in the Starter app (using instructions found in the Starter app).
- An IOS 9.0+ iPhone mobile device: 4s, 5, 5c, 5s, SE, 6, 6s, 6 plus or 6s plus.
- Apple XCode 7.2.1 or higher integrated development environment that is compatible with the iOS version of your mobile device. (For example, XCode 7.2 is compatible with iOS 9.2, XCode 7.3 is compatible with iOS 9.3.)


## Try it
To try the mobile app, you need to perform the following tasks:

1. Download the [source code from the master branch](https://github.com/ibm-watson-iot/iote-mobile/archive/master.zip) for the mobile app, onto a computer on which Xcode 7.2.1 or above is installed.
2. Connect your iPhone to a computer on which Xcode installed.
3. Double click on the `IoT-Electronics-mobileApp-SWIFT.xcworkspace` file to open the project in Xcode.
4. If you have not already done so, on the Xcode menu, select **Preferences** and sign in with your Apple ID.
5. Select your mobile device as a build destination.
6. Select the IoT-Electronics-mobileApp-SWIFT file in the list of files to display the Identity dialog.
7. In the Identity dialog
  - Change the **Bundle Identifier** to a unique identifier. For example, "myIoT4Ebundle".
  - Set **Team** to your personal team name and then click **Fix Issue**.
8. Click the arrow to "build and run the current scheme". An error is displayed that says "Could not launch "IoT-Electronics-mobileApp-SWIFT" because you have not yet verified that your Developer App certificate is trusted on your device.
9. On your mobile device, select yourself as a Trusted Developer, as follows:  
  1. On your phone, go to **Settings > General > Device Management > yourDeveloperID**.
  2. Trust your own developer ID.
  3. When prompted, confirm **Trust**. 
10. On your computer, click the arrow to build and run the current scheme. The mobile application is installed on your phone. For more information, see the [Apple developer instructions for running Apps on devices from Xcode](https://developer.apple.com/library/mac/documentation/IDEs/Conceptual/AppDistributionGuide/LaunchingYourApponDevices/LaunchingYourApponDevices.html).

### Getting started with the mobile app
1. On your iPhone, start the IBM IoT for Electronics mobile app.
2. Scroll through the walkthrough, and then click **Try It Out**.
3. When prompted, scan the QR code to connect the mobile app to your **IoT for Electronics** organization in Bluemix.  
4. Register your simulated appliances in the mobile app using the supplied QR codes.

### Additional information
- [IoT for Electronics Starter](https://new-console.ng.bluemix.net/docs/starters/IotElectronics/iotelectronics_overview.html)
- [Watson IoT](https://internetofthings.ibmcloud.com)
- [IBM Bluemix](https://console.ng.bluemix.net/)
- [IoT Recipes](https://developer.ibm.com/iot/)
- [IoT Quickstart](http://quickstart.internetofthings.ibmcloud.com/#/)
- [MQTT](http://mqtt.org/)

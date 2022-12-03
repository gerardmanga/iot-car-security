How to run the mobile application:
1. Install Flutter SDK from https://docs.flutter.dev/get-started/install/windows 
2. Extract zip file and place the flutter folder in an area with no elevated privileges 
3. Now you need to update your path to run flutter commands in the windows console, follow instructions here https://docs.flutter.dev/get-started/install/windows#update-your-path 
4. run 'flutter doctor' command in the flutter directory path, ex. C:\src\flutter>flutter doctor, to check proper flutter installation 
5. Install Android Studio from here https://developer.android.com/studio 
6. Install Visual Studio and Visual Studio Code https://visualstudio.microsoft.com/downloads/ 
7. make sure everything described in flutter doctors is checked and addressed 
8. Select this folder
9. Run Android Studio and open the folder as a project
10. Opening it will prompt a Dart Extension Plugin Installation, install it and restart Android Studio *it also might say that the DART sdk is not specified, to fix this download the DART sdk here https://dart.dev/get-dart/archive extract and point the sdk path within Android studio to the extracted foler
11. Reopen Android Studio and click on the Device Manager Icon on the top right
12. Click on "Create Device", for category on the left choose "Phone", Choose "Pixel 2" then click next
13. Here you choose the operating system for the device, click Download on Pie or Android 9.0, then click finish
14. On the top of Android Studio where it says "<no device selected>" click "Open Android Emulator: Pixel 2 API 28"
15. Then click on the green play button on the top right to start the application on the emulator.

  
How to operate the security Device:
Arduino Code
1. Download the Arduino IDE. The lastest version of the IDE can be downloaded from the official website
2. Connect Arduino to the Raspberry Pi 3 or computer
3. Verify if the device is detected or not
4. Open the filename "Senior195FProject\SeniorProject195F\Senior_Project\Arduino_code\Arduino_code.ino"
6. Compile the sketch 
7. Upload the sketch
8. Press Ctrl+Shift+M to show the Serial Monitor and we could see the result
9. Close the file
  
Python/Raspberry Pi Code
1. Download the Python IDE. The lastest version of the IDE can be download from the official website
2. Open the filename "Senior195FProject\ConnectedAWS.py"
3. Run the filename ConnectedAWS.py
4. We could see in the terminal that was connected to the AWS Cloud.

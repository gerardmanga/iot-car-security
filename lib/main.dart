import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning/models/getSensor.dart';
import 'package:learning/models/remote_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((checkDB, inputData) async {
    if (checkDB == 'inputData') {
      var client = http.Client();
      var uri = Uri.parse(
          'https://nwq8h4anq8.execute-api.us-west-1.amazonaws.com/production/sensorlist?mac_Id=%20b8:27:eb:2f:1e:6b%20');
      var response = await client.get(uri);
      Map sensorData = jsonDecode(response.body);
      int infaredSensor1 = sensorData['infaredSensor1'];
      int ultraSonicSensorTrigStatus = sensorData['ultraSonicSensorTrigStatus'];

      if (infaredSensor1 == 1 || ultraSonicSensorTrigStatus == 1) {
        NotificationService.showTextNotification(
            title: "Sensor has been tripped!",
            body: "Check on your car",
            fln: flutterLocalNotificationsPlugin);
      }
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: FirstPage());
  }
}

class FirstPage extends StatefulWidget {
  FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String buttonName = 'Click';
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Car Security System'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: currentIndex == 0
            ? Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.cover,
                )),
                width: double.infinity,
                //height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          minimumSize: Size(350.0, 50.0),
                          onPrimary: Colors.white,
                          primary: Colors.black),
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ArmSecuritySystem();
                          }));
                        });
                      },
                      child: Text('Arm Security'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          minimumSize: Size(350.0, 50.0),
                          onPrimary: Colors.white,
                          primary: Colors.black),
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return TrackLocation();
                          }));
                        });
                      },
                      child: Text('Track Location'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          minimumSize: Size(350.0, 50.0),
                          onPrimary: Colors.white,
                          primary: Colors.black),
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ViewCamera();
                          }));
                        });
                      },
                      child: Text('View Camera'),
                    ),
                    SizedBox(
                      height: 230,
                    ),
                  ],
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    minimumSize: Size(350.0, 50),
                    onPrimary: Colors.white,
                    primary: Colors.black),
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text("Sign Out"),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        backgroundColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
            backgroundColor: Colors.white,
            activeIcon: Icon(Icons.home, color: Colors.white),
          ),
          BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
              backgroundColor: Colors.white,
              activeIcon: Icon(Icons.settings, color: Colors.white))
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class NotificationService {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =
        new InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      'channelid',
      'channelname',
      playSound: false,
      //sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, not);
  }
}

class ArmSecuritySystem extends StatefulWidget {
  ArmSecuritySystem({super.key});

  @override
  State<ArmSecuritySystem> createState() => _ArmSecuritySystemState();
}

class _ArmSecuritySystemState extends State<ArmSecuritySystem> {
  List<GetSensor>? sensors;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    NotificationService.initialize(flutterLocalNotificationsPlugin);

    getData();
  }

  getData() async {
    sensors = await RemoteService().getSensordata();
    if (sensors != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arm Security"),
        backgroundColor: Colors.black,
      ),
      body: Visibility(
        visible: isLoaded,
        // ignore: sort_child_properties_last
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            int detectedInfrared = sensors![index].infaredSensor1;
            String strdetectedInfr = detectedInfrared.toString();

            return Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          minimumSize: Size(350.0, 50.0),
                          onPrimary: Colors.white,
                          primary: Colors.black),
                      onPressed: () {
                        Workmanager().registerPeriodicTask("1", "checkDB",
                            frequency: const Duration(seconds: 5));
                        NotificationService.showTextNotification(
                            title: "Security Notifications have been enabled",
                            body: "",
                            fln: flutterLocalNotificationsPlugin);
                      },
                      child: const Text('Activate Security Notifications'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          minimumSize: Size(350.0, 50.0),
                          onPrimary: Colors.white,
                          primary: Colors.black),
                      onPressed: () {
                        Workmanager().cancelAll();
                        NotificationService.showTextNotification(
                            title: "Security Notifications have been disabled",
                            body: "",
                            fln: flutterLocalNotificationsPlugin);
                      },
                      child: const Text('Dectivate Security Notifications'),
                    )
                  ]),
            );
          },
        ),
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ViewCamera extends StatefulWidget {
  @override
  State<ViewCamera> createState() => _ViewCameraState();
}

class _ViewCameraState extends State<ViewCamera> {
  List<GetSensor>? sensors;

  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    sensors = await RemoteService().getSensordata();
    if (sensors != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Camera"),
        backgroundColor: Colors.black,
      ),
      body: Visibility(
        visible: isLoaded,
        // ignore: sort_child_properties_last
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    height: 160,
                  ),
                  Text("Latest Image From Camera: ",
                      style:
                          const TextStyle(color: Colors.black, fontSize: 20)),
                  SizedBox(
                    height: 10,
                  ),
                  Image(image: AssetImage('images/example1.jpg')),
                ],
              ),
            );
          },
        ),
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class MapUtils {
  MapUtils._();
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

class TrackLocation extends StatefulWidget {
  const TrackLocation({super.key});

  @override
  State<TrackLocation> createState() => _TrackLocationState();
}

class _TrackLocationState extends State<TrackLocation> {
  List<GetSensor>? sensors;
  var isLoaded = false;

  LatLng sourceLocation = LatLng(0, 0);

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    sensors = await RemoteService().getSensordata();
    if (sensors != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Track Location"),
          backgroundColor: Colors.black,
        ),
        body: Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  String latitude = sensors![index].latitude;
                  double lat = double.parse(latitude);

                  String longitude = sensors![index].longitude;
                  double lon = double.parse(longitude);

                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 180,
                        ),
                        Text('Your is vehcle located at:'),
                        Text(
                          "Latitude: " + latitude,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 30),
                        ),
                        Text(
                          "Longitude: " + longitude,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 30),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                minimumSize: Size(250.0, 80.0),
                                onPrimary: Colors.white,
                                primary: Colors.black),
                            onPressed: () => {MapUtils.openMap(lat, lon)},
                            child: Text('Open Maps'))
                      ],
                    ),
                  );
                })));
  }
}

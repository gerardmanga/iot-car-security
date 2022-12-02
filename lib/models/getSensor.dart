import 'dart:convert';

List<GetSensor> getSensorFromJson(String str) =>
    List<GetSensor>.from(json.decode(str).map((x) => GetSensor.fromJson(x)));

String getSensorToJson(List<GetSensor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSensor {
  GetSensor({
    required this.ts,
    required this.leftBackUltrasonicSensor,
    required this.longitude,
    required this.leftFrontUltrasonicSensor,
    required this.rightBackUltrasonicSensor,
    required this.latitude,
    required this.macId,
    required this.ultraSonicSensorTrigStatus,
    required this.rightFrontUltrasonicSensor,
    required this.infaredSensor1,
  });

  int ts;
  int leftBackUltrasonicSensor;
  String longitude;
  int leftFrontUltrasonicSensor;
  int rightBackUltrasonicSensor;
  String latitude;
  String macId;
  int ultraSonicSensorTrigStatus;
  int rightFrontUltrasonicSensor;
  int infaredSensor1;

  factory GetSensor.fromJson(Map<String, dynamic> json) => GetSensor(
        ts: json["ts"],
        leftBackUltrasonicSensor: json["Left Back Ultrasonic Sensor"],
        longitude: json["Longitude"],
        leftFrontUltrasonicSensor: json["Left Front Ultrasonic Sensor"],
        rightBackUltrasonicSensor: json["Right Back Ultrasonic Sensor"],
        latitude: json["Latitude"],
        macId: json["mac_Id"],
        ultraSonicSensorTrigStatus: json["UltraSonic Sensor Trig Status"],
        rightFrontUltrasonicSensor: json["Right Front Ultrasonic Sensor"],
        infaredSensor1: json["Infared Sensor1"],
      );

  Map<String, dynamic> toJson() => {
        "ts": ts,
        "Left Back Ultrasonic Sensor": leftBackUltrasonicSensor,
        "Longitude": longitude,
        "Left Front Ultrasonic Sensor": leftFrontUltrasonicSensor,
        "Right Back Ultrasonic Sensor": rightBackUltrasonicSensor,
        "Latitude": latitude,
        "mac_Id": macId,
        "UltraSonic Sensor Trig Status": ultraSonicSensorTrigStatus,
        "Right Front Ultrasonic Sensor": rightFrontUltrasonicSensor,
        "Infared Sensor1": infaredSensor1,
      };
}

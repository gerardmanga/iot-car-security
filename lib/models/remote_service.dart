import 'package:flutter/cupertino.dart';
import 'package:learning/models/getSensor.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  Future<List<GetSensor>?> getSensordata() async {
    var client = http.Client();

    var uri = Uri.parse(
        'https://nwq8h4anq8.execute-api.us-west-1.amazonaws.com/production/sensorlist?mac_Id=%20b8:27:eb:2f:1e:6b%20');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      print("item loaded");
      var json = response.body;
      print(json);
      return getSensorFromJson(json);
    }
  }
}

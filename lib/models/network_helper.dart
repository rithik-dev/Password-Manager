import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper._();

  static Future<List<String>> getData(String url) async {
    http.Response response = await http.get(url);
    List<String> data = [];

    if (response.statusCode == 200) {
      List decodedData = jsonDecode(response.body);
      for (Map<String, dynamic> mapData in decodedData)
        data.add(mapData['password']);
      return data;
    } else {
      print("DATA FROM API RESPONSE CODE : ${response.statusCode}");
      return [];
    }
  }
}

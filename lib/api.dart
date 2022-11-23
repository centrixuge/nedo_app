import 'package:http/http.dart' as http;

Future<String> getDriverJsonString() async {
  final response =
      await http.get(Uri.parse("http://localhost:5000/driver_route/1"));
  return response.body;
}

Future<String> getNodeJsonString() async {
  final response = await http.get(Uri.parse("http://localhost:5000/station"));
  return response.body;
}

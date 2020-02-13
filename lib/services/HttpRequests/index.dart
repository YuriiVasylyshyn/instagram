import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

var now = DateTime.now();

makeGetRequest(String url) async {
  var response = await http.get(url);
  if (response.statusCode != 200) {
    print('Error ${response.statusCode}');
  } else {
    return convert.jsonDecode(response.body);
  }
}

makeDeleteRequest(String url) async {
  http.Response response = await http.delete(url);
  print('[Status code] ${response.statusCode}');
}

makePostRequest(String url, body) async {
  http.Response response = await http.post(url, body: body);
  if (response.statusCode == 201) {
    return convert.jsonDecode(response.body);
  } else {
    print('ERROR ${response.statusCode}');
  }
}

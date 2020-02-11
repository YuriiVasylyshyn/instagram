import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

var users = [];

getUrl(String url) async {
  var response = await http.get(url);
  var jsonResponse = convert.jsonDecode(response.body);
  users = jsonResponse;
}

// makePostRequest() async {
//   String url = 'https://5b27755162e42b0014915662.mockapi.io/api/v1/posts';
//   List<int> imageBytes = _image.readAsBytesSync();
//   String base64Image = base64Encode(imageBytes);
//   var json = {
//     "createdAt": '$now',
//     "imageUrl": base64Image,
//     "description": description,
//     "userName": userName,
//   };
//   Response response = await post(url, body: json);
//   print('[Json] $json');
//   print("[Status code] ${response.statusCode}");
//   print('[Body] ${response.body}');
// }

// makeDeleteRequest() async {
//   String url = 'https://5b27755162e42b0014915662.mockapi.io/api/v1/posts/103';
//   Response response = await delete(url);
//   print("[Status code] ${response.statusCode}");
// }

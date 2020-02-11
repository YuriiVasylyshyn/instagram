import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/components/Timeline/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var users = [];
  File _image;
  var now = DateTime.now();
  String description;
  String userName;

  void initState() {
    super.initState();
    getUrl('https://5b27755162e42b0014915662.mockapi.io/api/v1/posts');
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    print('object');
    setState(
      () {
        _image = image;
      },
    );
  }

  getUrl(String url) async {
    var response = await http.get(url);
    var jsonResponse = convert.jsonDecode(response.body);
    setState(
      () {
        users = jsonResponse;
      },
    );
  }

  makePostRequest() async {
    String url = 'https://5b27755162e42b0014915662.mockapi.io/api/v1/posts';
    List<int> imageBytes = _image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    var json = {
      'createdAt': '$now',
      'imageUrl': base64Image,
      'description': description,
      'userName': userName,
    };
    Response response = await post(url, body: json);
    print('[Json] $json');
    print('[Status code] ${response.statusCode}');
    print('[Body] ${response.body}');
  }

  void _showSimpleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Make a post'),
          children: <Widget>[
            SimpleDialogOption(
              child: Column(
                children: <Widget>[
                  TextField(
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      hintText: 'Enter a username',
                    ),
                    onChanged: (String str) {
                      userName = str;
                    },
                  ),
                  TextField(
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      hintText: 'Enter a description',
                    ),
                    onChanged: (String str) {
                      description = str;
                    },
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: FloatingActionButton(
                      onPressed: getImage,
                      tooltip: 'Pick Image',
                      child: Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      makePostRequest();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
              ),
              onPressed: _showSimpleDialog,
              // _makeDeleteRequest,
            ),
            Text(
              'Instagram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 40,
              ),
            ),
            Icon(
              Icons.send,
            ),
          ],
        ),
      ),
      body: ListView(
        children: users
            .map(
              (item) => Timeline(
                nickname: item['userName'],
                avatar: item['avatar'],
                image: item['imageUrl'],
                description: item['description'],
                comments: item['comments'],
                id: item['id'],
              ),
            )
            .toList(),
      ),
    );
  }
}

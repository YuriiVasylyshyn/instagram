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
  MyHomePage({this.image});
  final image;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var users = [];
  File _image;
  var userName;
  var description;

  var a = {'imageUrl': '', 'userName': '', 'description': ''};

  void initState() {
    super.initState();
    getUrl('https://5b27755162e42b0014915662.mockapi.io/api/v1/posts');
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(
      () {
        _image = image;
      },
    );
  }

  void getUrl(String url) async {
    var response = await http.get(url);
    var jsonResponse = convert.jsonDecode(response.body);
    setState(
      () {
        users = jsonResponse;
      },
    );
  }

  _makePostRequest() async {
    String url = 'https://5b27755162e42b0014915662.mockapi.io/api/v1/posts';
    String json =
        '{imageUrl: "$_image", userName: "$userName", description: "$description"}';
    Response response = await post(url, body: json);
    print('[Json] $json');
    print("[Status code] ${response.statusCode}");
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
              child: TextField(
                textAlign: TextAlign.justify,
                decoration: InputDecoration(
                  hintText: 'Enter a username',
                ),
                onEditingComplete: userName,
              ),
            ),
            SimpleDialogOption(
              child: TextField(
                textAlign: TextAlign.justify,
                decoration: InputDecoration(
                  hintText: 'Enter a description',
                ),
                onChanged: description,
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
                    onPressed: _makePostRequest,
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
              onPressed: () {
                _showSimpleDialog();
              },
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
                likes: item['likes'],
                comments: item['comments'],
                id: item['id'],
              ),
            )
            .toList(),
      ),
    );
  }
}

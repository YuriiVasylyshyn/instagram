import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram/components/Timeline/index.dart';
import 'package:instagram/services/HttpRequests/index.dart';

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

  var now = DateTime.now();
  File _image;
  String description;
  String userName;

  void initState() {
    super.initState();
    getUrl();
  }

  getUrl() async {
    var jsonResponse = await makeGetRequest(
        'https://5b27755162e42b0014915662.mockapi.io/api/v1/posts');
    setState(
      () {
        users = jsonResponse;
      },
    );
  }

  getImage() async {
    var pickedImage = await getImageRequest();
    setState(
      () {
        _image = pickedImage;
      },
    );
  }

  postRequest() async {
    List<int> imageBytes = _image.readAsBytesSync();
    String base64Image = convert.base64Encode(imageBytes);
    var json = {
      'createdAt': '$now',
      'imageUrl': base64Image,
      'description': description,
      'userName': userName,
    };
    await makePostRequest(
        'https://5b27755162e42b0014915662.mockapi.io/api/v1/posts', json);
    getUrl();
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
                      postRequest();
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
              (item) => Timeline(item: item),
            )
            .toList(),
      ),
    );
  }
}

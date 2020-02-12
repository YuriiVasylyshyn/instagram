import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  ProfileScreen({this.id});
  final id;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var user;
  var id2;
  void initState() {
    super.initState();
    setState(
      () {
        id2 = widget.id;
      },
    );
    getUrl('https://5b27755162e42b0014915662.mockapi.io/api/v1/posts/$id2');
  }

  getUrl(String url) async {
    var response = await http.get(url);
    print(response.statusCode);
    var jsonResponse = convert.jsonDecode(response.body);
    print('[jsonResponse] $jsonResponse');
    setState(
      () {
        user = jsonResponse;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(user['imageUrl'].split(',').last);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          id: widget.id,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      user['avatar'],
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
                Text(
                  user['userName'],
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                ),
              ),
              Icon(
                Icons.comment,
              ),
              Icon(
                Icons.send,
              ),
              Icon(
                Icons.bookmark_border,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Text(
                    user['description'],
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

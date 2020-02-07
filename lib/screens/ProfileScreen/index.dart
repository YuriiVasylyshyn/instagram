import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:instagram/components/Timeline/index.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    this.id,
  });
  final id;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var users = [];
  void initState() {
    super.initState();
    getUrl();
  }

  void getUrl() async {
    String url = 'https://5b27755162e42b0014915662.mockapi.io/api/v1/posts/:id';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(
        () {
          users = jsonResponse;
        },
      );
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        children: users
            .map(
              (item) => Timeline(
                nickname: item['userName'],
                avatar: item['avatar'],
                image: item['imageUrl'],
                description: item['description'],
                likes: item['likes'],
                comments: item['comments'],
              ),
            )
            .toList(),
      ),
    );
  }
}

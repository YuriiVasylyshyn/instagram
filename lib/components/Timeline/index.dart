import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:instagram/screens/ProfileScreen/index.dart';

class Timeline extends StatefulWidget {
  Timeline({
    this.nickname,
    this.image,
    this.avatar,
    this.description,
    this.likes,
    this.comments,
    this.id,
  });
  final nickname;
  final image;
  final avatar;
  final description;
  final likes;
  final comments;
  final id;
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  bool putLike = false;
  String input = '';

  void likeFunc(data) {
    setState(
      () {
        putLike = data;
      },
    );
  }

  void initState() {
    super.initState();
  }

  // void makePutRequest() async {
  //   String url = 'https://5b27755162e42b0014915662.mockapi.io/api/v1/posts:id';
  //   Map<String, String> headers = {"Content-type": "application/json"};
  //   String json = '{"comments": "$input"}';
  //   Response response = await put(url, headers: headers, body: json);
  //   int statusCode = response.statusCode;
  //   print('StatusCode: $statusCode');
  //   String body = response.body;

  // }

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(widget.image.split(',').last);
    return Column(
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
                    widget.avatar,
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
              Text(
                widget.nickname,
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
              onPressed: () {
                likeFunc(putLike ? false : true);
              },
              icon: Icon(
                putLike ? Icons.favorite : Icons.favorite_border,
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
                  widget.description,
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Likes ${widget.likes}',
                ),
              ],
            ),
          ),
        ),
        Text(
          widget.comments ?? 'default comment',
        ),
        TextField(
          textAlign: TextAlign.justify,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Put a comment',
          ),
          onChanged: (String str) {
            setState(
              () {
                input = str;
                makePutRequest();
              },
            );
          },
        ),
        Text(
          '${widget.id}',
        ),
      ],
    );
  }
}

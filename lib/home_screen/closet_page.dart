import 'package:flutter/material.dart';

class ClosetPage extends StatelessWidget {
  final String imageUrl = "https://even-t.s3.ap-northeast-2.amazonaws.com/users/directdb_pic/isaac/KakaoTalk_20240821_220249238_02.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("S3 Image Loader")),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
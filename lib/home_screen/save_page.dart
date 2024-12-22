import 'package:flutter/material.dart';

// const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '안녕 페이지',
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('안녕 페이지'),
//           backgroundColor: Colors.brown, // AppBar 배경색
//         ),
//         body: const Center(
//           child: Text(
//             '안녕',
//             style: TextStyle(
//               fontSize: 24, // 텍스트 크기
//               fontWeight: FontWeight.bold, // 텍스트 굵기
//             ),
//           ),
//         ),
//       ),
//     );
//   }

class SavePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '안녕 페이지',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('안녕 페이지'),
          backgroundColor: Colors.brown, // AppBar 배경색
        ),
        body: const Center(
          child: Text(
            '안녕',
            style: TextStyle(
              fontSize: 24, // 텍스트 크기
              fontWeight: FontWeight.bold, // 텍스트 굵기
            ),
          ),
        ),
      ),
    );
  }
}
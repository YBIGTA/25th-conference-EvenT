// // import 'package:flutter/material.dart';
// // import 'package:swipe_cards/swipe_cards.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// //
// // // 서버 요청 함수
// // Future<List<SwipeItem>> fetchInitialCards(String userId) async {
// //   try {
// //     final response = await http.get(
// //       Uri.parse('http://localhost:8080/pinecone/search?userId=$userId'),
// //     );
// //
// //     if (response.statusCode == 200) {
// //       final List<dynamic> data = json.decode(response.body);
// //
// //       return data.map((item) {
// //         final s3Url = item['item']['s3Url'];
// //         return SwipeItem(
// //           content: s3Url ?? 'https://via.placeholder.com/391x579',
// //           likeAction: () => print("스타일을 좋아하셨습니다.❤️"),
// //           nopeAction: () => print("스타일을 싫어하셨습니다.💔"),
// //           superlikeAction: () => print("스타일을 저장하셨습니다!😙"),
// //         );
// //       }).toList();
// //     } else {
// //       throw Exception("Failed to load cards");
// //     }
// //   } catch (e) {
// //     print("Error: $e");
// //     return [];
// //   }
// // }
// //
// // Future<void> requestMoreCards(String userId) async {
// //   try {
// //     final response = await http.post(
// //       Uri.parse('http://localhost:8080/pinecone/action/add'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: json.encode({"userId": userId, "clothesId": 101}), // clothesId는 예시값
// //     );
// //
// //     if (response.statusCode != 200) {
// //       throw Exception("Failed to request more cards");
// //     }
// //   } catch (e) {
// //     print("Error: $e");
// //   }
// // }
// //
// //
// //
// // // 앱바
// // class StylePage extends StatelessWidget {
// //   final String userId;
// //   StylePage({required this.userId});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     print(userId);
// //     return SwipeCardView(userId: userId);
// //   }
// // }
// //
// //
// //
// // class SwipeCardView extends StatefulWidget {
// //   final String userId;
// //   SwipeCardView({required this.userId});
// //
// //   @override
// //   _SwipeCardViewState createState() => _SwipeCardViewState();
// // }
// //
// // class _SwipeCardViewState extends State<SwipeCardView> {
// //   List<SwipeItem> swipeItems = [];
// //   MatchEngine? matchEngine;
// //
// //   final List<String> cardImages = [
// //     'https://via.placeholder.com/391x579',
// //     'https://via.placeholder.com/397x551',
// //     'https://via.placeholder.com/394x602',
// //   ];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     // SwipeItem 생성
// //     for (int i = 0; i < cardImages.length; i++) {
// //       swipeItems.add(SwipeItem(
// //         content: cardImages[i],
// //         likeAction: () {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text("스타일을 좋아하셨습니다.❤️ ${i + 1}")),
// //           );
// //         },
// //         nopeAction: () {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text("스타일을 싫어하셨습니다.💔 ${i + 1}")),
// //           );
// //         },
// //         superlikeAction: () {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text("스타일을 저장하셨습니다!😙 ${i + 1}")),
// //           );
// //         },
// //       ));
// //     }
// //
// //     // MatchEngine 초기화
// //     matchEngine = MatchEngine(swipeItems: swipeItems);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         Align(
// //           alignment: Alignment.topCenter, // 수평 가운데 정렬
// //           child: Padding(
// //             padding: const EdgeInsets.only(top: 50), // 상단에서 150px 아래로 배치
// //             child: SwipeCards(
// //               matchEngine: matchEngine!,
// //               itemBuilder: (BuildContext context, int index) {
// //                 return _buildCard(swipeItems[index].content);
// //               },
// //               onStackFinished: () {
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(content: Text("No more cards!")),
// //                 );
// //               },
// //               upSwipeAllowed: true,
// //               fillSpace: false,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildCard(String imageUrl) {
// //     return Container(
// //       width: 316,
// //       height: 551,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(25),
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.1),
// //             blurRadius: 22,
// //             offset: const Offset(0, 17),
// //           ),
// //         ],
// //       ),
// //       child: Stack(
// //         children: [
// //           Positioned.fill(
// //             child: ClipRRect(
// //               borderRadius: BorderRadius.circular(25),
// //               child: Image.network(imageUrl, fit: BoxFit.fill),
// //             ),
// //           ),
// //
// //           // 하단 그라데이션
// //           Positioned(
// //             bottom: 0,
// //             child: Container(
// //               height: 140,
// //               width: 316,
// //               decoration: const BoxDecoration(
// //                 gradient: LinearGradient(
// //                   begin: Alignment.bottomCenter,
// //                   end: Alignment.topCenter,
// //                   colors: [Colors.black, Colors.transparent],
// //                 ),
// //                 borderRadius: BorderRadius.only(
// //                   bottomLeft: Radius.circular(25),
// //                   bottomRight: Radius.circular(25),
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //           //하단 아이콘들
// //           Positioned(
// //             bottom: 20,
// //             left: 20,
// //             child: IconButton(
// //               icon: Icon(Icons.clear, color: Colors.white, size: 30),
// //               onPressed: () {
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(content: Text("스타일을 싫어하셨습니다.💔")),
// //                 );
// //               },
// //             ),
// //           ),
// //           Positioned(
// //             bottom: 20,
// //             right: 20,
// //             child: IconButton(
// //               icon: Icon(Icons.check, color: Colors.white, size: 30),
// //               onPressed: () {
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(content: Text("스타일을 좋아하셨습니다.❤️")),
// //                 );
// //               },
// //             ),
// //           ),
// //           Positioned(
// //             bottom: 20,
// //             left: 0,
// //             right: 0,
// //             child: Center(
// //               child: IconButton(
// //                 icon: Icon(Icons.favorite, color: Colors.white, size: 30),
// //                 onPressed: () {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(content: Text("스타일을 저장하셨습니다!😙")),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
// // Future<void> requestMoreCards(String userId) async {
// //   try {
// //     final response = await http.post(
// //       Uri.parse('http://43.203.171.133:8080/pinecone/action/add'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: json.encode({"userId": userId, "clothesId": 101}), // clothesId는 예시값
// //     );
// //
// //     if (response.statusCode != 200) {
// //       throw Exception("Failed to request more cards");
// //     }
// //   } catch (e) {
// //     print("Error: $e");
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:swipe_cards/swipe_cards.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// /// 서버 요청 함수들
// Future<List<SwipeItem>> fetchInitialCards(String userId, BuildContext context) async {
//   try {
//     final response = await http.get(
//       Uri.parse('http://43.203.171.133:8080/pinecone/search?userId=user00'),
//     );
//     // 요청 바디
//     print("Response Body: ${response.body}");
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       // 요청 데이터
//       print("Data : $data");
//
//       // SwipeItem 리스트 생성
//       final cards = data
//           .map<String>((item) => item['item']['s3Url'])
//           .toList();
//
//       print("SwipeItems: $cards");
//
//       return cards;
//
//     } else {
//       throw Exception("Failed to load cards");
//     }
//   } catch (e) {
//     print("Error: $e");
//     return [];
//   }
// }
//
// /// 페이지 및 UI 코드
// class StylePage extends StatelessWidget {
//   final String userId;
//   StylePage({required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     return SwipeCardView(userId: userId);
//   }
// }
//
// class SwipeCardView extends StatefulWidget {
//   final String userId;
//   SwipeCardView({required this.userId});
//
//   @override
//   _SwipeCardViewState createState() => _SwipeCardViewState();
// }
//
// class _SwipeCardViewState extends State<SwipeCardView> {
//   List<String> s3Urls = []; // s3Url 저장 리스트
//   List<SwipeItem> swipeItems = [];
//   MatchEngine? matchEngine;
//
//   @override
//   void initState() {
//     super.initState();
//     loadInitialCards();
//   }
//
//   void loadInitialCards() async {
//     final fetchedItems = await fetchInitialCards(widget.userId, context);
//
//     setState(() {
//       // 추가된 s3Urls 디버깅
//       print("Fetched SwipeItems: ${fetchedItems.map((item) => item.content).toList()}");
//
//       s3Urls.addAll(fetchedItems.map((item) => item.content));
//       print("Updated s3Urls after addAll: $s3Urls");
//
//       updateSwipeItems();
//     });
//   }
//   void showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//   void updateSwipeItems() {
//     if (s3Urls.isEmpty) {
//       print("No URLs available to update SwipeItems!");
//       return;
//     }
//
//     setState(() {
//       swipeItems = s3Urls.map((url) {
//         return SwipeItem(
//           content: url,
//           likeAction: () {
//             showSnackBar("스타일을 좋아하셨습니다.❤️");
//             handleSwipe();
//           },
//           nopeAction: () {
//             showSnackBar("스타일을 싫어하셨습니다.💔");
//             handleSwipe();
//           },
//           superlikeAction: () {
//             showSnackBar("스타일을 저장하셨습니다!😙");
//             handleSwipe();
//           },
//         );
//       }).toList();
//
//       // `MatchEngine`이 null이거나 swipeItems가 없을 경우 재생성
//       if (matchEngine == null || swipeItems.isEmpty) {
//         matchEngine = MatchEngine(swipeItems: swipeItems);
//       } else {
//         // 이미 초기화된 경우 matchEngine에 새 SwipeItems를 연결
//         matchEngine!.swipeItems = swipeItems;
//       }
//
//       print("SwipeItems updated: ${swipeItems.length}");
//       print("MatchEngine initialized: ${matchEngine != null}");
//     });
//   }
//
//   void handleSwipe() {
//     if (s3Urls.isEmpty) {
//       print("No more URLs to swipe!");
//       return;
//     }
//
//     setState(() {
//       // 가장 앞의 URL 제거
//       s3Urls.removeAt(0);
//       print("Updated s3Urls after removal: $s3Urls");
//
//       // 카드 부족 시 새 데이터 로드
//       if (s3Urls.length <= 2) {
//         print("카드 부족! Fetching more...");
//         loadInitialCards();
//         updateSwipeItems(); // 새 데이터 반영
//       }
//     });
//
//     // SwipeItems 업데이트
//     updateSwipeItems();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           if (matchEngine != null && swipeItems.isNotEmpty) // matchEngine과 swipeItems가 유효한지 확인
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 50),
//                 child: SwipeCards(
//                   matchEngine: matchEngine!,
//                   itemBuilder: (BuildContext context, int index) {
//                     return _buildCard(swipeItems[index].content);
//                   },
//                   onStackFinished: () {
//                     showSnackBar("No more cards!");
//                   },
//                   upSwipeAllowed: true,
//                   fillSpace: false,
//                 ),
//               ),
//             ),
//           if (matchEngine == null || swipeItems.isEmpty) // 로딩 상태를 표시
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard(String imageUrl) {
//     return Container(
//       width: 316,
//       height: 551,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 22,
//             offset: const Offset(0, 17),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(25),
//         child: Image.network(imageUrl, fit: BoxFit.cover),
//       ),
//     );
//   }
//
//
//
//
//   // void loadInitialCards() async {
//   //   final cards = await fetchInitialCards(widget.userId, context);
//   //   setState(() {
//   //     swipeItems = cards.map((item) {
//   //       return SwipeItem(
//   //         content: item.content,
//   //         likeAction: () {
//   //           showSnackBar("스타일을 좋아하셨습니다.❤️");
//   //           removeCardAndCheck();
//   //         },
//   //         nopeAction: () {
//   //           showSnackBar("스타일을 싫어하셨습니다.💔");
//   //           removeCardAndCheck();
//   //         },
//   //         superlikeAction: () {
//   //           showSnackBar("스타일을 저장하셨습니다!😙");
//   //           removeCardAndCheck();
//   //         },
//   //       );
//   //     }).toList();
//   //
//   //     matchEngine = MatchEngine(swipeItems: swipeItems);
//   //   });
//   }
//
//   // /// 추가 카드를 요청하는 함수
//   // void loadMoreCards() async {
//   //   await requestMoreCards(widget.userId);
//   //   loadInitialCards(); // 새로운 카드 데이터를 로드
//   // }
//   //
//   // /// 남은 카드 수 확인 및 추가 카드 요청
//   // void removeCardAndCheck() {
//   //   setState(() {
//   //     swipeItems.removeAt(0); // 가장 앞의 카드 제거
//   //   });
//   //   if (swipeItems.length <= 3) {
//   //     loadMoreCards(); // 카드가 3개 이하이면 추가 요청
//   //   }
//   // }
//   //
//   // void showSnackBar(String message) {
//   //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   // }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Stack(
//   //     children: [
//   //       if (matchEngine != null)
//   //         Align(
//   //           alignment: Alignment.topCenter,
//   //           child: Padding(
//   //             padding: const EdgeInsets.only(top: 50),
//   //             child: SwipeCards(
//   //               matchEngine: matchEngine!,
//   //               itemBuilder: (BuildContext context, int index) {
//   //                 return _buildCard(swipeItems[index].content);
//   //               },
//   //               onStackFinished: () {
//   //                 ScaffoldMessenger.of(context).showSnackBar(
//   //                   SnackBar(content: Text("No more cards!")),
//   //                 );
//   //               },
//   //               upSwipeAllowed: true,
//   //               fillSpace: false,
//   //             ),
//   //           ),
//   //         ),
//   //     ],
//   //   );
//   // }
//   //
//   // Widget _buildCard(String imageUrl) {
//   //   return Container(
//   //     width: 316,
//   //     height: 551,
//   //     decoration: BoxDecoration(
//   //       borderRadius: BorderRadius.circular(25),
//   //       color: Colors.white,
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Colors.black.withOpacity(0.1),
//   //           blurRadius: 22,
//   //           offset: const Offset(0, 17),
//   //         ),
//   //       ],
//   //     ),
//   //     child: ClipRRect(
//   //       borderRadius: BorderRadius.circular(25),
//   //       child: Image.network(imageUrl, fit: BoxFit.cover),
//   //     ),
//   //   );
//   // }
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// 서버 요청 함수들
Future<List<SwipeItem>> fetchInitialCards(String userId) async {
  try {
    final response = await http.get(
      Uri.parse('http://43.203.171.133:8080/pinecone/search?userId=user00'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // SwipeItem 리스트 생성
      return data.map((item) {
        final s3Url = item['item']['s3Url'] ?? 'https://via.placeholder.com/391x579';
        return SwipeItem(
          content: s3Url,
        );
      }).toList();
    } else {
      throw Exception("Failed to load cards");
    }
  } catch (e) {
    print("Error: $e");
    return [];
  }
}

/// 페이지 및 UI 코드
class StylePage extends StatelessWidget {
  final String userId;
  StylePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return SwipeCardView(userId: userId);
  }
}

class SwipeCardView extends StatefulWidget {
  final String userId;
  SwipeCardView({required this.userId});

  @override
  _SwipeCardViewState createState() => _SwipeCardViewState();
}

class _SwipeCardViewState extends State<SwipeCardView> {
  List<SwipeItem> swipeItems = []; // SwipeItem 리스트
  MatchEngine? matchEngine;

  @override
  void initState() {
    super.initState();
    loadInitialCards(); // 초기 데이터 로드
  }

  /// 서버에서 초기 데이터 로드
  void loadInitialCards() async {
    final fetchedItems = await fetchInitialCards(widget.userId);

    setState(() {
      swipeItems.addAll(fetchedItems); // 가져온 데이터 추가
      updateMatchEngine(); // MatchEngine 업데이트
    });
  }

  /// MatchEngine 업데이트
  void updateMatchEngine() {
    if (swipeItems.isEmpty) {
      print("No SwipeItems available to update MatchEngine!");
      return;
    }

    setState(() {
      matchEngine = MatchEngine(swipeItems: swipeItems);
      print("MatchEngine updated with ${swipeItems.length} items.");
    });
  }

  /// 스와이프 처리
  void handleSwipe() async {
    setState(() {
      if (swipeItems.isNotEmpty) {
        swipeItems.removeAt(0); // 첫 번째 카드 제거
      }

      print("남은 카드 길이: ${swipeItems.length}");

      // 카드가 2개 이하일 때 추가 데이터 로드
      if (swipeItems.length <= 2) {
        print("카드 부족! Fetching more...");
        fetchAndAddMoreCards(); // 추가 데이터 로드
      }
    });
  }

  /// 추가 데이터 로드
  void fetchAndAddMoreCards() async {
    final moreCards = await fetchInitialCards(widget.userId);

    setState(() {
      swipeItems.addAll(moreCards); // 새 카드 추가
      updateMatchEngine(); // MatchEngine 동기화
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (matchEngine != null && swipeItems.isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SwipeCards(
                  matchEngine: matchEngine!,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCard(swipeItems[index].content);
                  },
                  onStackFinished: () {
                    setState(() {
                      print("All cards swiped. Fetching new cards...");
                      fetchAndAddMoreCards(); // 카드 소진 시 새 데이터 가져오기
                    });
                  },
                  upSwipeAllowed: true,
                  fillSpace: false,
                ),
              ),
            ),
          if (matchEngine == null || swipeItems.isEmpty)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildCard(String imageUrl) {
    return Container(
      width: 316,
      height: 551,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 22,
            offset: const Offset(0, 17),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
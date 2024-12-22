import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

// 앱바
class StylePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SwipeCardView();
  }
}


class SwipeCardView extends StatefulWidget {
  @override
  _SwipeCardViewState createState() => _SwipeCardViewState();
}

class _SwipeCardViewState extends State<SwipeCardView> {
  List<SwipeItem> swipeItems = [];
  MatchEngine? matchEngine;

  final List<String> cardImages = [
    'https://via.placeholder.com/391x579',
    'https://via.placeholder.com/397x551',
    'https://via.placeholder.com/394x602',
  ];

  @override
  void initState() {
    super.initState();

    // SwipeItem 생성
    for (int i = 0; i < cardImages.length; i++) {
      swipeItems.add(SwipeItem(
        content: cardImages[i],
        likeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("스타일을 좋아하셨습니다.❤️ ${i + 1}")),
          );
        },
        nopeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("스타일을 싫어하셨습니다.💔 ${i + 1}")),
          );
        },
        superlikeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("스타일을 저장하셨습니다!😙 ${i + 1}")),
          );
        },
      ));
    }

    // MatchEngine 초기화
    matchEngine = MatchEngine(swipeItems: swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter, // 수평 가운데 정렬
          child: Padding(
            padding: const EdgeInsets.only(top: 50), // 상단에서 150px 아래로 배치
            child: SwipeCards(
              matchEngine: matchEngine!,
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(swipeItems[index].content);
              },
              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No more cards!")),
                );
              },
              upSwipeAllowed: true,
              fillSpace: false,
            ),
          ),
        ),
      ],
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
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(imageUrl, fit: BoxFit.fill),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 140,
              width: 316,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
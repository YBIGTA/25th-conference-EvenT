import 'package:flutter/material.dart';
import 'tops_details.dart';
import 'bottoms_details.dart';
import '../../widgets/font.dart';
import '../../widgets/button.dart';
import '../../home_page.dart';

//블록 사이 여백
const btwblocks = SizedBox(height: 24);
const btwtxt = SizedBox(height: 8);


class SignupDBPage extends StatelessWidget {
  final String userId;
  const SignupDBPage({super.key, required this.userId});

  // 상의 블록 데이터
  static const List<Map<String, String>> topsItems = [
    {'label': '긴팔상의', 'imagePath': 'assets/images/long_sleeve.png'},
    {'label': '반팔상의', 'imagePath': 'assets/images/short_sleeve.png'},
    {'label': '셔츠', 'imagePath': 'assets/images/shirt.png'},
    {'label': '민소매', 'imagePath': 'assets/images/sleeveless.png'},
  ];

  // 하의 블록 데이터
  static const List<Map<String, String>> bottomsItems = [
    {'label': '반바지', 'imagePath': 'assets/images/short_pants.png'},
    {'label': '긴바지', 'imagePath': 'assets/images/long_pants.png'},
    {'label': '스커트', 'imagePath': 'assets/images/skirts.png'}
  ];

  // 아우터 블록 데이터
  static const List<Map<String, String>> outersItems = [
    {'label': '패딩', 'imagePath': 'assets/images/padded_jk.png'},
    {'label': '코트', 'imagePath': 'assets/images/coat.png'},
    {'label': '가디건', 'imagePath': 'assets/images/cardigan.png'},
    {'label': '재킷', 'imagePath': 'assets/images/jacket.png'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close), // X 버튼
          onPressed: () {
            Navigator.pop(context); // 홈으로 돌아가기
          },
        ),
        title: const Text(
          '내 옷장 만들기',
          style: AppFonts.appBarStyle,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
        30.0, // 좌측마진
        10.0, // 상단마진
        30.0, // 우측마진
        80.0, // 하단마진
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 질문 텍스트
            const SizedBox(height: 20),
            const Center( // 중앙 정렬
              child: Text(
                '집에 있는 옷들을 추가해주세요!',
                textAlign: TextAlign.center,
                style: AppFonts.highlightStyle,
              ),
            ),
            const SizedBox(height: 15),

            // 상의 텍스트
            const Text(
              '상의',
              style: AppFonts.bodyStyle,
              textAlign: TextAlign.left,
            ),
            btwtxt,

            // 상의 블록
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),

              padding: const EdgeInsets.only(bottom:10),
              itemCount: topsItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = topsItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            TopsDetailPage(
                              label: item['label']!,
                              imagePath: item['imagePath']!,
                              userId: userId,
                            ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: buildClothingBlock(item['label']!, item['imagePath']!),
                );
              },
            ),
            btwblocks,

            // 하의 텍스트
            const Text(
              '하의',
              style: AppFonts.bodyStyle,
              textAlign: TextAlign.left,
            ),
            btwtxt,

            // 하의 블록
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              padding: const EdgeInsets.only(bottom:10),
              itemCount: bottomsItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = bottomsItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            BottomsDetailPage(
                              label: item['label']!,
                              imagePath: item['imagePath']!,
                              userId: userId,
                            ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: buildClothingBlock(item['label']!, item['imagePath']!),
                );
              },
            ),
            btwblocks,

            // 아우터 텍스트
            const Text(
              '아우터',
              style: AppFonts.bodyStyle,
              textAlign: TextAlign.left,
            ),
            btwtxt,

            // 아우터 블록
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              padding: const EdgeInsets.only(bottom:10),
              itemCount: outersItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = outersItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            BottomsDetailPage(
                              label: item['label']!,
                              imagePath: item['imagePath']!,
                              userId: userId,
                            ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: buildClothingBlock(item['label']!, item['imagePath']!),
                );
              },

            ),

            const SizedBox(height: 50,),

            // 회원가입 버튼 추가
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 회원가입 완료 메시지
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('내 옷장이 만들어졌습니다! 이제 로그인을 진행해주세요.'),
                      duration: Duration(seconds: 1),
                    ),
                  );

                  // HomePage로 이동
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  });
                },
                style: AppButtonStyles.otherButton(), // 버튼 스타일 적용
                child: const Text(
                  '옷장 만들기',
                  style: AppFonts.loginStyle,
                ),
              ),
            ),

            const SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }

  Widget buildClothingBlock(String label, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFBEBEBE), width: 1.0),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                5.0, // 좌측마진
                8.0, // 상단마진
                5.0, // 우측마진
                0, // 하단마진
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: AppFonts.signupDB
          ),
          const SizedBox(height:8)
        ],
      ),
    );
  }
}

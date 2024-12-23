import 'package:event_flutter/home_screen/closet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 파일을 사용하기 위한 패키지
import '../home_screen/style_page.dart';
import '../home_screen/save_page.dart';
import '../home_screen/closet_page.dart';

class CommonLayout extends StatefulWidget {

  final String userId; // 로그인된 userId 전달
  CommonLayout({required this.userId});

  @override
  _CommonLayoutState createState() => _CommonLayoutState();
}

class _CommonLayoutState extends State<CommonLayout> {
  int _currentIndex = 1; // 현재 선택된 탭의 인덱스

  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();

    // 페이지 리스트 초기화하면서 userId 전달
    _pages = [
      Center(child: Text('등록 페이지')), // userId 전달
      StylePage(userId: widget.userId), // userId 전달
      SavePage(userId: widget.userId), // userId 전달
      ClosetPage(), // userId 전달
    ];

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _pages[_currentIndex], // 현재 선택된 페이지
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "EvenT",
          style: const TextStyle(
            fontFamily: 'Prtendard',
            color: Color(0xFF70605E), // black or 0xFF70605E
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: const Color(0xFFC4B8B6), // 0xFFC4B8B6 or 0xFFE4E4E4 ?
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    const double sideMargin = 10; // 양옆마진
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 활성화된 탭의 상단 경계선 표시
          if (_currentIndex != -1)
            Positioned(
              left: _getIndicatorPosition(_currentIndex, sideMargin),
              top: 0,
              child: Container(
                width: 80,
                height: 4,
                color: Color(0xFFC4B8B6), // 활성화된 탭의 색상
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: sideMargin),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem('assets/icons/register.svg', '등록', 0),
                _buildBottomNavItem('assets/icons/style.svg', '스타일', 1),
                _buildBottomNavItem('assets/icons/save.svg', '저장', 2),
                _buildBottomNavItem('assets/icons/closet.svg', '옷장', 3),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(String iconPath, String label, int index) {
    bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index; // 현재 선택된 탭 변경
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 32,
            width: 32,
            color: isSelected
                ? Color(0xFFC4B8B6) // 활성화된 탭의 아이콘 색상
                : Color(0xFF5E5E5E), // 비활성화된 탭의 아이콘 색상
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Color(0xFFC4B8B6) : Color(0xFF5E5E5E),
            ),
          ),
        ],
      ),
    );
  }

  /// 활성화된 탭의 사각형 위치 계산
  double _getIndicatorPosition(int index, double sideMargin) {
    // 탭 너비를 계산 (화면 너비 - 양옆 마진)
    double tabWidth = (MediaQuery.of(context).size.width - (sideMargin * 2)) / 4;

    // 각 탭의 중앙에 사각형 위치 (좌측 마진 + 탭 시작점 + 탭 중앙 - 사각형 절반 너비)
    return sideMargin + (index * tabWidth) + (tabWidth / 2) - (60 / 2); // 60은 사각형 너비
  }
}
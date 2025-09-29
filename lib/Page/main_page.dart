import 'dart:async';
import 'package:aa/Page/Camera/gallery_grid_page.dart';
import 'package:aa/Page/Function.page/effect_page.dart';
import 'package:aa/Page/Login.page/login_page.dart';
import 'package:aa/Page/Function.page/map_page.dart';
import 'package:aa/Page/Function.page/mypage_page.dart';
import 'package:aa/Page/Setting.page/setting_page.dart';
import 'package:aa/Widget/case_example_slider.dart';
import 'package:aa/Widget/showbanner_widget.dart';
import 'package:flutter/material.dart';

// 광고 관련
int currentAdIndex = 0;
final List<String> adImages = [
  'assets/images/smoke1.png',
  'assets/images/smoke2.png',
  'assets/images/smoke3.png',
];
bool _showBanner = true;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  UserInfo? _userInfo;
  late Timer _profileTimer;
  late Timer _adTimer;

  final List<Map<String, dynamic>> menuItems = const [
    {'image': 'assets/images/siren.png', 'label': '신고하기'},
    {'image': 'assets/images/map.png', 'label': '흡연장 찾기'},
    {'image': 'assets/images/clock.png', 'label': '금연 효과'},
    {'image': 'assets/images/person.png', 'label': '마이 페이지'},
  ];

  @override
  void initState() {
    super.initState();

    // 광고 배너 5초마다 변경
    _adTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentAdIndex = (currentAdIndex + 1) % adImages.length;
      });
    });

    // 카드 프로필 실시간 갱신
    _profileTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_userInfo != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _adTimer.cancel();
    _profileTimer.cancel();
    super.dispose();
  }

  // 금연 시간 포맷
  String _formatDurationSince(DateTime since) {
    final elapsed = DateTime.now().difference(since);
    final days = elapsed.inDays;
    final hours = elapsed.inHours % 24;
    final minutes = elapsed.inMinutes % 60;
    final seconds = elapsed.inSeconds % 60;
    return '${days}일 ${hours}시간 ${minutes}분 ${seconds}초';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 절약한 금액 계산 (소수점 첫째 자리)
    String savedMoneyText = '정보 없음';
    String quitTimeText = '정보 없음';
    final pricePerCig = 225;

    if (_userInfo != null) {
      final elapsedSeconds = DateTime.now()
          .difference(_userInfo!.quitStartDate)
          .inSeconds;
      final perSecondCig = _userInfo!.avgCigsPerDay / 86400; // 1초당 흡연량
      final perSecondMoney = perSecondCig * pricePerCig; // 1초당 절약 금액
      final savedMoney = perSecondMoney * elapsedSeconds;
      savedMoneyText = '${savedMoney.toStringAsFixed(1)}원';

      quitTimeText = _formatDurationSince(_userInfo!.quitStartDate);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('메인 페이지'),
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingPage()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.07),

              // 카드 프로필
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    const TableRow(
                      children: [
                        Text(
                          '프로필',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBFBFBF),
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          '아이디',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBFBFBF),
                          ),
                        ),
                        Text(
                          'jinwon0134:db id',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBFBFBF),
                          ),
                        ),
                      ],
                    ),

                    TableRow(
                      children: [
                        const Text(
                          '금연시간',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBFBFBF),
                          ),
                        ),
                        Text(
                          quitTimeText,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBFBFBF),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          '절약한 금액',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBFBFBF),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              savedMoneyText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFBFBFBF),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/images/money.png',
                              width: screenWidth * 0.08,
                              height: screenWidth * 0.08,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.075),

              // 메뉴 그리드
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.08,
                  mainAxisSpacing: screenHeight * 0.04,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: menuItems.map((item) {
                    return GestureDetector(
                      onTap: () async {
                        final label = item['label'];

                        if (label == '흡연장 찾기') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MapPage()),
                          );
                        } else if (label == '신고하기') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GalleryGridPage(),
                            ),
                          );
                        } else if (label == '마이 페이지') {
                          final info = await Navigator.push<UserInfo>(
                            context,
                            MaterialPageRoute(builder: (_) => const MyPage()),
                          );
                          if (info != null) {
                            setState(() {
                              _userInfo = info;
                            });
                          }
                        } else if (label == '금연 효과') {
                          if (_userInfo == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('먼저 마이페이지에서 정보를 입력해 주세요'),
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EffectPage(
                                quitStartDate: _userInfo!.quitStartDate,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFEDEDED),
                            width: screenWidth * 0.03,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              item['image'],
                              width: screenWidth * 0.15,
                              height: screenWidth * 0.15,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              item['label'],
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: screenHeight * 0.1),

              // 📌 주요 처리 사례 카드
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3, // 화면 높이의 30%
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: const [
                              Icon(
                                Icons.find_in_page_outlined,
                                size: 25,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 8), // 아이콘과 텍스트 간 간격
                              Text("주요처리사례", style: TextStyle(fontSize: 20)),
                            ],
                          ),

                          // 오른쪽: 버튼
                          TextButton(
                            onPressed: () {
                              // 버튼 클릭 시 동작
                            },
                            child: const Text(
                              "더보기 +",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: CaseExampleSlider(
                        imagePairs: [
                          [
                            "assets/images/usethenewpic1.png",
                            "assets/images/usethenewpic2.png",
                          ],
                          [
                            "assets/images/usethenewpic1.png",
                            "assets/images/usethenewpic2.png",
                          ],
                        ],
                        descriptions: ["융과 4층 계단", "융과 2층 테라스"],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _showBanner
          ? ShowBannerWidget(
              imagePath: adImages[currentAdIndex],
              onClose: () {
                setState(() {
                  _showBanner = false;
                });
              },
            )
          : null,
    );
  }
}

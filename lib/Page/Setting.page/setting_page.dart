import 'package:aa/Page/setting.page/Version_page.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isSmokeEffectOn = true;
  bool isMotivationOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('설정'),
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: Colors.black)),
      ),
      body: ListView(
        children: [
          // --- 계정 관리 ---
          _buildSectionTitle("계정 관리"),
          _buildSimpleTile("로그아웃", onTap: () => _showLogoutDialog()),
          _buildSimpleTile("비밀번호 변경", onTap: () {}),
          _buildSimpleTile("회원 탈퇴", onTap: () => _showSecessionDialog()),

          // --- 이용 안내 ---
          _buildSectionTitle("이용 안내"),
          _buildSimpleTile("문의하기", onTap: () {}),
          _buildSimpleTile("개인정보처리방침", onTap: () {}),
          _buildSimpleTile(
            "앱 버전",
            trailing: const Text(
              "v1.0.0",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VersionPage()),
              );
            },
          ),

          // --- 알림 ---
          _buildSectionTitle("알림"),
          _buildSwitchTile(
            "금연 효과 달성 알림",
            isSmokeEffectOn,
            (val) => setState(() => isSmokeEffectOn = val),
          ),
          _buildSwitchTile(
            "동기부여 알림",
            isMotivationOn,
            (val) => setState(() => isMotivationOn = val),
          ),

          // --- 데이터 관리 ---
          _buildSectionTitle("데이터 관리"),
          _buildSimpleTile("데이터 백업하기", onTap: () {}),
          _buildSimpleTile("백업 데이터 불러오기", onTap: () {}),
          _buildSimpleTile("캐시 삭제", onTap: () {}),
        ],
      ),
    );
  }

  // 섹션 제목
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 일반 항목 (클릭 가능)
  Widget _buildSimpleTile(
    String title, {
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 60, right: 16),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: trailing,
      onTap: onTap,
      visualDensity: const VisualDensity(vertical: -2), // 높이 줄이기
    );
  }

  // 스위치 항목
  Widget _buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 60, right: 16),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: Switch(value: value, onChanged: onChanged),
      visualDensity: const VisualDensity(vertical: -2),
    );
  }

  /*---------------------------------------------------
로그아웃 팝업창
---------------------------------------------------*/
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            height: 250,
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "정말 로그아웃 하시겠습니까?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          "아니요",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // 로그아웃 처리
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[900],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text("네", style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /*---------------------------------------------------
회원탈퇴 팝업창
---------------------------------------------------*/
  void _showSecessionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            height: 250,
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Title(
                  color: Colors.black,
                  child: Text(
                    "정말 탈퇴하시겠어요?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                const Text(
                  "탈퇴 버튼 선택 시, 계정은 \n삭제되어 복구되지 않습니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),

                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // 탈퇴 처리
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF6D6D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(50), // 세로 높이 지정
                      ),
                      child: const Text(
                        "탈퇴",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(50), // 세로 높이 지정
                      ),
                      child: const Text("아니요", style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

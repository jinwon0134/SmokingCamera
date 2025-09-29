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
          _buildSimpleTile("로그아웃", onTap: () {}),
          _buildSimpleTile("비밀번호 변경", onTap: () {}),
          _buildSimpleTile("회원 탈퇴", onTap: () {}),

          // --- 이용 안내 ---
          _buildSectionTitle("이용 안내"),
          _buildSimpleTile("문의하기", onTap: () {}),
          _buildSimpleTile("개인정보처리방침", onTap: () {}),
          _buildSimpleTile("앱 버전", onTap: () {}),

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
  Widget _buildSimpleTile(String title, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 60, right: 16),
      title: Text(title, style: const TextStyle(fontSize: 18)),
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
}

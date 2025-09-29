import 'package:flutter/material.dart';

class VersionPage extends StatelessWidget {
  final String currentVersion = "3.8.4";
  final String latestVersion = "3.8.4";

  @override
  Widget build(BuildContext context) {
    bool isUpToDate = currentVersion == latestVersion;

    return Scaffold(
      appBar: AppBar(
        title: const Text("앱 버전"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1️⃣ 이미지
            Image.asset(
              'assets/images/찍었담.png', // 여기에 아이콘 이미지 넣기
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),

            // 2️⃣ 버전 정보
            Text("현재버전: $currentVersion", style: const TextStyle(fontSize: 18)),
            Text(
              "최신버전: $latestVersion",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // 3️⃣ 업데이트 버튼
            ElevatedButton(
              onPressed: isUpToDate
                  ? null
                  : () {
                      // 업데이트 기능 구현
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isUpToDate ? Colors.grey : Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "업데이트",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

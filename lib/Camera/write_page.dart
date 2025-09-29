import 'dart:io';
import 'package:flutter/material.dart';

class WritePage extends StatelessWidget {
  final List<File> selectedImages; // 갤러리에서 선택한 이미지

  const WritePage({super.key, required this.selectedImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('문의하기', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        shape: const Border(bottom: BorderSide(color: Colors.grey)),
      ),
      body: SingleChildScrollView(
        // ⬅️ 스크롤 가능하도록 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            // 이메일 입력
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("답변 받으실 이메일", style: TextStyle(fontSize: 16)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFBFBFBF)),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "email@example.com",
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("등록한 사진", style: TextStyle(fontSize: 16)),
            ),
            // 선택한 이미지 미리보기
            if (selectedImages.isNotEmpty)
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 1), // 위쪽 선
                    bottom: BorderSide(color: Colors.grey, width: 1), // 아래쪽 선
                  ),
                ),
                child: SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.file(
                          selectedImages[index],
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("문의 내용", style: TextStyle(fontSize: 16)),
            ),

            // 글 작성 TextField
            const Padding(
              padding: EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "여기에 글을 작성하세요...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),

            // 문의하기 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 버튼 클릭 시 동작
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "문의하기",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // FAQ 예시
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "자주 묻는 질문",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("□ 질문1"),
                  Text("□ 질문2"),
                  Text("□ 질문3"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

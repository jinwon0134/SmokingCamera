import 'package:flutter/material.dart';

class CaseExampleSlider extends StatefulWidget {
  final List<List<String>> imagePairs; // [[img1, img2], [img3, img4], ...]
  final List<String> descriptions; // 페이지별 텍스트

  const CaseExampleSlider({
    super.key,
    required this.imagePairs,
    required this.descriptions,
  });

  @override
  State<CaseExampleSlider> createState() => _CaseExampleSliderState();
}

class _CaseExampleSliderState extends State<CaseExampleSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  final double imageHeight = 120; // 이미지 높이 조정 가능

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ 높이를 명확히 지정해줌
        SizedBox(
          height: imageHeight + 50, // 이미지 + 설명 공간 확보
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePairs.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final pair = widget.imagePairs[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(pair[0], fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 16),
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(pair[1], fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.descriptions[index],
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

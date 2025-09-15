import 'package:flutter/material.dart';

class CaseExampleSlider extends StatefulWidget {
  final List<List<String>> imagePairs; // [[img1, img2], [img3, img4], ...]
  final List<String> descriptions; // 페이지별 텍스트

  const CaseExampleSlider({
    super.key,
    required this.imagePairs,
    required this.descriptions, // ✅ 추가
  });

  @override
  State<CaseExampleSlider> createState() => _CaseExampleSliderState();
}

class _CaseExampleSliderState extends State<CaseExampleSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  final double imageSize = 140;

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
        SizedBox(
          height: imageSize + 30,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePairs.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final pair = widget.imagePairs[index];
              return Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: imageSize,
                        height: imageSize,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(pair[0], fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: imageSize,
                        height: imageSize,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(pair[1], fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 8,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.descriptions[index], // 페이지별 텍스트
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

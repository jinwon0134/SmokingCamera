import 'dart:async';
import 'package:flutter/material.dart';

/// 금연 진행 게이지 페이지 (이미지 느낌으로 구성)
class EffectPage extends StatefulWidget {
  /// 금연 시작일. (예: DateTime(2025, 1, 1))
  final DateTime quitStartDate;

  const EffectPage({super.key, required this.quitStartDate});

  @override
  State<EffectPage> createState() => _EffectPageState();
}

class _EffectPageState extends State<EffectPage> {
  late Timer _timer;

  // 목표 기간(각 게이지의 총량)
  final List<_Milestone> _milestones = const [
    _Milestone(
      label: '24시간',
      target: Duration(hours: 24),
      effects: '호흡개선, 폐기능 향상, 산소 공급 개선',
    ),
    _Milestone(
      label: '1주일',
      target: Duration(days: 7),
      effects: '호흡 곤란 감소, 심장박동 개선, 산소 공급 증가',
    ),
    _Milestone(
      label: '1개월',
      target: Duration(days: 30),
      effects: '기침과 가래 감소, 폐의 청소 시작, 호흡기 질환 감소',
    ),
    _Milestone(
      label: '3개월',
      target: Duration(days: 90),
      effects: '폐기능 향상, 운동 능력 향상, 폐의 회복 진행',
    ),
    _Milestone(
      label: '1년',
      target: Duration(days: 365),
      effects: '폐기능 50% 향상, 심혈관 건강, 폐암 위험 감소',
    ),
    _Milestone(
      label: '5년',
      target: Duration(days: 1825),
      effects: '뇌졸중에 걸릴 위험이 비 흡연자와 같아집니다.',
    ),
    _Milestone(
      label: '10년',
      target: Duration(days: 3650),
      effects: '이제는 심장질환 위험도가 비흡연자 수준에 가까워집니다.',
    ),
  ];

  Duration get _elapsed => DateTime.now().difference(widget.quitStartDate);

  String get _elapsedPretty {
    final d = _elapsed.inDays;
    final h = _elapsed.inHours % 24;
    final m = _elapsed.inMinutes % 60;
    final s = _elapsed.inSeconds % 60;
    return '${d}일 ${h}시간 ${m}분 ${s}초 경과 중';
    // 필요하면 두 번째 줄 문구는 앱 정책/공식에 맞춰 교체하세요.
  }

  @override
  void initState() {
    super.initState();
    // 1초마다 새로고침하여 게이지 실시간 갱신
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  double _progressFor(Duration target) {
    final p = _elapsed.inSeconds / target.inSeconds;
    return p.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: Colors.grey[300], height: 32);

    return Scaffold(
      appBar: AppBar(
        title: const Text('기대효과'),
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // 상단 경과/안내 문구 (이미지 상단 텍스트 느낌)
            Text(
              _elapsedPretty,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 6),
            Text(
              '금연 시작일 기준으로 각 단계의 목표가 채워집니다.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            divider,
            // 단계별 카드
            ..._milestones.map((m) {
              final progress = _progressFor(m.target);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 섹션 타이틀 (24시간/1주일/…)
                  Text(
                    m.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 캡슐형 게이지바 (이미지 느낌)
                  _CapsuleProgressBar(progress: progress),
                  const SizedBox(height: 8),
                  // 설명 텍스트
                  Text(m.effects, style: const TextStyle(fontSize: 14)),
                  // 구분선
                  divider,
                ],
              );
            }),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF6F6F6),
    );
  }
}

/// 캡슐(알약) 모양 게이지바
class _CapsuleProgressBar extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0
  const _CapsuleProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(999),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth * progress;
          return Stack(
            children: [
              // 채워지는 부분
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                width: width,
                decoration: BoxDecoration(
                  color: const Color(0xFF25C05B), // 이미지와 비슷한 연두-그린
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              // 중앙 퍼센트(원하면 숨기기)
              Center(
                child: Text(
                  '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 11,
                    color: progress > 0.5 ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Milestone {
  final String label;
  final Duration target;
  final String effects;
  const _Milestone({
    required this.label,
    required this.target,
    required this.effects,
  });
}

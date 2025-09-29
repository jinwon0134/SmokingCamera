// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationSection extends StatefulWidget {
//   const NotificationSection({Key? key}) : super(key: key);

//   @override
//   State<NotificationSection> createState() => _NotificationSectionState();
// }

// class _NotificationSectionState extends State<NotificationSection> {
//   bool isMotivationOn = false;
//   TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);

//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     _initNotifications();
//   }

//   Future<void> _initNotifications() async {
//     tz.initializeTimeZones();

//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const initSettings = InitializationSettings(android: androidSettings);

//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//   }

//   Future<void> _scheduleDailyNotification() async {
//     final now = DateTime.now();
//     final scheduledDate = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       selectedTime.hour,
//       selectedTime.minute,
//     );

//     final tzDate = tz.TZDateTime.from(
//         scheduledDate.isBefore(now) ? scheduledDate.add(const Duration(days: 1)) : scheduledDate,
//         tz.local);

//     const androidDetails = AndroidNotificationDetails(
//       'motivation_channel',
//       '동기부여 알림',
//       channelDescription: '매일 동기부여 알림 채널',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const notificationDetails = NotificationDetails(android: androidDetails);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       '매일 동기부여 알림',
//       '오늘도 금연에 도움을 줄 수 있는 말을 해드릴게요!',
//       tzDate,
//       notificationDetails,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
//           child: Text(
//             "동기부여 알림",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SwitchListTile(
//           title: const Text("금연 효과 달성 알림"),
//           value: isMotivationOn,
//           onChanged: (val) async {
//             setState(() => isMotivationOn = val);
//             if (val) {
//               await _scheduleDailyNotification();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("알림이 설정되었습니다.")),
//               );
//             } else {
//               await flutterLocalNotificationsPlugin.cancel(0);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("알림이 취소되었습니다.")),
//               );
//             }
//           },
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 16.0),
//           child: Row(
//             children: [
//               Text("시간: ${selectedTime.format(context)}"),
//               const SizedBox(width: 12),
//               ElevatedButton(
//                 onPressed: () async {
//                   final picked = await showTimePicker(
//                     context: context,
//                     initialTime: selectedTime,
//                   );
//                   if (picked != null) {
//                     setState(() => selectedTime = picked);
//                     if (isMotivationOn) {
//                       await _scheduleDailyNotification();
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content: Text(
//                                 "${selectedTime.format(context)}로 알림이 업데이트 되었습니다.")),
//                       );
//                     }
//                   }
//                 },
//                 child: const Text("시간 선택"),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

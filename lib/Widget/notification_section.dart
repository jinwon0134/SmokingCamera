// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationSection extends StatefulWidget {
//   const NotificationSection({Key? key}) : super(key: key);

//   @override
//   State<NotificationSection> createState() => _NotificationSectionState();
// }

// class _NotificationSectionState extends State<NotificationSection> {
//   bool isSmokeEffectOn = true;
//   bool isMotivationOn = false;
//   TimeOfDay _motivationTime = const TimeOfDay(hour: 9, minute: 0);

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     _initNotifications();
//   }

//   Future<void> _initNotifications() async {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initSettings =
//         InitializationSettings(android: androidSettings);

//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//   }

//   Future<void> _scheduleDailyAlarm(TimeOfDay time) async {
//     final now = DateTime.now();
//     DateTime firstSchedule =
//         DateTime(now.year, now.month, now.day, time.hour, time.minute);

//     if (firstSchedule.isBefore(now)) {
//       firstSchedule = firstSchedule.add(const Duration(days: 1));
//     }

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'motivation_channel',
//       'Motivation Alarm',
//       channelDescription: 'Daily motivation for quitting smoking',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//     );

//     const NotificationDetails platformDetails =
//         NotificationDetails(android: androidDetails);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       '동기부여 알림',
//       '오늘도 금연 화이팅! 🚭',
//       firstSchedule.toLocal(),
//       platformDetails,
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
//           padding: EdgeInsets.only(left: 16.0),
//           child: Text(
//             "알림",
//             style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SwitchListTile(
//           title: const Text("금연 효과 달성 알림"),
//           value: isSmokeEffectOn,
//           onChanged: (val) {
//             setState(() {
//               isSmokeEffectOn = val;
//             });
//           },
//         ),
//         SwitchListTile(
//           title: const Text("동기부여 알림"),
//           subtitle: const Text("매일 금연에 도움을 줄 수 있는 말을 해드릴게요!"),
//           value: isMotivationOn,
//           onChanged: (val) {
//             setState(() {
//               isMotivationOn = val;
//               if (isMotivationOn) _scheduleDailyAlarm(_motivationTime);
//             });
//           },
//         ),
//         if (isMotivationOn)
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0, top: 8),
//             child: Row(
//               children: [
//                 Text(
//                   "알람 시간: ${_motivationTime.format(context)}",
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final TimeOfDay? picked = await showTimePicker(
//                       context: context,
//                       initialTime: _motivationTime,
//                     );
//                     if (picked != null && picked != _motivationTime) {
//                       setState(() {
//                         _motivationTime = picked;
//                         if (isMotivationOn) _scheduleDailyAlarm(_motivationTime);
//                       });
//                     }
//                   },
//                   child: const Text("시간 설정"),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:notification/screens/local_notification_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LocalNotificationServices service;

  @override
  void initState() {
    service = LocalNotificationServices();
    service.initilize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification Demo'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await service.showNotification(
                  id: 39,
                  title: 'Notification Title',
                  body: 'Some body',
                );
              },
              child: const Text('Show local notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.showScheduledNotification(
                  id: 0,
                  title: 'Scedule Notification',
                  body: 'Notification body',
                  seconds: 2,
                );
              },
              child: const Text('Show Schedule notification'),
            )
          ],
        ),
      ),
    );
  }
}

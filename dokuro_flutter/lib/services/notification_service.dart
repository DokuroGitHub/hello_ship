import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class NotificationService extends GetxService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  final _selectNotificationSubject = BehaviorSubject<String?>();
  //final _platform = const MethodChannel('flutter_local_notifications_desu');

  Future<NotificationService> initPlz() async {
    debugPrint('$runtimeType delays 2 sec');
    //await 2.delay();
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        !kIsWeb && (Platform.isLinux || Platform.isWindows)
            ? null
            : await flutterLocalNotificationsPlugin
                .getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      //Get.to(() => SecondPage(notificationAppLaunchDetails?.payload));
      debugPrint(
          'notificationAppLaunchDetails?.didNotificationLaunchApp: ${notificationAppLaunchDetails?.didNotificationLaunchApp}');
    }

    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              _didReceiveLocalNotificationSubject.add(
                ReceivedNotification(
                  id: id,
                  title: title,
                  body: body,
                  payload: payload,
                ),
              );
            });
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
      linux: initializationSettingsLinux,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      _selectNotificationSubject.add(payload);
    });

    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    debugPrint('$runtimeType ready!');
    return this;
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    _didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      Get.dialog(
        CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Get.back();
                Get.to(() => SecondPage(receivedNotification.payload));
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    _selectNotificationSubject.stream.listen((String? payload) async {
      debugPrint('_configureSelectNotificationSubject: $payload');
      Get.to(() => SecondPage(payload));
    });
  }

  Future<void> show(
    int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails, {
    String? payload,
  }) {
    return flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}

class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      );
}

class TestScreen extends StatefulWidget {
  const TestScreen({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final notificationService = Get.find<NotificationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text('Tap on a notification when it appears to trigger'
                      ' navigation'),
                ),
                PaddedElevatedButton(
                  buttonText: 'Show notification test',
                  onPressed: () async {
                    await _showNotificationTest();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Show plain notification with payload',
                  onPressed: () async {
                    await _showNotification();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Show plain notification that has no title with '
                      'payload',
                  onPressed: () async {
                    await _showNotificationWithNoTitle();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Show plain notification that has no body with '
                      'payload',
                  onPressed: () async {
                    await _showNotificationWithNoBody();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Show notification with custom sound',
                  onPressed: () async {
                    await _showNotificationCustomSound();
                  },
                ),
                if (kIsWeb || !Platform.isLinux) ...<Widget>[
                  PaddedElevatedButton(
                    buttonText: 'Schedule notification to appear in 5 seconds '
                        'based on local time zone',
                    onPressed: () async {
                      await _zonedScheduleNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Repeat notification every minute',
                    onPressed: () async {
                      await _repeatNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Schedule daily 10:00:00 am notification in your '
                        'local time zone',
                    onPressed: () async {
                      await _scheduleDailyTenAMNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Schedule daily 10:00:00 am notification in your '
                        "local time zone using last year's date",
                    onPressed: () async {
                      await _scheduleDailyTenAMLastYearNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Schedule weekly 10:00:00 am notification in your '
                        'local time zone',
                    onPressed: () async {
                      await _scheduleWeeklyTenAMNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Schedule weekly Monday 10:00:00 am notification '
                        'in your local time zone',
                    onPressed: () async {
                      await _scheduleWeeklyMondayTenAMNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Check pending notifications',
                    onPressed: () async {
                      await _checkPendingNotificationRequests();
                    },
                  ),
                ],
                PaddedElevatedButton(
                  buttonText:
                      'Schedule monthly Monday 10:00:00 am notification in '
                      'your local time zone',
                  onPressed: () async {
                    await _scheduleMonthlyMondayTenAMNotification();
                  },
                ),
                PaddedElevatedButton(
                  buttonText:
                      'Schedule yearly Monday 10:00:00 am notification in '
                      'your local time zone',
                  onPressed: () async {
                    await _scheduleYearlyMondayTenAMNotification();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Show notification with no sound',
                  onPressed: () async {
                    await _showNotificationWithNoSound();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Cancel notification',
                  onPressed: () async {
                    await _cancelNotification();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Cancel all notifications',
                  onPressed: () async {
                    await _cancelAllNotifications();
                  },
                ),
                if (!kIsWeb && Platform.isAndroid) ...[
                  const Text(
                    'Android-specific examples',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Check if notifications are enabled for this app',
                    onPressed: _areNotifcationsEnabledOnAndroid,
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Show plain notification with payload and update '
                        'channel description',
                    onPressed: () async {
                      await _showNotificationUpdateChannelDescription();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show plain notification as public on every '
                        'lockscreen',
                    onPressed: () async {
                      await _showPublicNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Show notification with custom vibration pattern, '
                        'red LED and red icon',
                    onPressed: () async {
                      await _showNotificationCustomVibrationIconLed();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Show notification that times out after 3 seconds',
                    onPressed: () async {
                      await _showTimeoutNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show insistent notification',
                    onPressed: () async {
                      await _showInsistentNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Show big picture notification using local images',
                    onPressed: () async {
                      await _showBigPictureNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Show big picture notification using base64 String '
                        'for images',
                    onPressed: () async {
                      await _showBigPictureNotificationBase64();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show big picture notification using URLs for '
                        'Images',
                    onPressed: () async {
                      await _showBigPictureNotificationURL();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Show big picture notification, hide large icon '
                        'on expand',
                    onPressed: () async {
                      await _showBigPictureNotificationHiddenLargeIcon();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show media notification',
                    onPressed: () async {
                      await _showNotificationMediaStyle();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show big text notification',
                    onPressed: () async {
                      await _showBigTextNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show inbox notification',
                    onPressed: () async {
                      await _showInboxNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show messaging notification',
                    onPressed: () async {
                      await _showMessagingNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show grouped notifications',
                    onPressed: () async {
                      await _showGroupedNotifications();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with tag',
                    onPressed: () async {
                      await _showNotificationWithTag();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Cancel notification with tag',
                    onPressed: () async {
                      await _cancelNotificationWithTag();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show ongoing notification',
                    onPressed: () async {
                      await _showOngoingNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Show notification with no badge, alert only once',
                    onPressed: () async {
                      await _showNotificationWithNoBadge();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Show progress notification - updates every second',
                    onPressed: () async {
                      await _showProgressNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show indeterminate progress notification',
                    onPressed: () async {
                      await _showIndeterminateProgressNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification without timestamp',
                    onPressed: () async {
                      await _showNotificationWithoutTimestamp();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with custom timestamp',
                    onPressed: () async {
                      await _showNotificationWithCustomTimestamp();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with custom sub-text',
                    onPressed: () async {
                      await _showNotificationWithCustomSubText();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with chronometer',
                    onPressed: () async {
                      await _showNotificationWithChronometer();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show full-screen notification',
                    onPressed: () async {
                      await _showFullScreenNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Create grouped notification channels',
                    onPressed: () async {
                      await _createNotificationChannelGroup();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Delete notification channel group',
                    onPressed: () async {
                      await _deleteNotificationChannelGroup();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Create notification channel',
                    onPressed: () async {
                      await _createNotificationChannel();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Delete notification channel',
                    onPressed: () async {
                      await _deleteNotificationChannel();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Get notification channels',
                    onPressed: () async {
                      await _getNotificationChannels();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Get active notifications',
                    onPressed: () async {
                      await _getActiveNotifications();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Start foreground service',
                    onPressed: () async {
                      await _startForegroundService();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                        'Start foreground service with blue background notification',
                    onPressed: () async {
                      await _startForegroundServiceWithBlueBackgroundNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Stop foreground service',
                    onPressed: () async {
                      await _stopForegroundService();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showNotificationTest() async {
    await notificationService.flutterLocalNotificationsPlugin.show(
      0,
      'custom sound notification title',
      'custom sound notification body',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'hello_ship',
          'Thông báo từ HelloShip',
          channelDescription: 'Thông báo của HelloShip',
          sound: RawResourceAndroidNotificationSound('notification'),
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'item x',
    );
  }

  Future<void> _showNotification() async {
    await notificationService.flutterLocalNotificationsPlugin.show(
      0,
      'plain title',
      'plain body',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
      payload: 'item x',
    );
  }

  Future<void> _showFullScreenNotification() async {
    Get.dialog(AlertDialog(
      title: const Text('Turn off your screen'),
      content: const Text(
          'to see the full-screen intent in 5 seconds, press OK and TURN '
          'OFF your screen'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await notificationService.flutterLocalNotificationsPlugin
                .zonedSchedule(
                    0,
                    'scheduled title',
                    'scheduled body',
                    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
                    const NotificationDetails(
                        android:
                            AndroidNotificationDetails('full screen channel id',
                                'full screen channel name',
                                channelDescription:
                                    'full screen channel description',
                                priority: Priority.high,
                                importance: Importance.high,
                                fullScreenIntent: true)),
                    androidAllowWhileIdle: true,
                    uiLocalNotificationDateInterpretation:
                        UILocalNotificationDateInterpretation.absoluteTime);
            Get.back();
          },
          child: const Text('OK'),
        )
      ],
    ));
  }

  Future<void> _showNotificationWithNoBody() async {
    await notificationService.flutterLocalNotificationsPlugin.show(
      0,
      'plain title',
      null,
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'),
      ),
      payload: 'item x',
    );
  }

  Future<void> _showNotificationWithNoTitle() async {
    await notificationService.flutterLocalNotificationsPlugin.show(
      0,
      null,
      'plain body',
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'),
      ),
      payload: 'item x',
    );
  }

  Future<void> _cancelNotification() async {
    await notificationService.flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> _cancelNotificationWithTag() async {
    await notificationService.flutterLocalNotificationsPlugin
        .cancel(0, tag: 'tag');
  }

  Future<void> _showNotificationCustomSound() async {
    await notificationService.flutterLocalNotificationsPlugin.show(
      0,
      'custom sound notification title',
      'custom sound notification body',
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'your other channel id',
          'your other channel name',
          channelDescription: 'your other channel description',
          sound: RawResourceAndroidNotificationSound('notification'),
        ),
        iOS: const IOSNotificationDetails(sound: 'slow_spring_board.aiff'),
        macOS: const MacOSNotificationDetails(sound: 'slow_spring_board.aiff'),
        linux: LinuxNotificationDetails(
          sound: AssetsLinuxSound('sound/slow_spring_board.mp3'),
        ),
      ),
    );
  }

  Future<void> _showNotificationCustomVibrationIconLed() async {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    await notificationService.flutterLocalNotificationsPlugin.show(
      0,
      'title of notification with custom vibration pattern, LED and icon',
      'body of notification with custom vibration pattern, LED and icon',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'other custom channel id',
          'other custom channel name',
          channelDescription: 'other custom channel description',
          icon: 'secondary_icon',
          largeIcon: const DrawableResourceAndroidBitmap('sample_large_icon'),
          vibrationPattern: vibrationPattern,
          enableLights: true,
          color: const Color.fromARGB(255, 255, 0, 0),
          ledColor: const Color.fromARGB(255, 255, 0, 0),
          ledOnMs: 1000,
          ledOffMs: 500,
        ),
      ),
    );
  }

  Future<void> _zonedScheduleNotification() async {
    await notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> _showNotificationWithNoSound() async {
    await notificationService.flutterLocalNotificationsPlugin.show(
      0,
      '<b>silent</b> title',
      '<b>silent</b> body',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'silent channel id',
          'silent channel name',
          channelDescription: 'silent channel description',
          playSound: false,
          styleInformation: DefaultStyleInformation(true, true),
        ),
        iOS: IOSNotificationDetails(presentSound: false),
        macOS: MacOSNotificationDetails(presentSound: false),
      ),
    );
  }

  Future<void> _showTimeoutNotification() async {
    await notificationService.flutterLocalNotificationsPlugin.show(
      0,
      'timeout notification',
      'Times out after 3 seconds',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'silent channel id',
          'silent channel name',
          channelDescription: 'silent channel description',
          timeoutAfter: 3000,
          styleInformation: DefaultStyleInformation(true, true),
        ),
      ),
    );
  }

  Future<void> _showInsistentNotification() async {
    // This value is from: https://developer.android.com/reference/android/app/Notification.html#FLAG_INSISTENT
    const int insistentFlag = 4;
    await notificationService.flutterLocalNotificationsPlugin.show(
      0,
      'insistent title',
      'insistent body',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          additionalFlags: Int32List.fromList(<int>[insistentFlag]),
        ),
      ),
      payload: 'item x',
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> _showBigPictureNotification() async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/48x48', 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/400x800', 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            contentTitle: 'overridden <b>big</b> content title',
            htmlFormatContentTitle: true,
            summaryText: 'summary <i>text</i>',
            htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin
        .show(0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<String> _base64encodedImage(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final String base64Data = base64Encode(response.bodyBytes);
    return base64Data;
  }

  Future<void> _showBigPictureNotificationBase64() async {
    final String largeIcon =
        await _base64encodedImage('https://via.placeholder.com/48x48');
    final String bigPicture =
        await _base64encodedImage('https://via.placeholder.com/400x800');

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(
                bigPicture), //Base64AndroidBitmap(bigPicture),
            largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
            contentTitle: 'overridden <b>big</b> content title',
            htmlFormatContentTitle: true,
            summaryText: 'summary <i>text</i>',
            htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin
        .show(0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<void> _showBigPictureNotificationURL() async {
    final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl('https://via.placeholder.com/48x48'));
    final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl('https://via.placeholder.com/400x800'));

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(bigPicture,
            largeIcon: largeIcon,
            contentTitle: 'overridden <b>big</b> content title',
            htmlFormatContentTitle: true,
            summaryText: 'summary <i>text</i>',
            htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin
        .show(0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<void> _showBigPictureNotificationHiddenLargeIcon() async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/48x48', 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/400x800', 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
            hideExpandedLargeIcon: true,
            contentTitle: 'overridden <b>big</b> content title',
            htmlFormatContentTitle: true,
            summaryText: 'summary <i>text</i>',
            htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin
        .show(0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<void> _showNotificationMediaStyle() async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/128x128/00FF00/000000', 'largeIcon');
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      channelDescription: 'media channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: const MediaStyleInformation(),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
  }

  Future<void> _showBigTextNotification() async {
    const BigTextStyleInformation bigTextStyleInformation =
        BigTextStyleInformation(
      'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      htmlFormatBigText: true,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true,
    );
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            styleInformation: bigTextStyleInformation);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin
        .show(0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<void> _showInboxNotification() async {
    final List<String> lines = <String>['line <b>1</b>', 'line <i>2</i>'];
    final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('inbox channel id', 'inboxchannel name',
            channelDescription: 'inbox channel description',
            styleInformation: inboxStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin
        .show(0, 'inbox title', 'inbox body', platformChannelSpecifics);
  }

  Future<void> _showMessagingNotification() async {
    /// First two person objects will use icons that part of the Android app's
    /// drawable resources
    const Person me = Person(
      name: 'Me',
      key: '1',
      uri: 'tel:1234567890',
      icon: DrawableResourceAndroidIcon('me'),
    );
    const Person coworker = Person(
      name: 'Coworker',
      key: '2',
      uri: 'tel:9876543210',
      icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
    );
    // download the icon that would be use for the lunch bot person
    final String largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/48x48', 'largeIcon');
    // this person object will use an icon that was downloaded
    final Person lunchBot = Person(
      name: 'Lunch bot',
      key: 'bot',
      bot: true,
      icon: BitmapFilePathAndroidIcon(largeIconPath),
    );
    final Person chef = Person(
        name: 'Master Chef',
        key: '3',
        uri: 'tel:111222333444',
        icon: ByteArrayAndroidIcon.fromBase64String(
            await _base64encodedImage('https://placekitten.com/48/48')));

    final List<Message> messages = <Message>[
      Message('Hi', DateTime.now(), null),
      Message("What's up?", DateTime.now().add(const Duration(minutes: 5)),
          coworker),
      Message('Lunch?', DateTime.now().add(const Duration(minutes: 10)), null,
          dataMimeType: 'image/png'),
      Message('What kind of food would you prefer?',
          DateTime.now().add(const Duration(minutes: 10)), lunchBot),
      Message('You do not have time eat! Keep working!',
          DateTime.now().add(const Duration(minutes: 11)), chef),
    ];
    final MessagingStyleInformation messagingStyle = MessagingStyleInformation(
        me,
        groupConversation: true,
        conversationTitle: 'Team lunch',
        htmlFormatContent: true,
        htmlFormatTitle: true,
        messages: messages);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('message channel id', 'message channel name',
            channelDescription: 'message channel description',
            category: 'msg',
            styleInformation: messagingStyle);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin
        .show(0, 'message title', 'message body', platformChannelSpecifics);

    // wait 10 seconds and add another message to simulate another response
    await Future<void>.delayed(const Duration(seconds: 10), () async {
      messages.add(Message("I'm so sorry!!! But I really like thai food ...",
          DateTime.now().add(const Duration(minutes: 11)), null));
      await notificationService.flutterLocalNotificationsPlugin
          .show(0, 'message title', 'message body', platformChannelSpecifics);
    });
  }

  Future<void> _showGroupedNotifications() async {
    const String groupKey = 'com.android.example.WORK_EMAIL';
    const String groupChannelId = 'grouped channel id';
    const String groupChannelName = 'grouped channel name';
    const String groupChannelDescription = 'grouped channel description';
    // example based on https://developer.android.com/training/notify-user/group.html
    const AndroidNotificationDetails firstNotificationAndroidSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            channelDescription: groupChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);
    const NotificationDetails firstNotificationPlatformSpecifics =
        NotificationDetails(android: firstNotificationAndroidSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        1,
        'Alex Faarborg',
        'You will not believe...',
        firstNotificationPlatformSpecifics);
    const AndroidNotificationDetails secondNotificationAndroidSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            channelDescription: groupChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);
    const NotificationDetails secondNotificationPlatformSpecifics =
        NotificationDetails(android: secondNotificationAndroidSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        2,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    // Create the summary notification to support older devices that pre-date
    /// Android 7.0 (API level 24).
    ///
    /// Recommended to create this regardless as the behaviour may vary as
    /// mentioned in https://developer.android.com/training/notify-user/group
    const List<String> lines = <String>[
      'Alex Faarborg  Check this out',
      'Jeff Chang    Launch Party'
    ];
    const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        contentTitle: '2 messages',
        summaryText: 'janedoe@example.com');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            channelDescription: groupChannelDescription,
            styleInformation: inboxStyleInformation,
            groupKey: groupKey,
            setAsGroupSummary: true);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin
        .show(3, 'Attention', 'Two messages', platformChannelSpecifics);
  }

  Future<void> _showNotificationWithTag() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            tag: 'tag');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await notificationService.flutterLocalNotificationsPlugin
        .show(0, 'first notification', null, platformChannelSpecifics);
  }

  Future<void> _checkPendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await notificationService.flutterLocalNotificationsPlugin
            .pendingNotificationRequests();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content:
            Text('${pendingNotificationRequests.length} pending notification '
                'requests'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelAllNotifications() async {
    await notificationService.flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _showOngoingNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ongoing: true,
            autoCancel: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        0,
        'ongoing notification title',
        'ongoing notification body',
        platformChannelSpecifics);
  }

  Future<void> _repeatNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'repeating title',
        'repeating body',
        RepeatInterval.everyMinute,
        platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  Future<void> _scheduleDailyTenAMNotification() async {
    await notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'daily scheduled notification title',
        'daily scheduled notification body',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  /// To test we don't validate past dates when using `matchDateTimeComponents`
  Future<void> _scheduleDailyTenAMLastYearNotification() async {
    await notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'daily scheduled notification title',
        'daily scheduled notification body',
        _nextInstanceOfTenAMLastYear(),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> _scheduleWeeklyTenAMNotification() async {
    await notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'weekly scheduled notification title',
        'weekly scheduled notification body',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('weekly notification channel id',
              'weekly notification channel name',
              channelDescription: 'weekly notificationdescription'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> _scheduleWeeklyMondayTenAMNotification() async {
    await notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'weekly scheduled notification title',
        'weekly scheduled notification body',
        _nextInstanceOfMondayTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('weekly notification channel id',
              'weekly notification channel name',
              channelDescription: 'weekly notificationdescription'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> _scheduleMonthlyMondayTenAMNotification() async {
    await notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'monthly scheduled notification title',
        'monthly scheduled notification body',
        _nextInstanceOfMondayTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('monthly notification channel id',
              'monthly notification channel name',
              channelDescription: 'monthly notificationdescription'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
  }

  Future<void> _scheduleYearlyMondayTenAMNotification() async {
    await notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'yearly scheduled notification title',
        'yearly scheduled notification body',
        _nextInstanceOfMondayTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('yearly notification channel id',
              'yearly notification channel name',
              channelDescription: 'yearly notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfTenAMLastYear() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    return tz.TZDateTime(tz.local, now.year - 1, now.month, now.day, 10);
  }

  tz.TZDateTime _nextInstanceOfMondayTenAM() {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _showNotificationWithNoBadge() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('no badge channel', 'no badge name',
            channelDescription: 'no badge description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        0, 'no badge title', 'no badge body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showProgressNotification() async {
    const int maxProgress = 5;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('progress channel', 'progress channel',
                channelDescription: 'progress channel description',
                channelShowBadge: false,
                importance: Importance.max,
                priority: Priority.high,
                onlyAlertOnce: true,
                showProgress: true,
                maxProgress: maxProgress,
                progress: i);
        final NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await notificationService.flutterLocalNotificationsPlugin.show(
            0,
            'progress notification title',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  Future<void> _showIndeterminateProgressNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'indeterminate progress channel', 'indeterminate progress channel',
            channelDescription: 'indeterminate progress channel description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            indeterminate: true);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        0,
        'indeterminate progress notification title',
        'indeterminate progress notification body',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationUpdateChannelDescription() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your updated channel description',
            importance: Importance.max,
            priority: Priority.high,
            channelAction: AndroidNotificationChannelAction.update);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        0,
        'updated notification channel',
        'check settings to see updated channel description',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showPublicNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            visibility: NotificationVisibility.public);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        0,
        'public notification title',
        'public notification body',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithoutTimestamp() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithCustomTimestamp() async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithCustomSubText() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      subText: 'custom subtext',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithChronometer() async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
      usesChronometer: true,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationService.flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _createNotificationChannelGroup() async {
    const String channelGroupId = 'your channel group id';
    // create the group first
    const AndroidNotificationChannelGroup androidNotificationChannelGroup =
        AndroidNotificationChannelGroup(
            channelGroupId, 'your channel group name',
            description: 'your channel group description');
    await notificationService.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannelGroup(androidNotificationChannelGroup);

    // create channels associated with the group
    await notificationService.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(const AndroidNotificationChannel(
            'grouped channel id 1', 'grouped channel name 1',
            description: 'grouped channel description 1',
            groupId: channelGroupId));

    await notificationService.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(const AndroidNotificationChannel(
            'grouped channel id 2', 'grouped channel name 2',
            description: 'grouped channel description 2',
            groupId: channelGroupId));

    await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Text('Channel group with name '
                  '${androidNotificationChannelGroup.name} created'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  Future<void> _deleteNotificationChannelGroup() async {
    const String channelGroupId = 'your channel group id';
    await notificationService.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup(channelGroupId);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Channel group with id $channelGroupId deleted'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _startForegroundService() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    await notificationService.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(1, 'plain title', 'plain body',
            notificationDetails: androidPlatformChannelSpecifics,
            payload: 'item x');
  }

  Future<void> _startForegroundServiceWithBlueBackgroundNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'color background channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: Colors.blue,
      colorized: true,
    );

    /// only using foreground service can color the background
    await notificationService.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(
            1, 'colored background text title', 'colored background text body',
            notificationDetails: androidPlatformChannelSpecifics,
            payload: 'item x');
  }

  Future<void> _stopForegroundService() async {
    await notificationService.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.stopForegroundService();
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      'your channel id 2',
      'your channel name 2',
      description: 'your channel description 2',
    );
    await notificationService.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content:
                  Text('Channel with name ${androidNotificationChannel.name} '
                      'created'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  Future<void> _areNotifcationsEnabledOnAndroid() async {
    final bool? areEnabled = await notificationService
        .flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Text(areEnabled == null
                  ? 'ERROR: received null'
                  : (areEnabled
                      ? 'Notifications are enabled'
                      : 'Notifications are NOT enabled')),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  Future<void> _deleteNotificationChannel() async {
    const String channelId = 'your channel id 2';
    await notificationService.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Channel with id $channelId deleted'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _getActiveNotifications() async {
    final Widget activeNotificationsDialogContent =
        await _getActiveNotificationsDialogContent();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: activeNotificationsDialogContent,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<Widget> _getActiveNotificationsDialogContent() async {
    try {
      final List<ActiveNotification>? activeNotifications =
          await notificationService.flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()!
              .getActiveNotifications();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Active Notifications',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.black),
          if (activeNotifications!.isEmpty)
            const Text('No active notifications'),
          if (activeNotifications.isNotEmpty)
            for (ActiveNotification activeNotification in activeNotifications)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'id: ${activeNotification.id}\n'
                    'channelId: ${activeNotification.channelId}\n'
                    'tag: ${activeNotification.tag}\n'
                    'title: ${activeNotification.title}\n'
                    'body: ${activeNotification.body}',
                  ),
                  const Divider(color: Colors.black),
                ],
              ),
        ],
      );
    } on PlatformException catch (error) {
      return Text(
        'Error calling "getActiveNotifications"\n'
        'code: ${error.code}\n'
        'message: ${error.message}',
      );
    }
  }

  Future<void> _getNotificationChannels() async {
    final Widget notificationChannelsDialogContent =
        await _getNotificationChannelsDialogContent();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: notificationChannelsDialogContent,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<Widget> _getNotificationChannelsDialogContent() async {
    try {
      final List<AndroidNotificationChannel>? channels =
          await notificationService.flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()!
              .getNotificationChannels();

      return SizedBox(
        width: double.maxFinite,
        child: ListView(
          children: <Widget>[
            const Text(
              'Notifications Channels',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.black),
            if (channels?.isEmpty ?? true)
              const Text('No notification channels')
            else
              for (AndroidNotificationChannel channel in channels!)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('id: ${channel.id}\n'
                        'name: ${channel.name}\n'
                        'description: ${channel.description}\n'
                        'groupId: ${channel.groupId}\n'
                        'importance: ${channel.importance.value}\n'
                        'playSound: ${channel.playSound}\n'
                        'sound: ${channel.sound?.sound}\n'
                        'enableVibration: ${channel.enableVibration}\n'
                        'vibrationPattern: ${channel.vibrationPattern}\n'
                        'showBadge: ${channel.showBadge}\n'
                        'enableLights: ${channel.enableLights}\n'
                        'ledColor: ${channel.ledColor}\n'),
                    const Divider(color: Colors.black),
                  ],
                ),
          ],
        ),
      );
    } on PlatformException catch (error) {
      return Text(
        'Error calling "getNotificationChannels"\n'
        'code: ${error.code}\n'
        'message: ${error.message}',
      );
    }
  }
}

// second page
class SecondPage extends StatelessWidget {
  final String? payload;
  const SecondPage(
    this.payload, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen with payload: ${payload ?? ''}'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

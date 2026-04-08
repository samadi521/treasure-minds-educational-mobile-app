import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _plugin.initialize(settings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'treasure_minds_channel',
      'Treasure Minds Notifications',
      channelDescription: 'Notifications for game updates and reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _plugin.show(id, title, body, details, payload: payload);
  }

  static Future<void> showDailyReminder() async {
    await showNotification(
      id: 1,
      title: 'Time to Play! 🎮',
      body: 'Don\'t forget to complete your daily challenges!',
    );
  }

  static Future<void> showStreakWarning(int streak) async {
    await showNotification(
      id: 2,
      title: 'Keep Your Streak! 🔥',
      body: 'Play today to maintain your $streak-day streak!',
    );
  }

  static Future<void> showAchievementUnlocked(String achievementName) async {
    await showNotification(
      id: 3,
      title: 'Achievement Unlocked! 🏆',
      body: 'You earned the "$achievementName" badge!',
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/settings_provider.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
 State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Notification settings
  bool _pushNotifications = true;
  bool _dailyReminders = true;
  bool _weeklyReports = true;
  bool _achievementAlerts = true;
  bool _friendRequests = true;
  bool _challengeReminders = true;
  bool _streakWarnings = true;
  bool _specialOffers = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  
  String _reminderTime = '09:00 AM';
  String _weeklyReportDay = 'Monday';
  
  final List<String> _timeSlots = ['09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM', '06:00 PM', '07:00 PM', '08:00 PM'];
  final List<String> _weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.neonBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMasterSwitchCard(),
                const SizedBox(height: 16),
                _buildPushNotificationSection(),
                const SizedBox(height: 16),
                _buildReminderSettingsCard(),
                const SizedBox(height: 16),
                _buildSoundVibrationCard(),
                const SizedBox(height: 16),
                _buildScheduleCard(),
                const SizedBox(height: 16),
                _buildQuietHoursCard(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMasterSwitchCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.neonGreen.withValues(alpha: 0.1), AppColors.mintGreen.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neonGreen.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _pushNotifications ? Icons.notifications_active : Icons.notifications_off,
              color: AppColors.neonGreen,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Push Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _pushNotifications 
                      ? 'You will receive notifications' 
                      : 'All notifications are disabled',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
                if (!value) {
                  _dailyReminders = false;
                  _weeklyReports = false;
                  _achievementAlerts = false;
                  _friendRequests = false;
                  _challengeReminders = false;
                  _streakWarnings = false;
                  _specialOffers = false;
                }
              });
            },
            activeThumbColor: AppColors.neonGreen,
            activeTrackColor: AppColors.neonGreen.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildPushNotificationSection() {
    if (!_pushNotifications) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.notifications_off, size: 50, color: Colors.grey),
              const SizedBox(height: 12),
              const Text(
                'Notifications are disabled',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Enable push notifications to receive updates',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.category, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Notification Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildNotificationTile(
            title: 'Daily Reminders',
            subtitle: 'Get reminded to play daily',
            value: _dailyReminders,
            onChanged: (value) {
              setState(() {
                _dailyReminders = value;
              });
            },
            icon: Icons.notifications_active,
            color: AppColors.warningOrange,
          ),
          _buildNotificationTile(
            title: 'Weekly Reports',
            subtitle: 'Receive your weekly progress summary',
            value: _weeklyReports,
            onChanged: (value) {
              setState(() {
                _weeklyReports = value;
              });
            },
            icon: Icons.bar_chart,
            color: AppColors.neonBlue,
          ),
          _buildNotificationTile(
            title: 'Achievement Alerts',
            subtitle: 'Get notified when you earn badges',
            value: _achievementAlerts,
            onChanged: (value) {
              setState(() {
                _achievementAlerts = value;
              });
            },
            icon: Icons.emoji_events,
            color: AppColors.gold,
          ),
          _buildNotificationTile(
            title: 'Friend Requests',
            subtitle: 'Notifications for friend requests',
            value: _friendRequests,
            onChanged: (value) {
              setState(() {
                _friendRequests = value;
              });
            },
            icon: Icons.people,
            color: AppColors.mintGreen,
          ),
          _buildNotificationTile(
            title: 'Challenge Reminders',
            subtitle: 'Reminders for ongoing challenges',
            value: _challengeReminders,
            onChanged: (value) {
              setState(() {
                _challengeReminders = value;
              });
            },
            icon: Icons.sports_esports,
            color: AppColors.mathOrange,
          ),
          _buildNotificationTile(
            title: 'Streak Warnings',
            subtitle: 'Alert before losing your streak',
            value: _streakWarnings,
            onChanged: (value) {
              setState(() {
                _streakWarnings = value;
              });
            },
            icon: Icons.local_fire_department,
            color: AppColors.errorRed,
          ),
          _buildNotificationTile(
            title: 'Special Offers',
            subtitle: 'Exclusive deals and promotions',
            value: _specialOffers,
            onChanged: (value) {
              setState(() {
                _specialOffers = value;
              });
            },
            icon: Icons.local_offer,
            color: AppColors.neonPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: color,
            activeTrackColor: color.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.alarm, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Reminder Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdownSetting(
            label: 'Daily Reminder Time',
            value: _reminderTime,
            items: _timeSlots,
            icon: Icons.access_time,
            onChanged: (value) {
              setState(() {
                _reminderTime = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownSetting(
            label: 'Weekly Report Day',
            value: _weeklyReportDay,
            items: _weekDays,
            icon: Icons.calendar_today,
            onChanged: (value) {
              setState(() {
                _weeklyReportDay = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.neonBlue),
          border: InputBorder.none,
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSoundVibrationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.volume_up, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Sound & Vibration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Notification Sound'),
            subtitle: const Text('Play sound for notifications'),
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
            },
            activeThumbColor: AppColors.neonBlue,
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            subtitle: const Text('Vibrate on notifications'),
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
            activeThumbColor: AppColors.neonBlue,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold.withValues(alpha: 0.1), AppColors.warningOrange.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.schedule, color: AppColors.gold),
              SizedBox(width: 8),
              Text(
                'Notification Schedule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildScheduleItem('Daily Reminder', _dailyReminders ? _reminderTime : 'Disabled'),
          const SizedBox(height: 8),
          _buildScheduleItem('Weekly Report', _weeklyReports ? _weeklyReportDay : 'Disabled'),
          const SizedBox(height: 8),
          _buildScheduleItem('Streak Warning', _streakWarnings ? '24 hours before streak ends' : 'Disabled'),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String title, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuietHoursCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.nightlight, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Quiet Hours',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Enable Quiet Hours'),
            subtitle: const Text('Silence notifications during specific hours'),
            value: false,
            onChanged: (value) {},
            activeThumbColor: AppColors.neonBlue,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.bedtime, size: 16, color: AppColors.neonBlue),
                      SizedBox(width: 8),
                      Text('Start: 10:00 PM'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wb_sunny, size: 16, color: AppColors.warningOrange),
                      SizedBox(width: 8),
                      Text('End: 07:00 AM'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

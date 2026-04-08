import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../config/app_constants.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final List<TeamMember> _teamMembers = [
    TeamMember(
      name: 'Kehelwala Samarawera',
      role: 'Project Lead & Full Stack Developer',
      avatar: 'K',
      color: AppColors.mathOrange,
      bio: 'Leading the project architecture and integration',
    ),
    TeamMember(
      name: 'Nikalanda Devake',
      role: 'UI/UX Designer',
      avatar: 'N',
      color: AppColors.englishGreen,
      bio: 'Creating beautiful and intuitive interfaces',
    ),
    TeamMember(
      name: 'Watuthanthrige Alwis',
      role: 'Backend Developer',
      avatar: 'W',
      color: AppColors.sciencePurple,
      bio: 'Firebase integration and database management',
    ),
    TeamMember(
      name: 'Kananke Hapuarachchi',
      role: 'Frontend Developer',
      avatar: 'K',
      color: AppColors.neonBlue,
      bio: 'Building responsive UI components',
    ),
    TeamMember(
      name: 'Wasala Gunathilaka',
      role: 'Content Developer',
      avatar: 'W',
      color: AppColors.mintGreen,
      bio: 'Creating educational content and questions',
    ),
    TeamMember(
      name: 'Wickrama Wickramaarachchi',
      role: 'QA Engineer',
      avatar: 'W',
      color: AppColors.warningOrange,
      bio: 'Ensuring quality and testing',
    ),
  ];

  final List<Map<String, dynamic>> _technologies = [
    {'name': 'Flutter', 'icon': Icons.mobile_friendly, 'color': AppColors.neonBlue},
    {'name': 'Dart', 'icon': Icons.code, 'color': AppColors.neonCyan},
    {'name': 'Firebase', 'icon': Icons.cloud, 'color': AppColors.warningOrange},
    {'name': 'Provider', 'icon': Icons.source, 'color': AppColors.mintGreen},
    {'name': 'SharedPreferences', 'icon': Icons.storage, 'color': AppColors.neonPurple},
    {'name': 'Flutter Animate', 'icon': Icons.animation, 'color': AppColors.mathOrange},
  ];

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
        title: const Text('About'),
        backgroundColor: AppColors.neonPurple,
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
            child: Column(
              children: [
                _buildAppHeader(),
                const SizedBox(height: 20),
                _buildStatsCard(),
                const SizedBox(height: 20),
                _buildTeamSection(),
                const SizedBox(height: 20),
                _buildTechnologiesSection(),
                const SizedBox(height: 20),
                _buildVersionCard(),
                const SizedBox(height: 20),
                _buildSocialLinksCard(),
                const SizedBox(height: 20),
                _buildAcknowledgmentsCard(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.rainbowGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            AppConstants.appName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version ${AppConstants.appVersion}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'An educational gaming app for children aged 6-16',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('1000+', 'Questions', Icons.quiz, AppColors.mathOrange),
          _buildStatItem('3', 'Subjects', Icons.school, AppColors.englishGreen),
          _buildStatItem('8', 'Levels', Icons.map, AppColors.adventureTeal),
          _buildStatItem('25+', 'Badges', Icons.emoji_events, AppColors.gold),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTeamSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
              Icon(Icons.people, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Development Team',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._teamMembers.map((member) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildTeamMemberCard(member),
          )),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(TeamMember member) {
    return Row(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [member.color, member.color.withValues(alpha: 0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              member.avatar,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                member.role,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                member.bio,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechnologiesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.neonBlue.withValues(alpha: 0.05), AppColors.neonPurple.withValues(alpha: 0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.code, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Technologies Used',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _technologies.map((tech) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: (tech['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: (tech['color'] as Color).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tech['icon'], size: 16, color: tech['color']),
                    const SizedBox(width: 6),
                    Text(
                      tech['name'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: tech['color'],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
              Icon(Icons.info, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Version Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildVersionInfo('Version', AppConstants.appVersion),
          _buildVersionInfo('Build Number', '1'),
          _buildVersionInfo('SDK Version', 'Flutter 3.10.8'),
          _buildVersionInfo('Release Date', 'March 2026'),
          _buildVersionInfo('Compatibility', 'iOS 12+ / Android 5.0+'),
        ],
      ),
    );
  }

  Widget _buildVersionInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinksCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
              Icon(Icons.share, color: AppColors.gold),
              SizedBox(width: 8),
              Text(
                'Connect With Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(Icons.public, 'Website', () => _launchURL('https://treasureminds.com')),
              _buildSocialButton(Icons.facebook, 'Facebook', () => _launchURL('https://facebook.com/treasureminds')),
              _buildSocialButton(Icons.mail, 'Email', () => _launchURL('mailto:info@treasureminds.com')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.gold, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAcknowledgmentsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
              Icon(Icons.favorite, color: AppColors.errorRed),
              SizedBox(width: 8),
              Text(
                'Acknowledgments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• Plymouth University - Module PUSL2023\n'
            '• Mr. Diluka Wijesinghe - Course Supervisor\n'
            '• Open source community for Flutter packages\n'
            '• All beta testers and contributors',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }
}

class TeamMember {
  final String name;
  final String role;
  final String avatar;
  final Color color;
  final String bio;

  TeamMember({
    required this.name,
    required this.role,
    required this.avatar,
    required this.color,
    required this.bio,
  });
}

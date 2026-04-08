import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/avatar_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';

class AvatarCustomizationScreen extends StatefulWidget {
  const AvatarCustomizationScreen({super.key});

  @override
  State<AvatarCustomizationScreen> createState() => _AvatarCustomizationScreenState();
}

class _AvatarCustomizationScreenState extends State<AvatarCustomizationScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  int _selectedIndex = 0;
  String _selectedAvatarName = '';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    final avatar = Provider.of<AvatarProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _selectedIndex = avatar.selectedAvatarIndex;
    _selectedAvatarName = avatar.avatarName;
    _nameController = TextEditingController(text: auth.userName ?? avatar.avatarName);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = Provider.of<AvatarProvider>(context);
    final avatars = avatar.availableAvatars;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Customize Avatar'),
        backgroundColor: AppColors.neonBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveAvatar,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildAvatarPreview(avatars),
                const SizedBox(height: 30),
                _buildNameInput(),
                const SizedBox(height: 30),
                _buildAvatarGrid(avatars),
                const SizedBox(height: 30),
                _buildCustomizationTips(),
                const SizedBox(height: 30),
                _buildSaveButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPreview(List<Map<String, dynamic>> avatars) {
    final selectedAvatar = avatars[_selectedIndex];
    final Color avatarColor = Color(selectedAvatar['color']);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: avatarColor.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [avatarColor, avatarColor.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: avatarColor.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: _getAvatarIcon(selectedAvatar['icon'] as String, 80),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Your Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Enter your name',
              prefixIcon: const Icon(Icons.edit, color: AppColors.neonBlue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This name will be displayed on your profile and leaderboard',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarGrid(List<Map<String, dynamic>> avatars) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Choose Your Character',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemCount: avatars.length,
            itemBuilder: (ctx, index) {
              final isSelected = _selectedIndex == index;
              final avatar = avatars[index];
              final Color avatarColor = Color(avatar['color']);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                    _selectedAvatarName = avatar['name'];
                  });
                  _animationController.reset();
                  _animationController.forward();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [avatarColor, avatarColor.withValues(alpha: 0.7)]
                          : [Colors.grey.shade100, Colors.grey.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? Border.all(color: AppColors.gold, width: 3)
                        : Border.all(color: Colors.grey.shade200, width: 1),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: avatarColor.withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _getAvatarIcon(avatar['icon'] as String, 45),
                      const SizedBox(height: 8),
                      Text(
                        avatar['name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? avatarColor : Colors.grey.shade700,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'SELECTED',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizationTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold.withValues(alpha: 0.15), AppColors.warningOrange.withValues(alpha: 0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb, color: AppColors.gold, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '💡 Did You Know?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.neonPurple,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'You can change your avatar anytime! Your progress and achievements are tied to your account, not your avatar.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _saveAvatar,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getAvatarIcon(String iconName, double size) {
    IconData icon;
    switch (iconName) {
      case 'emoji_emotions':
        icon = Icons.emoji_emotions;
        break;
      case 'auto_awesome':
        icon = Icons.auto_awesome;
        break;
      case 'shield':
        icon = Icons.shield;
        break;
      case 'sailing':
        icon = Icons.sailing;
        break;
      case 'workspace_premium':
        icon = Icons.workspace_premium;
        break;
      case 'android':
        icon = Icons.android;
        break;
      case 'whatshot':
        icon = Icons.whatshot;
        break;
      default:
        icon = Icons.person;
    }
    return Icon(icon, size: size, color: Colors.white);
  }

  void _saveAvatar() async {
    final avatarProvider = Provider.of<AvatarProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    String newName = _nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }
    
    if (newName.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name must be at least 2 characters'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }
    
    await avatarProvider.setAvatar(_selectedIndex, newName);
    authProvider.updateProfile(newName, authProvider.userAge);
    
    // Show success animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('✓ Avatar saved successfully!'),
          ],
        ),
        backgroundColor: AppColors.mintGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    
    Navigator.pop(context);
  }
}

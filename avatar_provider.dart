import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treasure_minds/config/theme.dart';
import '../config/app_constants.dart';

class AvatarProvider extends ChangeNotifier {
  int _selectedAvatarIndex = 0;
  String _avatarName = 'Explorer';
  int _avatarColor = 0xFF04696B;
  String _avatarEmoji = '👨‍🎓';
  List<int> _unlockedAvatars = [0]; // Index 0 is always unlocked
  bool _isLoading = false;
  
  // Avatar options with complete data
  final List<Map<String, dynamic>> _availableAvatars = [
    {
      'name': 'Captain Alex',
      'color': 0xFFFF6B6B,
      'icon': 'emoji_emotions',
      'emoji': '👨‍✈️',
      'description': 'Brave sea captain',
      'unlockLevel': 1,
      'unlockPoints': 0,
      'rarity': 'Common',
    },
    {
      'name': 'Wizard Emma',
      'color': 0xFF9B5DE5,
      'icon': 'auto_awesome',
      'emoji': '🧙‍♀️',
      'description': 'Master of magic',
      'unlockLevel': 2,
      'unlockPoints': 500,
      'rarity': 'Rare',
    },
    {
      'name': 'Knight Leo',
      'color': 0xFF4ECDC4,
      'icon': 'shield',
      'emoji': '⚔️',
      'description': 'Valiant warrior',
      'unlockLevel': 3,
      'unlockPoints': 1000,
      'rarity': 'Rare',
    },
    {
      'name': 'Pirate Jack',
      'color': 0xFFFF9F1C,
      'icon': 'sailing',
      'emoji': '🏴‍☠️',
      'description': 'Treasure hunter',
      'unlockLevel': 4,
      'unlockPoints': 1500,
      'rarity': 'Epic',
    },
    {
      'name': 'Princess Mia',
      'color': 0xFFFF85A1,
      'icon': 'workspace_premium',
      'emoji': '👸',
      'description': 'Royal elegance',
      'unlockLevel': 5,
      'unlockPoints': 2000,
      'rarity': 'Epic',
    },
    {
      'name': 'Robot Bot',
      'color': 0xFF6BCB77,
      'icon': 'android',
      'emoji': '🤖',
      'description': 'Future technology',
      'unlockLevel': 3,
      'unlockPoints': 800,
      'rarity': 'Rare',
    },
    {
      'name': 'Dragon Blaze',
      'color': 0xFFFF9800,
      'icon': 'whatshot',
      'emoji': '🐉',
      'description': 'Mythical creature',
      'unlockLevel': 6,
      'unlockPoints': 3000,
      'rarity': 'Legendary',
    },
    {
      'name': 'Fairy Lily',
      'color': 0xFF87CEEB,
      'icon': 'auto_awesome',
      'emoji': '🧚‍♀️',
      'description': 'Magical being',
      'unlockLevel': 4,
      'unlockPoints': 1200,
      'rarity': 'Epic',
    },
    {
      'name': 'Ninja Shadow',
      'color': 0xFF2C3E50,
      'icon': 'sports_mma',
      'emoji': '🥷',
      'description': 'Stealth master',
      'unlockLevel': 5,
      'unlockPoints': 1800,
      'rarity': 'Epic',
    },
    {
      'name': 'Mermaid Coral',
      'color': 0xFF00CED1,
      'icon': 'beach_access',
      'emoji': '🧜‍♀️',
      'description': 'Ocean dweller',
      'unlockLevel': 4,
      'unlockPoints': 1400,
      'rarity': 'Rare',
    },
    {
      'name': 'Astronaut Star',
      'color': 0xFF1E90FF,
      'icon': 'rocket',
      'emoji': '👨‍🚀',
      'description': 'Space explorer',
      'unlockLevel': 7,
      'unlockPoints': 4000,
      'rarity': 'Legendary',
    },
    {
      'name': 'Superhero Max',
      'color': 0xFFDC143C,
      'icon': 'flash_on',
      'emoji': '🦸‍♂️',
      'description': 'Caped crusader',
      'unlockLevel': 6,
      'unlockPoints': 2500,
      'rarity': 'Legendary',
    },
  ];
  
  // Getter methods
  int get selectedAvatarIndex => _selectedAvatarIndex;
  String get avatarName => _avatarName;
  Color get avatarColor => Color(_avatarColor);
  String get avatarEmoji => _avatarEmoji;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get availableAvatars => _availableAvatars;
  List<int> get unlockedAvatars => _unlockedAvatars;
  
  // Get current avatar data
  Map<String, dynamic> get currentAvatar => _availableAvatars[_selectedAvatarIndex];
  
  // Constructor
  AvatarProvider() {
    _loadAvatarData();
  }
  
  // Load avatar data from SharedPreferences
  Future<void> _loadAvatarData() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _selectedAvatarIndex = prefs.getInt(AppConstants.keySelectedAvatar) ?? 0;
      _avatarName = prefs.getString(AppConstants.keyAvatarName) ?? 'Explorer';
      _avatarColor = prefs.getInt(AppConstants.keyAvatarColor) ?? 0xFF04696B;
      
      // Load unlocked avatars
      final unlockedJson = prefs.getString('unlocked_avatars');
      if (unlockedJson != null) {
        final List<dynamic> decoded = _parseUnlockedAvatars(unlockedJson);
        _unlockedAvatars = decoded.cast<int>();
      } else {
        _unlockedAvatars = [0];
      }
      
      // Update emoji based on selected avatar
      _avatarEmoji = _availableAvatars[_selectedAvatarIndex]['emoji'] as String;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading avatar data: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Parse unlocked avatars from JSON string
  List<dynamic> _parseUnlockedAvatars(String json) {
    // Simple parsing for list like "[0,1,2]"
    if (json.startsWith('[') && json.endsWith(']')) {
      final content = json.substring(1, json.length - 1);
      if (content.isEmpty) return [];
      return content.split(',').map((e) => int.parse(e.trim())).toList();
    }
    return [0];
  }
  
  // Set avatar
  Future<void> setAvatar(int index, String name) async {
    if (index < 0 || index >= _availableAvatars.length) return;
    if (!_unlockedAvatars.contains(index)) return;
    
    _selectedAvatarIndex = index;
    _avatarName = name;
    _avatarColor = _availableAvatars[index]['color'];
    _avatarEmoji = _availableAvatars[index]['emoji'] as String;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keySelectedAvatar, index);
    await prefs.setString(AppConstants.keyAvatarName, name);
    await prefs.setInt(AppConstants.keyAvatarColor, _avatarColor);
    
    notifyListeners();
  }
  
  // Unlock new avatar
  Future<bool> unlockAvatar(int index, int currentScore, int currentLevel) async {
    if (index < 0 || index >= _availableAvatars.length) return false;
    if (_unlockedAvatars.contains(index)) return true;
    
    final avatar = _availableAvatars[index];
    final requiredPoints = avatar['unlockPoints'] as int;
    final requiredLevel = avatar['unlockLevel'] as int;
    
    // Check unlock conditions
    if (currentScore >= requiredPoints && currentLevel >= requiredLevel) {
      _unlockedAvatars.add(index);
      _unlockedAvatars.sort();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('unlocked_avatars', _unlockedAvatars.toString());
      
      notifyListeners();
      return true;
    }
    
    return false;
  }
  
  // Check if avatar is unlocked
  bool isAvatarUnlocked(int index) {
    return _unlockedAvatars.contains(index);
  }
  
  // Check if avatar can be unlocked
  bool canUnlockAvatar(int index, int currentScore, int currentLevel) {
    if (index < 0 || index >= _availableAvatars.length) return false;
    if (_unlockedAvatars.contains(index)) return true;
    
    final avatar = _availableAvatars[index];
    final requiredPoints = avatar['unlockPoints'] as int;
    final requiredLevel = avatar['unlockLevel'] as int;
    
    return currentScore >= requiredPoints && currentLevel >= requiredLevel;
  }
  
  // Get unlock requirements for avatar
  String getUnlockRequirement(int index) {
    if (index < 0 || index >= _availableAvatars.length) return '';
    
    final avatar = _availableAvatars[index];
    final requiredPoints = avatar['unlockPoints'] as int;
    final requiredLevel = avatar['unlockLevel'] as int;
    
    if (requiredPoints == 0 && requiredLevel == 1) {
      return 'Starting avatar';
    }
    
    return 'Reach Level $requiredLevel or ${requiredPoints} points';
  }
  
  // Get icon data for current avatar
  IconData getAvatarIcon() {
    final iconName = currentAvatar['icon'] as String;
    switch (iconName) {
      case 'emoji_emotions':
        return Icons.emoji_emotions;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'shield':
        return Icons.shield;
      case 'sailing':
        return Icons.sailing;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'android':
        return Icons.android;
      case 'whatshot':
        return Icons.whatshot;
      case 'sports_mma':
        return Icons.sports_mma;
      case 'beach_access':
        return Icons.beach_access;
      case 'rocket':
        return Icons.rocket;
      case 'flash_on':
        return Icons.flash_on;
      default:
        return Icons.person;
    }
  }
  
  // Get avatar emoji
  String getAvatarEmoji() {
    return currentAvatar['emoji'] as String;
  }
  
  // Get avatar name by index
  String getAvatarName(int index) {
    if (index < 0 || index >= _availableAvatars.length) return '';
    return _availableAvatars[index]['name'] as String;
  }
  
  // Get avatar color by index
  Color getAvatarColorByIndex(int index) {
    if (index < 0 || index >= _availableAvatars.length) return Colors.grey;
    return Color(_availableAvatars[index]['color']);
  }
  
  // Get avatar rarity by index
  String getAvatarRarity(int index) {
    if (index < 0 || index >= _availableAvatars.length) return '';
    return _availableAvatars[index]['rarity'] as String;
  }
  
  // Get rarity color
  Color getRarityColor(String rarity) {
    switch (rarity) {
      case 'Common':
        return Colors.grey;
      case 'Rare':
        return AppColors.neonBlue;
      case 'Epic':
        return AppColors.neonPurple;
      case 'Legendary':
        return AppColors.gold;
      default:
        return Colors.grey;
    }
  }
  
  // Get unlocked avatars count
  int getUnlockedCount() {
    return _unlockedAvatars.length;
  }
  
  // Get total avatars count
  int getTotalCount() {
    return _availableAvatars.length;
  }
  
  // Get completion percentage
  double getCompletionPercentage() {
    return _unlockedAvatars.length / _availableAvatars.length;
  }
  
  // Get next unlockable avatar
  Map<String, dynamic>? getNextUnlockableAvatar(int currentScore, int currentLevel) {
    for (int i = 0; i < _availableAvatars.length; i++) {
      if (!_unlockedAvatars.contains(i)) {
        final avatar = _availableAvatars[i];
        final requiredPoints = avatar['unlockPoints'] as int;
        final requiredLevel = avatar['unlockLevel'] as int;
        
        if (currentScore >= requiredPoints && currentLevel >= requiredLevel) {
          return avatar;
        }
      }
    }
    return null;
  }
  
  // Helper: Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
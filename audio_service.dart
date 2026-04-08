import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treasure_minds/config/theme.dart';
import '../config/app_constants.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  final AudioPlayer _soundEffectsPlayer = AudioPlayer();
  
  bool _isMusicEnabled = true;
  bool _isSoundEnabled = true;
  double _musicVolume = 0.5;
  double _soundVolume = 0.8;
  
  String? _currentMusicPath;
  bool _isMusicPlaying = false;

  // Getters
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSoundEnabled => _isSoundEnabled;
  double get musicVolume => _musicVolume;
  double get soundVolume => _soundVolume;
  bool get isMusicPlaying => _isMusicPlaying;

  // Initialize audio service
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isMusicEnabled = prefs.getBool(AppConstants.keyMusicEnabled) ?? true;
    _isSoundEnabled = prefs.getBool(AppConstants.keySoundEnabled) ?? true;
    _musicVolume = prefs.getDouble('music_volume') ?? 0.5;
    _soundVolume = prefs.getDouble('sound_volume') ?? 0.8;
    
    await _backgroundMusicPlayer.setVolume(_musicVolume);
    await _soundEffectsPlayer.setVolume(_soundVolume);
  }

  // Background music methods
  Future<void> playBackgroundMusic(String musicPath, {bool loop = true}) async {
    if (!_isMusicEnabled) return;
    if (_currentMusicPath == musicPath && _isMusicPlaying) return;
    
    _currentMusicPath = musicPath;
    await _backgroundMusicPlayer.stop();
    
    await _backgroundMusicPlayer.play(AssetSource(musicPath));
    if (loop) {
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    }
    _isMusicPlaying = true;
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundMusicPlayer.stop();
    _isMusicPlaying = false;
    _currentMusicPath = null;
  }

  Future<void> pauseBackgroundMusic() async {
    await _backgroundMusicPlayer.pause();
    _isMusicPlaying = false;
  }

  Future<void> resumeBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    await _backgroundMusicPlayer.resume();
    _isMusicPlaying = true;
  }

  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _backgroundMusicPlayer.setVolume(_musicVolume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('music_volume', _musicVolume);
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _isMusicEnabled = enabled;
    if (!enabled) {
      await pauseBackgroundMusic();
    } else if (_currentMusicPath != null) {
      await resumeBackgroundMusic();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyMusicEnabled, enabled);
  }

  // Sound effects methods
  Future<void> playSound(String soundPath, {double? volume}) async {
    if (!_isSoundEnabled) return;
    final playVolume = volume ?? _soundVolume;
    await _soundEffectsPlayer.setVolume(playVolume);
    await _soundEffectsPlayer.play(AssetSource(soundPath));
  }

  Future<void> setSoundVolume(double volume) async {
    _soundVolume = volume.clamp(0.0, 1.0);
    await _soundEffectsPlayer.setVolume(_soundVolume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sound_volume', _soundVolume);
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _isSoundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keySoundEnabled, enabled);
  }

  // Predefined sound effects
  Future<void> playCorrectAnswerSound() async {
    await playSound('sounds/correct.mp3');
  }

  Future<void> playWrongAnswerSound() async {
    await playSound('sounds/wrong.mp3');
  }

  Future<void> playButtonClickSound() async {
    await playSound('sounds/click.mp3');
  }

  Future<void> playLevelCompleteSound() async {
    await playSound('sounds/level_complete.mp3');
  }

  Future<void> playGameOverSound() async {
    await playSound('sounds/game_over.mp3');
  }

  Future<void> playVictorySound() async {
    await playSound('sounds/victory.mp3');
  }

  Future<void> playAchievementSound() async {
    await playSound('sounds/achievement.mp3');
  }

  Future<void> playCoinCollectSound() async {
    await playSound('sounds/coin.mp3');
  }

  Future<void> playKeyCollectSound() async {
    await playSound('sounds/key.mp3');
  }

  Future<void> playPowerUpSound() async {
    await playSound('sounds/powerup.mp3');
  }

  // Dispose
  void dispose() {
    _backgroundMusicPlayer.dispose();
    _soundEffectsPlayer.dispose();
  }
}

// Audio service provider for easy access
class AudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  
  bool get isMusicEnabled => _audioService.isMusicEnabled;
  bool get isSoundEnabled => _audioService.isSoundEnabled;
  double get musicVolume => _audioService.musicVolume;
  double get soundVolume => _audioService.soundVolume;
  bool get isMusicPlaying => _audioService.isMusicPlaying;

  Future<void> init() async {
    await _audioService.init();
    notifyListeners();
  }

  Future<void> playBackgroundMusic(String musicPath, {bool loop = true}) async {
    await _audioService.playBackgroundMusic(musicPath, loop: loop);
    notifyListeners();
  }

  Future<void> stopBackgroundMusic() async {
    await _audioService.stopBackgroundMusic();
    notifyListeners();
  }

  Future<void> pauseBackgroundMusic() async {
    await _audioService.pauseBackgroundMusic();
    notifyListeners();
  }

  Future<void> resumeBackgroundMusic() async {
    await _audioService.resumeBackgroundMusic();
    notifyListeners();
  }

  Future<void> setMusicVolume(double volume) async {
    await _audioService.setMusicVolume(volume);
    notifyListeners();
  }

  Future<void> setMusicEnabled(bool enabled) async {
    await _audioService.setMusicEnabled(enabled);
    notifyListeners();
  }

  Future<void> setSoundVolume(double volume) async {
    await _audioService.setSoundVolume(volume);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _audioService.setSoundEnabled(enabled);
    notifyListeners();
  }

  // Sound effects
  Future<void> playCorrectAnswerSound() async {
    await _audioService.playCorrectAnswerSound();
  }

  Future<void> playWrongAnswerSound() async {
    await _audioService.playWrongAnswerSound();
  }

  Future<void> playButtonClickSound() async {
    await _audioService.playButtonClickSound();
  }

  Future<void> playLevelCompleteSound() async {
    await _audioService.playLevelCompleteSound();
  }

  Future<void> playGameOverSound() async {
    await _audioService.playGameOverSound();
  }

  Future<void> playVictorySound() async {
    await _audioService.playVictorySound();
  }

  Future<void> playAchievementSound() async {
    await _audioService.playAchievementSound();
  }

  Future<void> playCoinCollectSound() async {
    await _audioService.playCoinCollectSound();
  }

  Future<void> playKeyCollectSound() async {
    await _audioService.playKeyCollectSound();
  }

  Future<void> playPowerUpSound() async {
    await _audioService.playPowerUpSound();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}

// Audio file paths constants
class AudioPaths {
  // Background music
  static const String menuMusic = 'music/menu_music.mp3';
  static const String gameMusic = 'music/game_music.mp3';
  static const String adventureMusic = 'music/adventure_music.mp3';
  static const String victoryMusic = 'music/victory_music.mp3';
  
  // Sound effects
  static const String correctAnswer = 'sounds/correct.mp3';
  static const String wrongAnswer = 'sounds/wrong.mp3';
  static const String buttonClick = 'sounds/click.mp3';
  static const String levelComplete = 'sounds/level_complete.mp3';
  static const String gameOver = 'sounds/game_over.mp3';
  static const String victory = 'sounds/victory.mp3';
  static const String achievement = 'sounds/achievement.mp3';
  static const String coinCollect = 'sounds/coin.mp3';
  static const String keyCollect = 'sounds/key.mp3';
  static const String powerUp = 'sounds/powerup.mp3';
  static const String timerTick = 'sounds/timer_tick.mp3';
  static const String countdown = 'sounds/countdown.mp3';
}

// Audio widget for playing sounds on tap
class SoundButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? soundPath;
  final bool hapticFeedback;

  const SoundButton({
    super.key,
    required this.child,
    this.onTap,
    this.soundPath,
    this.hapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    
    return GestureDetector(
      onTap: () async {
        if (soundPath != null) {
          await audioProvider.playButtonClickSound();
        }
        if (hapticFeedback) {
          await _vibrate();
        }
        onTap?.call();
      },
      child: child,
    );
  }

  Future<void> _vibrate() async {
    // Implement haptic feedback if needed
  }
}

// Audio control widget
class AudioControlWidget extends StatelessWidget {
  const AudioControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    
    return Column(
      children: [
        // Music toggle
        ListTile(
          leading: Icon(
            audioProvider.isMusicEnabled ? Icons.music_note : Icons.music_off,
            color: audioProvider.isMusicEnabled ? AppColors.neonBlue : Colors.grey,
          ),
          title: const Text('Background Music'),
          trailing: Switch(
            value: audioProvider.isMusicEnabled,
            onChanged: (value) async {
              await audioProvider.setMusicEnabled(value);
            },
            activeThumbColor: AppColors.neonBlue,
            activeTrackColor: AppColors.neonBlue.withValues(alpha: 0.5),
          ),
        ),
        
        // Music volume slider
        if (audioProvider.isMusicEnabled)
          Slider(
            value: audioProvider.musicVolume,
            onChanged: (value) async {
              await audioProvider.setMusicVolume(value);
            },
            activeColor: AppColors.neonBlue,
          ),
        
        const Divider(),
        
        // Sound effects toggle
        ListTile(
          leading: Icon(
            audioProvider.isSoundEnabled ? Icons.volume_up : Icons.volume_off,
            color: audioProvider.isSoundEnabled ? AppColors.neonBlue : Colors.grey,
          ),
          title: const Text('Sound Effects'),
          trailing: Switch(
            value: audioProvider.isSoundEnabled,
            onChanged: (value) async {
              await audioProvider.setSoundEnabled(value);
            },
            activeThumbColor: AppColors.neonBlue,
            activeTrackColor: AppColors.neonBlue.withValues(alpha: 0.5),
          ),
        ),
        
        // Sound volume slider
        if (audioProvider.isSoundEnabled)
          Slider(
            value: audioProvider.soundVolume,
            onChanged: (value) async {
              await audioProvider.setSoundVolume(value);
            },
            activeColor: AppColors.neonBlue,
          ),
      ],
    );
  }
}
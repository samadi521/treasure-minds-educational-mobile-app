import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../games/math_game_screen.dart';
import '../games/english_game_screen.dart';
import '../games/science_game_screen.dart';

class TopicSelectionScreen extends StatefulWidget {
  final String subject;
  final int gradeNumber;
  final String gradeName;
  
  const TopicSelectionScreen({
    super.key,
    required this.subject,
    required this.gradeNumber,
    required this.gradeName,
  });

  @override
  State<TopicSelectionScreen> createState() => _TopicSelectionScreenState();
}

class _TopicSelectionScreenState extends State<TopicSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _searchQuery = '';
  String _selectedDifficulty = 'All';
  
  // Topics based on subject and grade
  late List<Topic> _allTopics;
  List<Topic> _filteredTopics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
    _filteredTopics = _allTopics;
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

  void _loadTopics() {
    switch (widget.subject) {
      case 'Math':
        _allTopics = _getMathTopics();
        break;
      case 'English':
        _allTopics = _getEnglishTopics();
        break;
      case 'Science':
        _allTopics = _getScienceTopics();
        break;
      default:
        _allTopics = [];
    }
  }

  void _filterTopics() {
    setState(() {
      _filteredTopics = _allTopics.where((topic) {
        final matchesSearch = _searchQuery.isEmpty || 
            topic.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            topic.description.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesDifficulty = _selectedDifficulty == 'All' || 
            topic.difficulty == _selectedDifficulty;
        return matchesSearch && matchesDifficulty;
      }).toList();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text("${widget.subject} Topics - ${widget.gradeName}"),
        backgroundColor: _getSubjectColor(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 8),
                _buildDifficultyFilter(),
              ],
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _filteredTopics.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredTopics.length,
                  itemBuilder: (context, index) {
                    return _buildTopicCard(_filteredTopics[index], game);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          _searchQuery = value;
          _filterTopics();
        },
        decoration: InputDecoration(
          hintText: 'Search topics...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _filterTopics();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDifficultyFilter() {
    final difficulties = ['All', 'Easy', 'Medium', 'Hard', 'Advanced'];
    
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: difficulties.length,
        itemBuilder: (context, index) {
          final difficulty = difficulties[index];
          final isSelected = _selectedDifficulty == difficulty;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDifficulty = difficulty;
                _filterTopics();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? _getDifficultyColor(difficulty) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Text(
                difficulty,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicCard(Topic topic, GameProvider game) {
    final isCompleted = topic.progress >= 1.0;
    final progressPercent = (topic.progress * 100).toInt();
    final difficultyColor = _getDifficultyColor(topic.difficulty);
    
    return GestureDetector(
      onTap: () {
        _startTopicGame(topic);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Topic Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [difficultyColor, difficultyColor.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        topic.emoji,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Topic Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                topic.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: difficultyColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                topic.difficulty,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: difficultyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          topic.description,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        // Progress Bar
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: topic.progress,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation(difficultyColor),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$progressPercent%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: difficultyColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Stats Row
                        Row(
                          children: [
                            _buildTopicStat(Icons.quiz, '${topic.questionCount} questions'),
                            const SizedBox(width: 12),
                            _buildTopicStat(Icons.star, '+${topic.xpReward} XP'),
                            const SizedBox(width: 12),
                            _buildTopicStat(Icons.timer, topic.estimatedTime),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action Button
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.mintGreen : difficultyColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isCompleted ? AppColors.mintGreen : difficultyColor).withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      isCompleted ? Icons.replay : Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            if (isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.mintGreen, size: 14),
                    const SizedBox(width: 6),
                    const Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mintGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, color: AppColors.gold, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '+${topic.completionBonus} Bonus XP',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No topics found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term or filter',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectedDifficulty = 'All';
                _filterTopics();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getSubjectColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  void _startTopicGame(Topic topic) {
    Widget gameScreen;
    switch (widget.subject) {
      case 'Math':
        gameScreen = MathGameScreen(
          gradeLevel: widget.gradeNumber,
          level: topic.id,
        );
        break;
      case 'English':
        gameScreen = EnglishGameScreen(
          gradeLevel: widget.gradeNumber,
          level: topic.id,
        );
        break;
      case 'Science':
        gameScreen = ScienceGameScreen(
          gradeLevel: widget.gradeNumber,
          level: topic.id,
        );
        break;
      default:
        gameScreen = MathGameScreen(
          gradeLevel: widget.gradeNumber,
          level: topic.id,
        );
    }
    
    Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen)).then((_) {
      // Refresh topic progress (in real app, load from storage)
      setState(() {
        if (topic.progress < 1.0) {
          topic.progress += 0.25;
          if (topic.progress > 1.0) topic.progress = 1.0;
        }
      });
    });
  }

  List<Topic> _getMathTopics() {
    final baseTopics = [
      Topic(
        id: 1,
        name: 'Basic Addition',
        description: 'Learn to add numbers from 1 to 20',
        emoji: '➕',
        difficulty: 'Easy',
        questionCount: 15,
        xpReward: 50,
        estimatedTime: '5-7 min',
        progress: 0.0,
        completionBonus: 25,
      ),
      Topic(
        id: 2,
        name: 'Subtraction Basics',
        description: 'Master subtraction with numbers up to 20',
        emoji: '➖',
        difficulty: 'Easy',
        questionCount: 15,
        xpReward: 50,
        estimatedTime: '5-7 min',
        progress: 0.0,
        completionBonus: 25,
      ),
      Topic(
        id: 3,
        name: 'Multiplication Tables',
        description: 'Learn times tables from 1 to 12',
        emoji: '✖️',
        difficulty: 'Medium',
        questionCount: 20,
        xpReward: 75,
        estimatedTime: '8-10 min',
        progress: 0.0,
        completionBonus: 35,
      ),
      Topic(
        id: 4,
        name: 'Division Fundamentals',
        description: 'Understanding division and remainders',
        emoji: '➗',
        difficulty: 'Medium',
        questionCount: 20,
        xpReward: 75,
        estimatedTime: '8-10 min',
        progress: 0.0,
        completionBonus: 35,
      ),
      Topic(
        id: 5,
        name: 'Fractions',
        description: 'Working with halves, thirds, and quarters',
        emoji: '🔢',
        difficulty: 'Hard',
        questionCount: 25,
        xpReward: 100,
        estimatedTime: '10-12 min',
        progress: 0.0,
        completionBonus: 50,
      ),
      Topic(
        id: 6,
        name: 'Decimals',
        description: 'Understanding decimal numbers and place value',
        emoji: '🔟',
        difficulty: 'Hard',
        questionCount: 25,
        xpReward: 100,
        estimatedTime: '10-12 min',
        progress: 0.0,
        completionBonus: 50,
      ),
    ];
    
    // Adjust based on grade level
    if (widget.gradeNumber >= 7) {
      baseTopics.addAll([
        Topic(
          id: 7,
          name: 'Algebra Basics',
          description: 'Variables, expressions, and simple equations',
          emoji: '🔤',
          difficulty: 'Advanced',
          questionCount: 30,
          xpReward: 125,
          estimatedTime: '12-15 min',
          progress: 0.0,
          completionBonus: 60,
        ),
        Topic(
          id: 8,
          name: 'Geometry',
          description: 'Shapes, angles, and area calculations',
          emoji: '📐',
          difficulty: 'Advanced',
          questionCount: 30,
          xpReward: 125,
          estimatedTime: '12-15 min',
          progress: 0.0,
          completionBonus: 60,
        ),
      ]);
    }
    
    return baseTopics;
  }

  List<Topic> _getEnglishTopics() {
    final baseTopics = [
      Topic(
        id: 1,
        name: 'Alphabet & Phonics',
        description: 'Learn letters and their sounds',
        emoji: '🔤',
        difficulty: 'Easy',
        questionCount: 15,
        xpReward: 50,
        estimatedTime: '5-7 min',
        progress: 0.0,
        completionBonus: 25,
      ),
      Topic(
        id: 2,
        name: 'Basic Vocabulary',
        description: 'Common words and their meanings',
        emoji: '📖',
        difficulty: 'Easy',
        questionCount: 15,
        xpReward: 50,
        estimatedTime: '5-7 min',
        progress: 0.0,
        completionBonus: 25,
      ),
      Topic(
        id: 3,
        name: 'Nouns & Verbs',
        description: 'Identifying parts of speech',
        emoji: '📝',
        difficulty: 'Medium',
        questionCount: 20,
        xpReward: 75,
        estimatedTime: '8-10 min',
        progress: 0.0,
        completionBonus: 35,
      ),
      Topic(
        id: 4,
        name: 'Sentence Structure',
        description: 'Building correct sentences',
        emoji: '✍️',
        difficulty: 'Medium',
        questionCount: 20,
        xpReward: 75,
        estimatedTime: '8-10 min',
        progress: 0.0,
        completionBonus: 35,
      ),
      Topic(
        id: 5,
        name: 'Reading Comprehension',
        description: 'Understanding what you read',
        emoji: '📚',
        difficulty: 'Hard',
        questionCount: 25,
        xpReward: 100,
        estimatedTime: '10-12 min',
        progress: 0.0,
        completionBonus: 50,
      ),
      Topic(
        id: 6,
        name: 'Spelling Rules',
        description: 'Common spelling patterns',
        emoji: '🔠',
        difficulty: 'Hard',
        questionCount: 25,
        xpReward: 100,
        estimatedTime: '10-12 min',
        progress: 0.0,
        completionBonus: 50,
      ),
    ];
    
    if (widget.gradeNumber >= 7) {
      baseTopics.addAll([
        Topic(
          id: 7,
          name: 'Advanced Grammar',
          description: 'Tenses, clauses, and punctuation',
          emoji: '📋',
          difficulty: 'Advanced',
          questionCount: 30,
          xpReward: 125,
          estimatedTime: '12-15 min',
          progress: 0.0,
          completionBonus: 60,
        ),
        Topic(
          id: 8,
          name: 'Essay Writing',
          description: 'Structuring paragraphs and essays',
          emoji: '📄',
          difficulty: 'Advanced',
          questionCount: 30,
          xpReward: 125,
          estimatedTime: '12-15 min',
          progress: 0.0,
          completionBonus: 60,
        ),
      ]);
    }
    
    return baseTopics;
  }

  List<Topic> _getScienceTopics() {
    final baseTopics = [
      Topic(
        id: 1,
        name: 'Living Things',
        description: 'Plants, animals, and humans',
        emoji: '🌱',
        difficulty: 'Easy',
        questionCount: 15,
        xpReward: 50,
        estimatedTime: '5-7 min',
        progress: 0.0,
        completionBonus: 25,
      ),
      Topic(
        id: 2,
        name: 'Materials & Matter',
        description: 'Solids, liquids, and gases',
        emoji: '🧪',
        difficulty: 'Easy',
        questionCount: 15,
        xpReward: 50,
        estimatedTime: '5-7 min',
        progress: 0.0,
        completionBonus: 25,
      ),
      Topic(
        id: 3,
        name: 'Forces & Motion',
        description: 'Push, pull, and movement',
        emoji: '⚡',
        difficulty: 'Medium',
        questionCount: 20,
        xpReward: 75,
        estimatedTime: '8-10 min',
        progress: 0.0,
        completionBonus: 35,
      ),
      Topic(
        id: 4,
        name: 'The Solar System',
        description: 'Planets, stars, and space',
        emoji: '🪐',
        difficulty: 'Medium',
        questionCount: 20,
        xpReward: 75,
        estimatedTime: '8-10 min',
        progress: 0.0,
        completionBonus: 35,
      ),
      Topic(
        id: 5,
        name: 'Human Body',
        description: 'Organs and body systems',
        emoji: '🧬',
        difficulty: 'Hard',
        questionCount: 25,
        xpReward: 100,
        estimatedTime: '10-12 min',
        progress: 0.0,
        completionBonus: 50,
      ),
      Topic(
        id: 6,
        name: 'Ecosystems',
        description: 'Food chains and habitats',
        emoji: '🌍',
        difficulty: 'Hard',
        questionCount: 25,
        xpReward: 100,
        estimatedTime: '10-12 min',
        progress: 0.0,
        completionBonus: 50,
      ),
    ];
    
    if (widget.gradeNumber >= 8) {
      baseTopics.addAll([
        Topic(
          id: 7,
          name: 'Chemical Reactions',
          description: 'Acids, bases, and reactions',
          emoji: '🧪',
          difficulty: 'Advanced',
          questionCount: 30,
          xpReward: 125,
          estimatedTime: '12-15 min',
          progress: 0.0,
          completionBonus: 60,
        ),
        Topic(
          id: 8,
          name: 'Physics Fundamentals',
          description: 'Energy, waves, and electricity',
          emoji: '⚛️',
          difficulty: 'Advanced',
          questionCount: 30,
          xpReward: 125,
          estimatedTime: '12-15 min',
          progress: 0.0,
          completionBonus: 60,
        ),
      ]);
    }
    
    return baseTopics;
  }

  Color _getSubjectColor() {
    switch (widget.subject) {
      case 'Math': return AppColors.mathOrange;
      case 'English': return AppColors.englishGreen;
      case 'Science': return AppColors.sciencePurple;
      default: return AppColors.neonBlue;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy': return AppColors.mintGreen;
      case 'Medium': return AppColors.warningOrange;
      case 'Hard': return AppColors.mathOrange;
      case 'Advanced': return AppColors.neonPurple;
      default: return AppColors.neonBlue;
    }
  }
}

class Topic {
  final int id;
  final String name;
  final String description;
  final String emoji;
  final String difficulty;
  final int questionCount;
  final int xpReward;
  final String estimatedTime;
  double progress;
  final int completionBonus;

  Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.difficulty,
    required this.questionCount,
    required this.xpReward,
    required this.estimatedTime,
    required this.progress,
    required this.completionBonus,
  });
}
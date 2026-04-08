import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../puzzle/puzzle_screen.dart';

class PuzzleCategoryScreen extends StatefulWidget {
  const PuzzleCategoryScreen({super.key});

  @override
  State<PuzzleCategoryScreen> createState() => _PuzzleCategoryScreenState();
}

class _PuzzleCategoryScreenState extends State<PuzzleCategoryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _selectedCategory = 0;
  
  final List<PuzzleCategory> _categories = [
    PuzzleCategory(
      id: 1,
      name: 'Riddles',
      description: 'Classic brain teasers and clever word puzzles',
      emoji: '🤔',
      icon: Icons.psychology,
      color: AppColors.neonPurple,
      puzzleCount: 25,
      difficulty: 'Easy to Hard',
      timeEstimate: '2-5 min',
      xpReward: 50,
    ),
    PuzzleCategory(
      id: 2,
      name: 'Logic Puzzles',
      description: 'Use reasoning to solve complex problems',
      emoji: '🧠',
      icon: Icons.extension,
      color: AppColors.mathOrange,
      puzzleCount: 20,
      difficulty: 'Medium to Hard',
      timeEstimate: '5-10 min',
      xpReward: 75,
    ),
    PuzzleCategory(
      id: 3,
      name: 'Math Puzzles',
      description: 'Number patterns and mathematical challenges',
      emoji: '🔢',
      icon: Icons.calculate,
      color: AppColors.neonBlue,
      puzzleCount: 20,
      difficulty: 'Medium to Advanced',
      timeEstimate: '5-8 min',
      xpReward: 75,
    ),
    PuzzleCategory(
      id: 4,
      name: 'Word Puzzles',
      description: 'Anagrams, word searches, and vocabulary challenges',
      emoji: '📝',
      icon: Icons.menu_book,
      color: AppColors.englishGreen,
      puzzleCount: 25,
      difficulty: 'Easy to Medium',
      timeEstimate: '3-6 min',
      xpReward: 50,
    ),
    PuzzleCategory(
      id: 5,
      name: 'Visual Puzzles',
      description: 'Spot the difference and pattern recognition',
      emoji: '👁️',
      icon: Icons.visibility,
      color: AppColors.adventureTeal,
      puzzleCount: 15,
      difficulty: 'Easy to Medium',
      timeEstimate: '2-4 min',
      xpReward: 40,
    ),
    PuzzleCategory(
      id: 6,
      name: 'Mystery Puzzles',
      description: 'Solve whodunit mysteries and detective cases',
      emoji: '🕵️',
      icon: Icons.local_police,
      color: AppColors.neonOrange,
      puzzleCount: 15,
      difficulty: 'Hard to Advanced',
      timeEstimate: '8-12 min',
      xpReward: 100,
    ),
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
    final game = Provider.of<GameProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("Puzzle Categories"),
        backgroundColor: AppColors.lavenderPurple,
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
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryCard(_categories[index], index, game);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.lavenderPurple, AppColors.neonPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.lavenderPurple.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 35),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '🧩 Brain Training',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Challenge your mind with fun puzzles!',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(PuzzleCategory category, int index, GameProvider game) {
    final isCompleted = _isCategoryCompleted(category, game);
    final completedCount = _getCompletedCount(category, game);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      transform: Matrix4.identity()..scale(_selectedCategory == index ? 1.02 : 1.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = index;
          });
          _navigateToPuzzleScreen(category);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [category.color.withValues(alpha: 0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: category.color.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Category Icon
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [category.color, category.color.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          category.emoji,
                          style: const TextStyle(fontSize: 35),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Category Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(category.difficulty).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  category.difficulty,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getDifficultyColor(category.difficulty),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category.description,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          // Stats Row
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              _buildStatChip(Icons.quiz, '${category.puzzleCount} puzzles', Colors.grey),
                              _buildStatChip(Icons.timer, category.timeEstimate, Colors.grey),
                              _buildStatChip(Icons.star, '+${category.xpReward} XP', AppColors.gold),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Progress Bar
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: completedCount / category.puzzleCount,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation(category.color),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$completedCount/${category.puzzleCount}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: category.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Arrow
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: category.color,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.mintGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'MASTERED',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPuzzleScreen(PuzzleCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PuzzleScreen(),
      ),
    );
  }

  bool _isCategoryCompleted(PuzzleCategory category, GameProvider game) {
    // In real app, track completed puzzles per category
    // For demo, return true for first 2 categories
    return category.id <= 2;
  }

  int _getCompletedCount(PuzzleCategory category, GameProvider game) {
    // In real app, get completed count from storage
    // For demo, return sample counts
    switch (category.id) {
      case 1: return 18;
      case 2: return 12;
      case 3: return 8;
      case 4: return 5;
      default: return 0;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    if (difficulty.contains('Easy')) return AppColors.mintGreen;
    if (difficulty.contains('Medium')) return AppColors.warningOrange;
    if (difficulty.contains('Hard')) return AppColors.mathOrange;
    return AppColors.neonPurple;
  }
}

class PuzzleCategory {
  final int id;
  final String name;
  final String description;
  final String emoji;
  final IconData icon;
  final Color color;
  final int puzzleCount;
  final String difficulty;
  final String timeEstimate;
  final int xpReward;

  PuzzleCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.icon,
    required this.color,
    required this.puzzleCount,
    required this.difficulty,
    required this.timeEstimate,
    required this.xpReward,
  });
}
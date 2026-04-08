import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../grade/grade_selection_screen.dart';
import '../games/math_game_screen.dart';
import '../games/english_game_screen.dart';
import '../games/science_game_screen.dart';

class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});

  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedGrade = 'Grade 3';
  int _selectedGradeLevel = 3;
  
  final List<String> _grades = ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11'];
  
  // Curriculum data by grade and subject
  final Map<String, Map<String, List<CurriculumItem>>> _curriculumData = {
    'Grade 1': {
      'Math': [
        CurriculumItem(name: 'Numbers 1-20', description: 'Counting and writing numbers', icon: Icons.looks_one, progress: 0.8, isLocked: false),
        CurriculumItem(name: 'Addition Basics', description: 'Adding numbers up to 10', icon: Icons.add, progress: 0.6, isLocked: false),
        CurriculumItem(name: 'Subtraction Basics', description: 'Subtracting numbers up to 10', icon: Icons.remove, progress: 0.4, isLocked: false),
        CurriculumItem(name: 'Shapes', description: 'Identifying basic shapes', icon: Icons.crop_square, progress: 0.3, isLocked: false),
        CurriculumItem(name: 'Patterns', description: 'Recognizing patterns', icon: Icons.timeline, progress: 0.1, isLocked: false),
      ],
      'English': [
        CurriculumItem(name: 'Alphabet', description: 'Letters A-Z', icon: Icons.abc, progress: 0.9, isLocked: false),
        CurriculumItem(name: 'Basic Vocabulary', description: 'Common words', icon: Icons.menu_book, progress: 0.7, isLocked: false),
        CurriculumItem(name: 'Simple Sentences', description: 'Building basic sentences', icon: Icons.description, progress: 0.5, isLocked: false),
        CurriculumItem(name: 'Reading Practice', description: 'Short stories', icon: Icons.local_library, progress: 0.3, isLocked: false),
      ],
      'Science': [
        CurriculumItem(name: 'Living Things', description: 'Plants and animals', icon: Icons.forest, progress: 0.7, isLocked: false),
        CurriculumItem(name: 'Weather', description: 'Sun, rain, clouds', icon: Icons.wb_sunny, progress: 0.5, isLocked: false),
        CurriculumItem(name: 'My Body', description: 'Body parts', icon: Icons.accessibility, progress: 0.4, isLocked: false),
      ],
    },
    'Grade 2': {
      'Math': [
        CurriculumItem(name: 'Numbers 1-100', description: 'Counting to 100', icon: Icons.looks_one, progress: 0.7, isLocked: false),
        CurriculumItem(name: 'Addition & Subtraction', description: 'Up to 20', icon: Icons.add, progress: 0.6, isLocked: false),
        CurriculumItem(name: 'Multiplication Basics', description: 'Times tables 2,5,10', icon: Icons.close, progress: 0.4, isLocked: false),
        CurriculumItem(name: 'Measurement', description: 'Length and weight', icon: Icons.straighten, progress: 0.3, isLocked: false),
      ],
      'English': [
        CurriculumItem(name: 'Parts of Speech', description: 'Nouns and verbs', icon: Icons.category, progress: 0.6, isLocked: false),
        CurriculumItem(name: 'Spelling', description: 'Common words', icon: Icons.spellcheck, progress: 0.5, isLocked: false),
        CurriculumItem(name: 'Punctuation', description: 'Periods and capitals', icon: Icons.format_quote, progress: 0.4, isLocked: false),
      ],
      'Science': [
        CurriculumItem(name: 'Animal Habitats', description: 'Where animals live', icon: Icons.pets, progress: 0.6, isLocked: false),
        CurriculumItem(name: 'Plants', description: 'How plants grow', icon: Icons.forest, progress: 0.5, isLocked: false),
        CurriculumItem(name: 'Seasons', description: 'Four seasons', icon: Icons.local_florist, progress: 0.4, isLocked: false),
      ],
    },
    'Grade 3': {
      'Math': [
        CurriculumItem(name: 'Multiplication', description: 'Times tables 1-12', icon: Icons.close, progress: 0.7, isLocked: false),
        CurriculumItem(name: 'Division', description: 'Basic division', icon: Icons.percent, progress: 0.5, isLocked: false),
        CurriculumItem(name: 'Fractions', description: 'Halves and quarters', icon: Icons.pie_chart, progress: 0.4, isLocked: false),
        CurriculumItem(name: 'Geometry', description: 'Shapes and angles', icon: Icons.crop_rotate, progress: 0.3, isLocked: false),
        CurriculumItem(name: 'Word Problems', description: 'Real-world math', icon: Icons.quiz, progress: 0.2, isLocked: false),
      ],
      'English': [
        CurriculumItem(name: 'Grammar Rules', description: 'Sentence structure', icon: Icons.rule, progress: 0.6, isLocked: false),
        CurriculumItem(name: 'Vocabulary Building', description: 'New words', icon: Icons.menu_book, progress: 0.5, isLocked: false),
        CurriculumItem(name: 'Reading Comprehension', description: 'Understanding text', icon: Icons.description, progress: 0.4, isLocked: false),
        CurriculumItem(name: 'Creative Writing', description: 'Storytelling', icon: Icons.edit, progress: 0.2, isLocked: false),
      ],
      'Science': [
        CurriculumItem(name: 'Human Body Systems', description: 'Organs and functions', icon: Icons.favorite, progress: 0.5, isLocked: false),
        CurriculumItem(name: 'States of Matter', description: 'Solid, liquid, gas', icon: Icons.water, progress: 0.4, isLocked: false),
        CurriculumItem(name: 'Simple Machines', description: 'Levers and pulleys', icon: Icons.build, progress: 0.3, isLocked: false),
        CurriculumItem(name: 'Solar System', description: 'Planets', icon: Icons.public, progress: 0.2, isLocked: false),
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Curriculum Guide'),
        backgroundColor: AppColors.neonPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildGradeSelector(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildSubjectTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSubjectCurriculum('Math', game),
                  _buildSubjectCurriculum('English', game),
                  _buildSubjectCurriculum('Science', game),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeSelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _grades.length,
        itemBuilder: (context, index) {
          final grade = _grades[index];
          final isSelected = _selectedGrade == grade;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedGrade = grade;
                _selectedGradeLevel = index + 1;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.neonPurple : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Text(
                grade,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubjectTabs() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.neonPurple,
        unselectedLabelColor: Colors.grey,
        indicator: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        tabs: const [
          Tab(text: "📐 Math", icon: Icon(Icons.calculate)),
          Tab(text: "📖 English", icon: Icon(Icons.menu_book)),
          Tab(text: "🔬 Science", icon: Icon(Icons.science)),
        ],
      ),
    );
  }

  Widget _buildSubjectCurriculum(String subject, GameProvider game) {
    final curriculum = _curriculumData[_selectedGrade]?[subject] ?? [];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: curriculum.length,
      itemBuilder: (context, index) {
        final item = curriculum[index];
        return _buildCurriculumCard(item, subject);
      },
    );
  }

  Widget _buildCurriculumCard(CurriculumItem item, String subject) {
    final isCompleted = item.progress >= 1.0;
    final progressPercent = (item.progress * 100).toInt();
    
    return GestureDetector(
      onTap: item.isLocked ? null : () => _startTopic(item, subject),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getSubjectColor(subject),
                    _getSubjectColor(subject).withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(item.icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: item.progress,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(_getSubjectColor(subject)),
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
                          color: _getSubjectColor(subject),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action button
            if (item.isLocked)
              const Icon(Icons.lock, color: Colors.grey, size: 28)
            else if (isCompleted)
              const Icon(Icons.check_circle, color: AppColors.mintGreen, size: 28)
            else
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getSubjectColor(subject),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  void _startTopic(CurriculumItem item, String subject) {
    Widget gameScreen;
    switch (subject) {
      case 'Math':
        gameScreen = MathGameScreen(
          gradeLevel: _selectedGradeLevel,
          level: 1,
        );
        break;
      case 'English':
        gameScreen = EnglishGameScreen(
          gradeLevel: _selectedGradeLevel,
          level: 1,
        );
        break;
      case 'Science':
        gameScreen = ScienceGameScreen(
          gradeLevel: _selectedGradeLevel,
          level: 1,
        );
        break;
      default:
        gameScreen = MathGameScreen(
          gradeLevel: _selectedGradeLevel,
          level: 1,
        );
    }
    
    Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen)).then((_) {
      // Update progress (demo)
      setState(() {
        item.progress += 0.2;
        if (item.progress > 1.0) item.progress = 1.0;
      });
    });
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Math': return AppColors.mathOrange;
      case 'English': return AppColors.englishGreen;
      case 'Science': return AppColors.sciencePurple;
      default: return AppColors.neonBlue;
    }
  }
}

class CurriculumItem {
  final String name;
  final String description;
  final IconData icon;
  double progress;
  bool isLocked;

  CurriculumItem({
    required this.name,
    required this.description,
    required this.icon,
    required this.progress,
    required this.isLocked,
  });
}
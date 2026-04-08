import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../grade/grade_selection_screen.dart';

class SubjectSelectionScreen extends StatefulWidget {
  const SubjectSelectionScreen({super.key});

  @override
  State<SubjectSelectionScreen> createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _hoveredIndex = -1;

  final List<Subject> _subjects = [
    Subject(
      id: 'math',
      title: 'Mathematics',
      shortTitle: 'Math',
      description: 'Master numbers, operations, algebra, and problem-solving skills',
      longDescription: 'Practice addition, subtraction, multiplication, division, fractions, decimals, percentages, algebra, geometry, and more!',
      icon: Icons.calculate,
      color: AppColors.mathOrange,
      gradientColors: [AppColors.mathOrange, const Color(0xFFFFB74D)],
      emoji: '🧮',
      stats: '15+ Topics • 200+ Questions',
      difficulty: 'Beginner to Advanced',
      ageRange: 'Ages 6-16',
      achievements: ['Math Novice', 'Math Master', 'Math Genius'],
    ),
    Subject(
      id: 'english',
      title: 'English',
      shortTitle: 'English',
      description: 'Build vocabulary, master grammar, and improve reading comprehension',
      longDescription: 'Learn parts of speech, sentence structure, vocabulary building, reading comprehension, spelling, idioms, and creative writing!',
      icon: Icons.menu_book,
      color: AppColors.englishGreen,
      gradientColors: [AppColors.englishGreen, const Color(0xFF81C784)],
      emoji: '📚',
      stats: '12+ Topics • 250+ Questions',
      difficulty: 'Beginner to Advanced',
      ageRange: 'Ages 6-16',
      achievements: ['English Novice', 'English Master', 'English Genius'],
    ),
    Subject(
      id: 'science',
      title: 'Science',
      shortTitle: 'Science',
      description: 'Explore biology, chemistry, physics, and earth science',
      longDescription: 'Discover living organisms, chemical reactions, physical forces, space science, environmental science, and scientific methods!',
      icon: Icons.science,
      color: AppColors.sciencePurple,
      gradientColors: [AppColors.sciencePurple, const Color(0xFFCE93D8)],
      emoji: '🔬',
      stats: '8+ Topics • 200+ Questions',
      difficulty: 'Beginner to Advanced',
      ageRange: 'Ages 6-16',
      achievements: ['Science Novice', 'Science Master', 'Science Genius'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("Choose Subject"),
        backgroundColor: AppColors.neonBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeroBanner(),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildSubjectCard(_subjects[index], index);
                  },
                  childCount: _subjects.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildMoreSubjectsSection(),
            ),
            SliverToBoxAdapter(
              child: _buildLearningPathCard(),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.neonBlue, AppColors.neonPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonBlue.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Select a Subject',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Choose a subject to start your learning adventure!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: AppColors.gold),
                    SizedBox(width: 4),
                    Text(
                      'Earn badges for each subject',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school,
              color: Colors.white,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Subject subject, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GradeSelectionScreen(
              selectedSubject: subject.title,
            ),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) => setState(() => _hoveredIndex = -1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 20),
          transform: Matrix4.identity()..scale(_hoveredIndex == index ? 1.02 : 1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: subject.color.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main Card
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: subject.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GradeSelectionScreen(
                              selectedSubject: subject.title,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    subject.emoji,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        subject.title,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        subject.shortTitle,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withValues(alpha: 0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Description
                            Text(
                              subject.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Stats Row
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildStatChip(Icons.star, subject.stats, Colors.white70),
                                _buildStatChip(Icons.auto_awesome, subject.difficulty, Colors.white70),
                                _buildStatChip(Icons.cake, subject.ageRange, Colors.white70),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Topics Preview
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'What you\'ll learn:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _getTopicsForSubject(subject.id).map((topic) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          topic,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Achievements Preview
                            Row(
                              children: subject.achievements.map((achievement) {
                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.emoji_events, size: 16, color: AppColors.gold),
                                        const SizedBox(height: 2),
                                        Text(
                                          achievement,
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Decorative circles
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  bottom: -30,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
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

  Widget _buildMoreSubjectsSection() {
    final moreSubjects = [
      {'name': 'History', 'emoji': '🏛️', 'color': AppColors.bronze, 'comingSoon': true},
      {'name': 'Geography', 'emoji': '🌍', 'color': AppColors.adventureTeal, 'comingSoon': true},
      {'name': 'Art', 'emoji': '🎨', 'color': AppColors.bubblegumPink, 'comingSoon': true},
      {'name': 'Music', 'emoji': '🎵', 'color': AppColors.neonOrange, 'comingSoon': true},
      {'name': 'Coding', 'emoji': '💻', 'color': AppColors.neonGreen, 'comingSoon': true},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
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
              Icon(Icons.rocket, color: AppColors.neonPurple),
              SizedBox(width: 8),
              Text(
                'More Subjects Coming Soon!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Changed from Row to Wrap to fix overflow issue
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: moreSubjects.map((subject) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [(subject['color'] as Color).withValues(alpha: 0.1), (subject['color'] as Color).withValues(alpha: 0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: (subject['color'] as Color).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(subject['emoji'] as String, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      subject['name'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: subject['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Soon',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

  Widget _buildLearningPathCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gold, AppColors.warningOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.3),
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
              Icon(Icons.timeline, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Recommended Learning Path',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Start with Mathematics to build logical thinking, then explore English for communication skills, and finally dive into Science to understand the world around you.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPathStep('1', 'Math', AppColors.mathOrange),
              _buildPathArrow(),
              _buildPathStep('2', 'English', AppColors.englishGreen),
              _buildPathArrow(),
              _buildPathStep('3', 'Science', AppColors.sciencePurple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPathStep(String number, String name, Color color) {
    return Column(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPathArrow() {
    return const Icon(
      Icons.arrow_forward,
      color: Colors.white,
      size: 20,
    );
  }

  List<String> _getTopicsForSubject(String subjectId) {
    switch (subjectId) {
      case 'math':
        return ['Addition', 'Subtraction', 'Multiplication', 'Division', 'Fractions', 'Decimals', 'Algebra', 'Geometry'];
      case 'english':
        return ['Vocabulary', 'Grammar', 'Reading', 'Spelling', 'Writing', 'Idioms', 'Comprehension', 'Punctuation'];
      case 'science':
        return ['Biology', 'Chemistry', 'Physics', 'Earth Science', 'Space', 'Ecology', 'Matter', 'Energy'];
      default:
        return [];
    }
  }
}

class Subject {
  final String id;
  final String title;
  final String shortTitle;
  final String description;
  final String longDescription;
  final IconData icon;
  final Color color;
  final List<Color> gradientColors;
  final String emoji;
  final String stats;
  final String difficulty;
  final String ageRange;
  final List<String> achievements;

  Subject({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.longDescription,
    required this.icon,
    required this.color,
    required this.gradientColors,
    required this.emoji,
    required this.stats,
    required this.difficulty,
    required this.ageRange,
    required this.achievements,
  });
}
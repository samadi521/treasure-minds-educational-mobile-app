import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'level_selection_screen.dart';

class GradeSelectionScreen extends StatefulWidget {
  final String selectedSubject;
  
  const GradeSelectionScreen({
    super.key,
    required this.selectedSubject,
  });

  @override
  State<GradeSelectionScreen> createState() => _GradeSelectionScreenState();
}

class _GradeSelectionScreenState extends State<GradeSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _selectedGradeLevel = 0; // 0 = Primary, 1 = Secondary

  // Grade levels with detailed information
  final List<GradeLevel> primaryGrades = [
    GradeLevel(grade: 1, name: 'Grade 1', ageRange: 'Ages 6-7', color: AppColors.mintGreen, icon: Icons.looks_one, difficulty: 'Very Easy', topics: ['Counting', 'Basic Addition', 'Shapes', 'Patterns']),
    GradeLevel(grade: 2, name: 'Grade 2', ageRange: 'Ages 7-8', color: AppColors.mintGreen, icon: Icons.looks_two, difficulty: 'Easy', topics: ['Addition', 'Subtraction', 'Place Value', 'Measurement']),
    GradeLevel(grade: 3, name: 'Grade 3', ageRange: 'Ages 8-9', color: AppColors.mintGreen, icon: Icons.looks_3, difficulty: 'Easy', topics: ['Multiplication', 'Division', 'Fractions', 'Geometry']),
    GradeLevel(grade: 4, name: 'Grade 4', ageRange: 'Ages 9-10', color: AppColors.mintGreen, icon: Icons.looks_4, difficulty: 'Medium', topics: ['Multi-digit Operations', 'Decimals', 'Factors', 'Angles']),
    GradeLevel(grade: 5, name: 'Grade 5', ageRange: 'Ages 10-11', color: AppColors.mintGreen, icon: Icons.looks_5, difficulty: 'Medium', topics: ['Fractions/Decimals', 'Percentages', 'Volume', 'Coordinate Plane']),
  ];

  final List<GradeLevel> secondaryGrades = [
    GradeLevel(grade: 6, name: 'Grade 6', ageRange: 'Ages 11-12', color: AppColors.warningOrange, icon: Icons.looks_6, difficulty: 'Medium-Hard', topics: ['Ratios', 'Expressions', 'Equations', 'Statistics']),
    GradeLevel(grade: 7, name: 'Grade 7', ageRange: 'Ages 12-13', color: AppColors.warningOrange, icon: Icons.seven_k, difficulty: 'Hard', topics: ['Algebra Basics', 'Proportions', 'Probability', 'Inequalities']),
    GradeLevel(grade: 8, name: 'Grade 8', ageRange: 'Ages 13-14', color: AppColors.warningOrange, icon: Icons.eight_k, difficulty: 'Hard', topics: ['Linear Equations', 'Functions', 'Pythagorean Theorem', 'Scientific Notation']),
    GradeLevel(grade: 9, name: 'Grade 9', ageRange: 'Ages 14-15', color: AppColors.errorRed, icon: Icons.nine_k, difficulty: 'Advanced', topics: ['Quadratic Equations', 'Geometry Proofs', 'Trigonometry', 'Data Analysis']),
    GradeLevel(grade: 10, name: 'Grade 10', ageRange: 'Ages 15-16', color: AppColors.errorRed, icon: Icons.ten_k, difficulty: 'Advanced', topics: ['Polynomials', 'Circles', 'Probability', 'Statistics']),
    GradeLevel(grade: 11, name: 'Grade 11', ageRange: 'Ages 16-17', color: AppColors.neonPurple, icon: Icons.eleven_mp, difficulty: 'Expert', topics: ['Advanced Algebra', 'Trigonometry', 'Calculus Basics', 'Complex Numbers']),
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
        title: Text("${widget.selectedSubject} - Select Grade"),
        backgroundColor: _getSubjectColor(),
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
                _buildSubjectInfoBanner(),
                const SizedBox(height: 20),
                _buildLevelTypeSelector(),
                const SizedBox(height: 20),
                _buildGradeGrid(),
                const SizedBox(height: 20),
                _buildRecommendationCard(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectInfoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getSubjectColor(), _getSubjectColor().withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: _getSubjectColor().withValues(alpha: 0.3),
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
            child: Icon(
              _getSubjectIcon(),
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.selectedSubject,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getSubjectDescription(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text(
                      _getSubjectStats(),
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelTypeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(5),
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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGradeLevel = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedGradeLevel == 0 ? AppColors.mintGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      size: 18,
                      color: _selectedGradeLevel == 0 ? Colors.white : AppColors.mintGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Primary Level',
                      style: TextStyle(
                        color: _selectedGradeLevel == 0 ? Colors.white : AppColors.mintGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGradeLevel = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedGradeLevel == 1 ? AppColors.warningOrange : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: _selectedGradeLevel == 1 ? Colors.white : AppColors.warningOrange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Secondary Level',
                      style: TextStyle(
                        color: _selectedGradeLevel == 1 ? Colors.white : AppColors.warningOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeGrid() {
    final grades = _selectedGradeLevel == 0 ? primaryGrades : secondaryGrades;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: grades.length,
      itemBuilder: (context, index) {
        final grade = grades[index];
        return _buildGradeCard(grade);
      },
    );
  }

  Widget _buildGradeCard(GradeLevel grade) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LevelSelectionScreen(
              grade: grade.name,
              gradeNumber: grade.grade,
              subject: widget.selectedSubject,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [grade.color.withValues(alpha: 0.1), grade.color.withValues(alpha: 0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: grade.color.withValues(alpha: 0.3)),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Grade Icon
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [grade.color, grade.color.withValues(alpha: 0.7)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        grade.grade.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Grade Name
                  Text(
                    grade.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: grade.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Age Range
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: grade.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      grade.ageRange,
                      style: TextStyle(
                        fontSize: 10,
                        color: grade.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Difficulty Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(grade.difficulty).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      grade.difficulty,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getDifficultyColor(grade.difficulty),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Topics Preview
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    alignment: WrapAlignment.center,
                    children: grade.topics.take(3).map((topic) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: grade.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          topic,
                          style: TextStyle(
                            fontSize: 8,
                            color: grade.color,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // Hover effect overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [grade.color.withValues(alpha: 0.05), Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard() {
    final recommendedGrade = _selectedGradeLevel == 0 ? 'Grade 3' : 'Grade 8';
    final recommendedReason = _selectedGradeLevel == 0 
        ? 'Perfect for building foundational skills' 
        : 'Great for advancing your knowledge';
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.recommend, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recommended for You',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  recommendedGrade,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  recommendedReason,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_forward, size: 20, color: AppColors.gold),
          ),
        ],
      ),
    );
  }

  Color _getSubjectColor() {
    switch (widget.selectedSubject) {
      case 'Math':
        return AppColors.mathOrange;
      case 'English':
        return AppColors.englishGreen;
      case 'Science':
        return AppColors.sciencePurple;
      default:
        return AppColors.neonBlue;
    }
  }

  IconData _getSubjectIcon() {
    switch (widget.selectedSubject) {
      case 'Math':
        return Icons.calculate;
      case 'English':
        return Icons.menu_book;
      case 'Science':
        return Icons.science;
      default:
        return Icons.school;
    }
  }

  String _getSubjectDescription() {
    switch (widget.selectedSubject) {
      case 'Math':
        return 'Master numbers, operations, algebra, and problem-solving';
      case 'English':
        return 'Build vocabulary, grammar, and reading comprehension skills';
      case 'Science':
        return 'Explore biology, chemistry, physics, and earth science';
      default:
        return 'Choose your grade level to begin';
    }
  }

  String _getSubjectStats() {
    switch (widget.selectedSubject) {
      case 'Math':
        return '15+ Topics • 200+ Questions';
      case 'English':
        return '12+ Topics • 250+ Questions';
      case 'Science':
        return '8+ Topics • 200+ Questions';
      default:
        return 'Multiple topics available';
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Very Easy': return AppColors.mintGreen;
      case 'Easy': return Colors.green;
      case 'Medium': return AppColors.warningOrange;
      case 'Medium-Hard': return Colors.orange;
      case 'Hard': return AppColors.mathOrange;
      case 'Advanced': return AppColors.errorRed;
      case 'Expert': return AppColors.neonPurple;
      default: return Colors.grey;
    }
  }
}

class GradeLevel {
  final int grade;
  final String name;
  final String ageRange;
  final Color color;
  final IconData icon;
  final String difficulty;
  final List<String> topics;

  GradeLevel({
    required this.grade,
    required this.name,
    required this.ageRange,
    required this.color,
    required this.icon,
    required this.difficulty,
    required this.topics,
  });
}
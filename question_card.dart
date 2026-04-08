import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final String? imageUrl;
  final int currentQuestion;
  final int totalQuestions;
  final int points;
  final String? subject;
  final String? difficulty;

  const QuestionCard({
    super.key,
    required this.question,
    this.imageUrl,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.points,
    this.subject,
    this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, AppColors.backgroundLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row with question number and points
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.neonBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.quiz, size: 14, color: AppColors.neonBlue),
                    const SizedBox(width: 6),
                    Text(
                      "Q$currentQuestion/$totalQuestions",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neonBlue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Text(
                      "+$points",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Subject and difficulty badges (if provided)
          if (subject != null || difficulty != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (subject != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getSubjectColor(subject!).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getSubjectIcon(subject!), size: 12, color: _getSubjectColor(subject!)),
                          const SizedBox(width: 4),
                          Text(
                            subject!,
                            style: TextStyle(
                              fontSize: 11,
                              color: _getSubjectColor(subject!),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (difficulty != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(difficulty!).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getDifficultyIcon(difficulty!), size: 12, color: _getDifficultyColor(difficulty!)),
                          const SizedBox(width: 4),
                          Text(
                            difficulty!,
                            style: TextStyle(
                              fontSize: 11,
                              color: _getDifficultyColor(difficulty!),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          
          // Question image if provided
          if (imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
          
          // Question text
          Text(
            question,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.neonPurple,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().slideY(begin: 0.3, end: 0).fadeIn();
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Math': return AppColors.mathOrange;
      case 'English': return AppColors.englishGreen;
      case 'Science': return AppColors.sciencePurple;
      default: return AppColors.neonBlue;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Math': return Icons.calculate;
      case 'English': return Icons.menu_book;
      case 'Science': return Icons.science;
      default: return Icons.quiz;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy': return AppColors.mintGreen;
      case 'Medium': return AppColors.warningOrange;
      case 'Hard': return AppColors.mathOrange;
      case 'Expert': return AppColors.neonPurple;
      default: return AppColors.neonBlue;
    }
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty) {
      case 'Easy': return Icons.sentiment_satisfied;
      case 'Medium': return Icons.sentiment_neutral;
      case 'Hard': return Icons.sentiment_very_dissatisfied;
      case 'Expert': return Icons.psychology;
      default: return Icons.help;
    }
  }
}

// Compact question card for review screens
class CompactQuestionCard extends StatelessWidget {
  final String question;
  final int number;
  final bool isAnswered;
  final bool isCorrect;
  final VoidCallback onTap;

  const CompactQuestionCard({
    super.key,
    required this.question,
    required this.number,
    required this.isAnswered,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAnswered
                ? (isCorrect ? AppColors.mintGreen : AppColors.errorRed)
                : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isAnswered
                    ? (isCorrect ? AppColors.mintGreen : AppColors.errorRed)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isAnswered ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isAnswered)
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                size: 20,
                color: isCorrect ? AppColors.mintGreen : AppColors.errorRed,
              ),
          ],
        ),
      ),
    );
  }
}

// Result card for showing answer results
class ResultCard extends StatelessWidget {
  final bool isCorrect;
  final int pointsEarned;
  final String? correctAnswer;
  final String? explanation;

  const ResultCard({
    super.key,
    required this.isCorrect,
    required this.pointsEarned,
    this.correctAnswer,
    this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCorrect
              ? [AppColors.mintGreen.withValues(alpha: 0.1), Colors.white]
              : [AppColors.errorRed.withValues(alpha: 0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCorrect ? AppColors.mintGreen : AppColors.errorRed,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            size: 50,
            color: isCorrect ? AppColors.mintGreen : AppColors.errorRed,
          ),
          const SizedBox(height: 12),
          Text(
            isCorrect ? 'Correct!' : 'Incorrect',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isCorrect ? AppColors.mintGreen : AppColors.errorRed,
            ),
          ),
          const SizedBox(height: 8),
          if (isCorrect)
            Text(
              '+$pointsEarned points',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
              ),
            ),
          if (correctAnswer != null && !isCorrect) ...[
            const Text(
              'Correct Answer:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              correctAnswer!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
          if (explanation != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explanation:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    explanation!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().scale(duration: 300.ms).fadeIn();
  }
}

// Hint card
class HintCard extends StatelessWidget {
  final String hint;
  final int hintsRemaining;
  final VoidCallback onUseHint;

  const HintCard({
    super.key,
    required this.hint,
    required this.hintsRemaining,
    required this.onUseHint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold.withValues(alpha: 0.1), AppColors.warningOrange.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: AppColors.gold, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Need a Hint?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$hintsRemaining left',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hint,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: hintsRemaining > 0 ? onUseHint : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Use Hint',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/question_card.dart';
import '../../widgets/answer_button.dart';
import '../../widgets/timer_widget.dart';
import 'game_result_screen.dart';

class ScienceGameScreen extends StatefulWidget {
  final int gradeLevel;
  final int level;
  
  const ScienceGameScreen({
    super.key,
    this.gradeLevel = 3,
    this.level = 1,
  });

  @override
  State<ScienceGameScreen> createState() => _ScienceGameScreenState();
}

class _ScienceGameScreenState extends State<ScienceGameScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _bounceController;
  late AnimationController _shakeController;
  
  int _currentIndex = 0;
  int _score = 0;
  int _lives = 3;
  int _multiplier = 1;
  int _combo = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _isGameOver = false;
  int _questionsAnswered = 0;
  bool _isCorrectAnswer = false;
  
  // Timer variables
  int _timeRemaining = 30;
  bool _timerActive = true;
  
  List<Map<String, dynamic>> _questions = [];
  final Random _random = Random();
  
  // ============ BIOLOGY QUESTIONS (Ages 6-11) ============
  final List<Map<String, dynamic>> _biologyQuestionsEasy = [
    {'text': 'What is the hardest natural substance?', 'options': ['Iron', 'Diamond', 'Gold', 'Platinum'], 'answer': 1, 'points': 10, 'category': 'Biology', 'difficulty': 'Easy', 'emoji': '💎'},
    {'text': 'What is the largest organ in the human body?', 'options': ['Heart', 'Brain', 'Liver', 'Skin'], 'answer': 3, 'points': 10, 'category': 'Biology', 'difficulty': 'Easy', 'emoji': '🧬'},
    {'text': 'What is the process of plants making food called?', 'options': ['Respiration', 'Photosynthesis', 'Digestion', 'Evaporation'], 'answer': 1, 'points': 10, 'category': 'Biology', 'difficulty': 'Easy', 'emoji': '🌱'},
    {'text': 'How many bones does an adult human have?', 'options': ['196', '206', '216', '226'], 'answer': 1, 'points': 10, 'category': 'Biology', 'difficulty': 'Easy', 'emoji': '🦴'},
    {'text': 'What is the fastest animal on land?', 'options': ['Lion', 'Cheetah', 'Leopard', 'Horse'], 'answer': 1, 'points': 10, 'category': 'Biology', 'difficulty': 'Easy', 'emoji': '🐆'},
    {'text': 'What is the largest mammal on Earth?', 'options': ['Elephant', 'Blue Whale', 'Giraffe', 'Great White Shark'], 'answer': 1, 'points': 10, 'category': 'Biology', 'difficulty': 'Easy', 'emoji': '🐋'},
    {'text': 'What do bees produce?', 'options': ['Milk', 'Honey', 'Wax', 'Silk'], 'answer': 1, 'points': 10, 'category': 'Biology', 'difficulty': 'Easy', 'emoji': '🐝'},
    {'text': 'What is the tallest animal?', 'options': ['Elephant', 'Giraffe', 'Rhino', 'Hippo'], 'answer': 1, 'points': 10, 'category': 'Biology', 'difficulty': 'Easy', 'emoji': '🦒'},
    {'text': 'What part of the plant conducts photosynthesis?', 'options': ['Roots', 'Stem', 'Leaves', 'Flowers'], 'answer': 2, 'points': 10, 'category': 'Biology', 'difficulty': 'Easy', 'emoji': '🍃'},
    {'text': 'What is the study of living things called?', 'options': ['Physics', 'Chemistry', 'Biology', 'Geology'], 'answer': 2, 'points': 10, 'category': 'Biology', 'difficulty': 'Easy', 'emoji': '🔬'},
  ];
  
  // ============ BIOLOGY QUESTIONS (Ages 12-16) ============
  final List<Map<String, dynamic>> _biologyQuestionsHard = [
    {'text': 'What is the powerhouse of the cell?', 'options': ['Nucleus', 'Mitochondria', 'Ribosome', 'Chloroplast'], 'answer': 1, 'points': 15, 'category': 'Biology', 'difficulty': 'Hard', 'emoji': '⚡'},
    {'text': 'What is the function of red blood cells?', 'options': ['Fight infection', 'Carry oxygen', 'Clot blood', 'Digest food'], 'answer': 1, 'points': 15, 'category': 'Biology', 'difficulty': 'Hard', 'emoji': '🩸'},
    {'text': 'What is DNA short for?', 'options': ['Deoxyribonucleic Acid', 'Ribonucleic Acid', 'Deoxynucleic Acid', 'Ribonuclear Acid'], 'answer': 0, 'points': 15, 'category': 'Biology', 'difficulty': 'Hard', 'emoji': '🧬'},
    {'text': 'Which organ produces insulin?', 'options': ['Liver', 'Kidney', 'Pancreas', 'Heart'], 'answer': 2, 'points': 15, 'category': 'Biology', 'difficulty': 'Hard', 'emoji': '🩺'},
    {'text': 'What is the process of cell division called?', 'options': ['Mitosis', 'Meiosis', 'Cytosis', 'Phagocytosis'], 'answer': 0, 'points': 15, 'category': 'Biology', 'difficulty': 'Hard', 'emoji': '🔬'},
    {'text': 'What is the human body\'s largest artery?', 'options': ['Carotid', 'Aorta', 'Femoral', 'Coronary'], 'answer': 1, 'points': 15, 'category': 'Biology', 'difficulty': 'Hard', 'emoji': '❤️'},
    {'text': 'What vitamin is produced by the skin when exposed to sunlight?', 'options': ['Vitamin A', 'Vitamin C', 'Vitamin D', 'Vitamin E'], 'answer': 2, 'points': 15, 'category': 'Biology', 'difficulty': 'Hard', 'emoji': '☀️'},
    {'text': 'What is the scientific name for the voice box?', 'options': ['Trachea', 'Larynx', 'Pharynx', 'Esophagus'], 'answer': 1, 'points': 15, 'category': 'Biology', 'difficulty': 'Hard', 'emoji': '🗣️'},
  ];
  
  // ============ CHEMISTRY QUESTIONS (Ages 6-11) ============
  final List<Map<String, dynamic>> _chemistryQuestionsEasy = [
    {'text': 'What is the chemical symbol for water?', 'options': ['O2', 'CO2', 'H2O', 'NaCl'], 'answer': 2, 'points': 10, 'category': 'Chemistry', 'difficulty': 'Easy', 'emoji': '💧'},
    {'text': 'What is the boiling point of water?', 'options': ['0°C', '50°C', '100°C', '212°C'], 'answer': 2, 'points': 10, 'category': 'Chemistry', 'difficulty': 'Easy', 'emoji': '🌡️'},
    {'text': 'What gas do humans breathe in?', 'options': ['Carbon Dioxide', 'Nitrogen', 'Oxygen', 'Hydrogen'], 'answer': 2, 'points': 10, 'category': 'Chemistry', 'difficulty': 'Easy', 'emoji': '💨'},
    {'text': 'What is the freezing point of water?', 'options': ['0°C', '32°C', '100°C', '-10°C'], 'answer': 0, 'points': 10, 'category': 'Chemistry', 'difficulty': 'Easy', 'emoji': '❄️'},
    {'text': 'What is the chemical symbol for Gold?', 'options': ['Go', 'Gd', 'Au', 'Ag'], 'answer': 2, 'points': 10, 'category': 'Chemistry', 'difficulty': 'Easy', 'emoji': '🥇'},
    {'text': 'What gas do plants absorb from the air?', 'options': ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'], 'answer': 1, 'points': 10, 'category': 'Chemistry', 'difficulty': 'Easy', 'emoji': '🌿'},
    {'text': 'What is the chemical symbol for Oxygen?', 'options': ['O', 'Ox', 'Om', 'On'], 'answer': 0, 'points': 10, 'category': 'Chemistry', 'difficulty': 'Easy', 'emoji': '🔴'},
    {'text': 'What is the chemical symbol for Sodium?', 'options': ['So', 'Sd', 'Na', 'N'], 'answer': 2, 'points': 10, 'category': 'Chemistry', 'difficulty': 'Easy', 'emoji': '🧂'},
  ];
  
  // ============ CHEMISTRY QUESTIONS (Ages 12-16) ============
  final List<Map<String, dynamic>> _chemistryQuestionsHard = [
    {'text': 'What is the atomic number of Carbon?', 'options': ['4', '6', '8', '12'], 'answer': 1, 'points': 15, 'category': 'Chemistry', 'difficulty': 'Hard', 'emoji': '⚛️'},
    {'text': 'What is the pH of pure water?', 'options': ['5', '6', '7', '8'], 'answer': 2, 'points': 15, 'category': 'Chemistry', 'difficulty': 'Hard', 'emoji': '💧'},
    {'text': 'What is the chemical formula for table salt?', 'options': ['NaCl', 'KCl', 'CaCl2', 'MgCl2'], 'answer': 0, 'points': 15, 'category': 'Chemistry', 'difficulty': 'Hard', 'emoji': '🧂'},
    {'text': 'What is the most abundant element in the Earth\'s crust?', 'options': ['Silicon', 'Iron', 'Oxygen', 'Aluminum'], 'answer': 2, 'points': 15, 'category': 'Chemistry', 'difficulty': 'Hard', 'emoji': '🌍'},
    {'text': 'What is the chemical symbol for Iron?', 'options': ['Ir', 'Fe', 'In', 'I'], 'answer': 1, 'points': 15, 'category': 'Chemistry', 'difficulty': 'Hard', 'emoji': '🔩'},
    {'text': 'What is the process of a solid turning directly into a gas called?', 'options': ['Evaporation', 'Condensation', 'Sublimation', 'Deposition'], 'answer': 2, 'points': 15, 'category': 'Chemistry', 'difficulty': 'Hard', 'emoji': '💨'},
    {'text': 'What is the periodic table arranged by?', 'options': ['Mass', 'Atomic number', 'Density', 'Volume'], 'answer': 1, 'points': 15, 'category': 'Chemistry', 'difficulty': 'Hard', 'emoji': '📊'},
    {'text': 'What is the chemical formula for methane?', 'options': ['CH4', 'CO2', 'C2H6', 'C6H12O6'], 'answer': 0, 'points': 15, 'category': 'Chemistry', 'difficulty': 'Hard', 'emoji': '🔥'},
  ];
  
  // ============ PHYSICS QUESTIONS (Ages 6-11) ============
  final List<Map<String, dynamic>> _physicsQuestionsEasy = [
    {'text': 'What is the closest star to Earth?', 'options': ['Proxima Centauri', 'The Moon', 'The Sun', 'Sirius'], 'answer': 2, 'points': 10, 'category': 'Physics', 'difficulty': 'Easy', 'emoji': '⭐'},
    {'text': 'What planet is known as the Red Planet?', 'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'], 'answer': 1, 'points': 10, 'category': 'Physics', 'difficulty': 'Easy', 'emoji': '🔴'},
    {'text': 'What causes day and night?', 'options': ['Earth orbiting the Sun', 'Earth rotating on its axis', 'The Moon orbiting Earth', 'The Sun moving around Earth'], 'answer': 1, 'points': 10, 'category': 'Physics', 'difficulty': 'Easy', 'emoji': '🌍'},
    {'text': 'What is the force that pulls objects toward Earth?', 'options': ['Magnetism', 'Friction', 'Gravity', 'Electricity'], 'answer': 2, 'points': 10, 'category': 'Physics', 'difficulty': 'Easy', 'emoji': '⬇️'},
    {'text': 'What is the largest planet in our solar system?', 'options': ['Saturn', 'Mars', 'Jupiter', 'Neptune'], 'answer': 2, 'points': 10, 'category': 'Physics', 'difficulty': 'Easy', 'emoji': '🪐'},
    {'text': 'What is the hottest planet in our solar system?', 'options': ['Mercury', 'Venus', 'Mars', 'Jupiter'], 'answer': 1, 'points': 10, 'category': 'Physics', 'difficulty': 'Easy', 'emoji': '🔥'},
    {'text': 'What is the speed of light?', 'options': ['300,000 km/s', '150,000 km/s', '1,000,000 km/s', '500,000 km/s'], 'answer': 0, 'points': 10, 'category': 'Physics', 'difficulty': 'Easy', 'emoji': '⚡'},
    {'text': 'What is the unit of force?', 'options': ['Watt', 'Joule', 'Newton', 'Pascal'], 'answer': 2, 'points': 10, 'category': 'Physics', 'difficulty': 'Easy', 'emoji': '💪'},
  ];
  
  // ============ PHYSICS QUESTIONS (Ages 12-16) ============
  final List<Map<String, dynamic>> _physicsQuestionsHard = [
    {'text': 'What is Newton\'s first law also known as?', 'options': ['Law of Acceleration', 'Law of Inertia', 'Law of Action-Reaction', 'Law of Gravity'], 'answer': 1, 'points': 15, 'category': 'Physics', 'difficulty': 'Hard', 'emoji': '🍎'},
    {'text': 'What is the formula for calculating speed?', 'options': ['Distance × Time', 'Distance / Time', 'Time / Distance', 'Distance + Time'], 'answer': 1, 'points': 15, 'category': 'Physics', 'difficulty': 'Hard', 'emoji': '📐'},
    {'text': 'What is the unit of electrical resistance?', 'options': ['Volt', 'Ampere', 'Ohm', 'Watt'], 'answer': 2, 'points': 15, 'category': 'Physics', 'difficulty': 'Hard', 'emoji': '⚡'},
    {'text': 'What is the acceleration due to gravity on Earth?', 'options': ['8.9 m/s²', '9.8 m/s²', '10.8 m/s²', '11.8 m/s²'], 'answer': 1, 'points': 15, 'category': 'Physics', 'difficulty': 'Hard', 'emoji': '🌍'},
    {'text': 'What is the law of conservation of energy?', 'options': ['Energy is created', 'Energy is destroyed', 'Energy cannot be created or destroyed', 'Energy transforms into mass'], 'answer': 2, 'points': 15, 'category': 'Physics', 'difficulty': 'Hard', 'emoji': '⚡'},
    {'text': 'What is the speed of sound in air at room temperature?', 'options': ['343 m/s', '300 m/s', '400 m/s', '250 m/s'], 'answer': 0, 'points': 15, 'category': 'Physics', 'difficulty': 'Hard', 'emoji': '🔊'},
    {'text': 'What is the unit of power?', 'options': ['Joule', 'Newton', 'Watt', 'Pascal'], 'answer': 2, 'points': 15, 'category': 'Physics', 'difficulty': 'Hard', 'emoji': '💡'},
    {'text': 'What is the phenomenon of light bending called?', 'options': ['Reflection', 'Refraction', 'Diffraction', 'Dispersion'], 'answer': 1, 'points': 15, 'category': 'Physics', 'difficulty': 'Hard', 'emoji': '🌈'},
  ];
  
  // ============ EARTH SCIENCE QUESTIONS (Ages 6-11) ============
  final List<Map<String, dynamic>> _earthScienceQuestionsEasy = [
    {'text': 'What is the layer of air surrounding Earth called?', 'options': ['Hydrosphere', 'Lithosphere', 'Atmosphere', 'Biosphere'], 'answer': 2, 'points': 10, 'category': 'Earth Science', 'difficulty': 'Easy', 'emoji': '🌬️'},
    {'text': 'What is the hardest rock?', 'options': ['Limestone', 'Marble', 'Diamond', 'Granite'], 'answer': 2, 'points': 10, 'category': 'Earth Science', 'difficulty': 'Easy', 'emoji': '💎'},
    {'text': 'What percentage of Earth is covered by water?', 'options': ['51%', '61%', '71%', '81%'], 'answer': 2, 'points': 10, 'category': 'Earth Science', 'difficulty': 'Easy', 'emoji': '💧'},
    {'text': 'What is the hottest layer of the Earth?', 'options': ['Crust', 'Mantle', 'Outer Core', 'Inner Core'], 'answer': 3, 'points': 10, 'category': 'Earth Science', 'difficulty': 'Easy', 'emoji': '🔥'},
    {'text': 'What type of rock is formed from cooled magma?', 'options': ['Sedimentary', 'Metamorphic', 'Igneous', 'Fossil'], 'answer': 2, 'points': 10, 'category': 'Earth Science', 'difficulty': 'Easy', 'emoji': '🪨'},
  ];
  
  // ============ EARTH SCIENCE QUESTIONS (Ages 12-16) ============
  final List<Map<String, dynamic>> _earthScienceQuestionsHard = [
    {'text': 'What is the study of earthquakes called?', 'options': ['Meteorology', 'Seismology', 'Geology', 'Volcanology'], 'answer': 1, 'points': 15, 'category': 'Earth Science', 'difficulty': 'Hard', 'emoji': '🌋'},
    {'text': 'What is the theory that continents move called?', 'options': ['Continental Drift', 'Plate Tectonics', 'Seafloor Spreading', 'Subduction'], 'answer': 0, 'points': 15, 'category': 'Earth Science', 'difficulty': 'Hard', 'emoji': '🌏'},
    {'text': 'What is the greenhouse effect?', 'options': ['Trapping heat in the atmosphere', 'Cooling the Earth', 'Creating ozone', 'Blocking sunlight'], 'answer': 0, 'points': 15, 'category': 'Earth Science', 'difficulty': 'Hard', 'emoji': '🌡️'},
    {'text': 'What is the most abundant gas in Earth\'s atmosphere?', 'options': ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Argon'], 'answer': 2, 'points': 15, 'category': 'Earth Science', 'difficulty': 'Hard', 'emoji': '💨'},
    {'text': 'What is the deepest part of the ocean called?', 'options': ['Mariana Trench', 'Puerto Rico Trench', 'Philippine Trench', 'Tonga Trench'], 'answer': 0, 'points': 15, 'category': 'Earth Science', 'difficulty': 'Hard', 'emoji': '🌊'},
    {'text': 'What is the layer of the atmosphere where weather occurs?', 'options': ['Stratosphere', 'Mesosphere', 'Troposphere', 'Thermosphere'], 'answer': 2, 'points': 15, 'category': 'Earth Science', 'difficulty': 'Hard', 'emoji': '⛅'},
    {'text': 'What is the process of rocks breaking down called?', 'options': ['Erosion', 'Weathering', 'Deposition', 'Compaction'], 'answer': 1, 'points': 15, 'category': 'Earth Science', 'difficulty': 'Hard', 'emoji': '🪨'},
    {'text': 'What is the name of the supercontinent that existed millions of years ago?', 'options': ['Gondwana', 'Laurasia', 'Pangaea', 'Rodinia'], 'answer': 2, 'points': 15, 'category': 'Earth Science', 'difficulty': 'Hard', 'emoji': '🌎'},
  ];
  
  // ============ SPACE SCIENCE QUESTIONS (Ages 12-16) ============
  final List<Map<String, dynamic>> _spaceQuestionsHard = [
    {'text': 'What is a black hole?', 'options': ['A hole in space', 'A region with extreme gravity', 'A dead star', 'A dark planet'], 'answer': 1, 'points': 20, 'category': 'Space Science', 'difficulty': 'Hard', 'emoji': '🕳️'},
    {'text': 'What is the name of the first man on the moon?', 'options': ['Buzz Aldrin', 'Neil Armstrong', 'Michael Collins', 'Yuri Gagarin'], 'answer': 1, 'points': 15, 'category': 'Space Science', 'difficulty': 'Hard', 'emoji': '👨‍🚀'},
    {'text': 'What is the Milky Way?', 'options': ['A candy bar', 'Our galaxy', 'A star', 'A planet'], 'answer': 1, 'points': 15, 'category': 'Space Science', 'difficulty': 'Hard', 'emoji': '🌌'},
    {'text': 'What is a supernova?', 'options': ['A new star', 'An exploding star', 'A black hole', 'A comet'], 'answer': 1, 'points': 20, 'category': 'Space Science', 'difficulty': 'Hard', 'emoji': '💥'},
    {'text': 'What is the name of the largest volcano in the solar system?', 'options': ['Mount Everest', 'Mauna Loa', 'Olympus Mons', 'Mount Fuji'], 'answer': 2, 'points': 20, 'category': 'Space Science', 'difficulty': 'Hard', 'emoji': '🌋'},
  ];
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _generateQuestions();
    _startTimer();
  }
  
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timerActive && !_isGameOver && !_showResult) {
        setState(() {
          if (_timeRemaining > 0) {
            _timeRemaining--;
            _startTimer();
          } else {
            _handleTimeout();
          }
        });
      }
    });
  }
  
  void _handleTimeout() {
    if (_showResult || _isGameOver) return;
    
    setState(() {
      _showResult = true;
      _lives--;
      _combo = 0;
      _multiplier = 1;
      _selectedAnswer = null;
      _isCorrectAnswer = false;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (_lives <= 0) {
          _endGame(false);
        } else if (_currentIndex + 1 >= _questions.length) {
          _endGame(true);
        } else {
          setState(() {
            _currentIndex++;
            _showResult = false;
            _selectedAnswer = null;
            _timeRemaining = 30;
            _timerActive = true;
          });
          _startTimer();
        }
      }
    });
  }
  
  void _generateQuestions() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    // Generate age-appropriate science questions
    if (auth.userAge >= 12) {
      // For ages 12-16: Include advanced Biology, Chemistry, Physics, Earth Science, and Space
      _questions = _generateAdvancedScienceQuestions(10);
    } else {
      // For younger children: Basic Biology, Chemistry, Physics, and Earth Science
      _questions = _generateBasicScienceQuestions(10);
    }
  }
  
  List<Map<String, dynamic>> _generateBasicScienceQuestions(int count) {
    final questions = <Map<String, dynamic>>[];
    
    // Mix of basic science categories
    final allQuestions = <Map<String, dynamic>>[];
    allQuestions.addAll(_biologyQuestionsEasy.take(4));
    allQuestions.addAll(_chemistryQuestionsEasy.take(3));
    allQuestions.addAll(_physicsQuestionsEasy.take(4));
    allQuestions.addAll(_earthScienceQuestionsEasy.take(3));
    allQuestions.shuffle(_random);
    
    for (int i = 0; i < count && i < allQuestions.length; i++) {
      questions.add(allQuestions[i]);
    }
    
    return questions;
  }
  
  List<Map<String, dynamic>> _generateAdvancedScienceQuestions(int count) {
    final questions = <Map<String, dynamic>>[];
    
    // Mix of advanced science categories
    final allQuestions = <Map<String, dynamic>>[];
    allQuestions.addAll(_biologyQuestionsHard);
    allQuestions.addAll(_chemistryQuestionsHard);
    allQuestions.addAll(_physicsQuestionsHard);
    allQuestions.addAll(_earthScienceQuestionsHard);
    allQuestions.addAll(_spaceQuestionsHard);
    allQuestions.shuffle(_random);
    
    for (int i = 0; i < count && i < allQuestions.length; i++) {
      questions.add(allQuestions[i]);
    }
    
    return questions;
  }
  
  void _checkAnswer(int index) {
    if (_showResult || _isGameOver) return;
    
    _timerActive = false;
    
    final bool isCorrect = index == (_questions[_currentIndex]['answer'] as int);
    _isCorrectAnswer = isCorrect;
    
    // Time bonus for quick answers
    int timeBonus = 0;
    if (isCorrect) {
      timeBonus = ((30 - _timeRemaining) ~/ 3) * 2;
    }
    
    setState(() {
      _showResult = true;
      _selectedAnswer = index;
      _questionsAnswered++;
      
      if (isCorrect) {
        int points = (_questions[_currentIndex]['points'] as int) * _multiplier + timeBonus;
        _score += points;
        _combo++;
        _multiplier = (_combo ~/ 3) + 1;
        _confettiController.play();
        _bounceController.forward().then((_) => _bounceController.reverse());
      } else {
        _lives--;
        _combo = 0;
        _multiplier = 1;
        _shakeController.forward().then((_) => _shakeController.reverse());
      }
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (_lives <= 0) {
          _endGame(false);
        } else if (_currentIndex + 1 >= _questions.length) {
          _endGame(true);
        } else {
          setState(() {
            _currentIndex++;
            _showResult = false;
            _selectedAnswer = null;
            _timeRemaining = 30;
            _timerActive = true;
          });
          _startTimer();
        }
      }
    });
  }
  
  void _endGame(bool victory) async {
    _isGameOver = true;
    _timerActive = false;
    
    if (victory) {
      await Provider.of<GameProvider>(context, listen: false).addScore(_score, 'Science');
      
      // Check if level completed
      if (widget.level > 0) {
        await Provider.of<GameProvider>(context, listen: false).completeLevel(widget.level);
      }
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GameResultScreen(
              score: _score,
              isVictory: true,
              subject: 'Science',
              questionsAnswered: _questionsAnswered,
              totalQuestions: _questions.length,
              multiplier: _multiplier,
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GameResultScreen(
              score: _score,
              isVictory: false,
              subject: 'Science',
              questionsAnswered: _questionsAnswered,
              totalQuestions: _questions.length,
              multiplier: _multiplier,
            ),
          ),
        );
      }
    }
  }
  
  @override
  void dispose() {
    _confettiController.dispose();
    _bounceController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final q = _questions[_currentIndex];
    final category = q['category'] as String? ?? 'Science';
    final difficulty = q['difficulty'] as String? ?? 'Medium';
    final emoji = q['emoji'] as String? ?? '🔬';
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeController.value * 5 * (_isCorrectAnswer ? 0 : 1), 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.sciencePurple.withValues(alpha: 0.15), AppColors.backgroundLight],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(q, category, difficulty, emoji),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: QuestionCard(
                        question: q['text'],
                        currentQuestion: _currentIndex + 1,
                        totalQuestions: _questions.length,
                        points: (q['points'] as int) * _multiplier,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: q['options'].length,
                          itemBuilder: (ctx, i) {
                            final colors = [
                              AppColors.sciencePurple,
                              AppColors.mintGreen,
                              AppColors.warningOrange,
                              AppColors.bubblegumPink,
                            ];
                            return AnswerButton(
                              text: q['options'][i],
                              index: i,
                              color: colors[i % colors.length],
                              onPressed: () => _checkAnswer(i),
                              isSelected: _selectedAnswer == i,
                              showResult: _showResult,
                              isCorrect: i == q['answer'],
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        colors: const [
                          AppColors.gold,
                          AppColors.sciencePurple,
                          AppColors.mintGreen,
                          AppColors.warningOrange,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> q, String category, String difficulty, String emoji) {
    Color getDifficultyColor() {
      switch (difficulty) {
        case 'Easy': return AppColors.mintGreen;
        case 'Medium': return AppColors.warningOrange;
        case 'Hard': return AppColors.mathOrange;
        default: return AppColors.sciencePurple;
      }
    }
    
    IconData getCategoryIcon() {
      switch (category) {
        case 'Biology': return Icons.biotech;
        case 'Chemistry': return Icons.science;
        case 'Physics': return Icons.electric_bolt;
        case 'Earth Science': return Icons.public;
        case 'Space Science': return Icons.rocket;
        default: return Icons.science;
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.sciencePurple, Color(0xFFCE93D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Row(
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Science Lab',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.sciencePurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(getCategoryIcon(), size: 14, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      category,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: getDifficultyColor().withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      difficulty == 'Easy' ? Icons.sentiment_satisfied :
                      difficulty == 'Medium' ? Icons.sentiment_neutral :
                      Icons.sentiment_very_dissatisfied,
                      size: 14,
                      color: getDifficultyColor(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      difficulty,
                      style: TextStyle(color: getDifficultyColor(), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Lives:', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 10),
              ...List.generate(3, (i) => Icon(
                i < _lives ? Icons.favorite : Icons.favorite_border,
                color: AppColors.errorRed,
                size: 24,
              )),
              const Spacer(),
              TimerWidget(
                seconds: _timeRemaining,
                maxSeconds: 30,
                isActive: _timerActive && !_showResult && !_isGameOver,
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.white, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      'x$_multiplier',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
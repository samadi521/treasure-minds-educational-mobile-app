class LeaderboardEntry {
  final String userId;
  final String name;
  final int score;
  final int level;
  final String avatar;

  LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.score,
    required this.level,
    required this.avatar,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      avatar: json['avatar'] as String? ?? '?',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'score': score,
      'level': level,
      'avatar': avatar,
    };
  }
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int points;
  final DateTime? earnedAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.points,
    this.earnedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? 'emoji_events',
      points: json['points'] as int? ?? 0,
      earnedAt: json['earnedAt'] != null
          ? DateTime.parse(json['earnedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'points': points,
      'earnedAt': earnedAt?.toIso8601String(),
    };
  }

  bool get isEarned => earnedAt != null;
}

class DailyChallenge {
  final String userId;
  final String date;
  final bool completed;
  final int score;
  final DateTime? completedAt;

  DailyChallenge({
    required this.userId,
    required this.date,
    required this.completed,
    required this.score,
    this.completedAt,
  });

  factory DailyChallenge.fromJson(Map<String, dynamic> json) {
    return DailyChallenge(
      userId: json['userId'] as String? ?? '',
      date: json['date'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      score: json['score'] as int? ?? 0,
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] as dynamic).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'completed': completed,
      'score': score,
      'completedAt': completedAt,
    };
  }
}
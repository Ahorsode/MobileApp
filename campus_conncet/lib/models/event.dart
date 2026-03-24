class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String imageUrl;       // optional
  final double? latitude;      // optional
  final double? longitude;     // optional
  final String createdBy;      // user uid
  final List<String> likes;    // list of user ids who liked
  final List<Comment> comments;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl = '',
    this.latitude,
    this.longitude,
    required this.createdBy,
    this.likes = const [],
    this.comments = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'likes': likes,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }

  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      imageUrl: map['imageUrl'] ?? '',
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdBy: map['createdBy'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      comments: (map['comments'] as List?)
          ?.map((c) => Comment.fromMap(Map<String, dynamic>.from(c as Map)))
          .toList() ?? [],
    );
  }
}

class Comment {
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'userName': userName,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
  };

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'User',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
    );
  }
}

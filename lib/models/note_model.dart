class Note {
  final int? id;
  final int userId;
  final String title;

  Note({
    this.id,
    required this.userId,
    required this.title,
  });

  // Convertit un objet Note en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
    };
  }

  // Convertit une Map issue de SQLite en objet Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
    );
  }
}
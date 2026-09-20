class Note {
  final int? id;
  final String title;

  Note({
    this.id,
    required this.title,
  });

  // Convertit un objet Note en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  // Convertit une Map issue de SQLite en objet Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
    );
  }
}
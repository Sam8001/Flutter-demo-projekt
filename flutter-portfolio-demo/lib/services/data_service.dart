// Demo-Anpassung: Dieser Service ersetzt im Portfolio-Projekt die Supabase-Anbindung
// aus dem Original durch lokale Mock-Daten. Die Methodennamen bleiben erhalten,
// damit die UI-Struktur weitgehend unveraendert gezeigt werden kann.
class DataService {
  static final List<Map<String, dynamic>> _mockContents = [
    {
      'id': 1,
      'user_id': 'demo-user-1',
      'title': 'Algorithmen Lernzettel',
      'description': 'Zusammenfassung zu Sortierverfahren, Laufzeiten und Big-O-Notation.',
      'type': 'pdf',
      'file_url': 'https://example.com/mock/algorithmen-lernzettel.pdf',
      'thumbnail_url': '',
      'created_at': '2026-01-15T10:30:00.000Z',
      'tags': ['Summary', 'Exam'],
      'author': 'demo_student',
      'author_avatar': null,
      'author_id': 'demo-user-1',
      'course': 'Algorithmen und Datenstrukturen',
    },
    {
      'id': 2,
      'user_id': 'demo-user-2',
      'title': 'Datenbanken Uebungsblatt',
      'description': 'Beispielaufgaben zu SQL-Joins, Normalformen und Transaktionen.',
      'type': 'pdf',
      'file_url': 'https://example.com/mock/datenbanken-uebungsblatt.pdf',
      'thumbnail_url': '',
      'created_at': '2026-01-18T14:20:00.000Z',
      'tags': ['Homework', 'Lecture'],
      'author': 'study_mate',
      'author_avatar': null,
      'author_id': 'demo-user-2',
      'course': 'Datenbanken',
    },
    {
      'id': 3,
      'user_id': 'demo-user-1',
      'title': 'Flutter State Management Notizen',
      'description': 'Kurze Notizen zu StatefulWidget, setState und einfachen UI-Zustaenden.',
      'type': 'pdf',
      'file_url': 'https://example.com/mock/flutter-state-management.pdf',
      'thumbnail_url': '',
      'created_at': '2026-01-20T09:45:00.000Z',
      'tags': ['Summary', 'Lecture'],
      'author': 'demo_student',
      'author_avatar': null,
      'author_id': 'demo-user-1',
      'course': 'Mobile App Development',
    },
  ];

  Future<List<Map<String, dynamic>>> getFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List<Map<String, dynamic>>.from(_mockContents);
  }

  Future<List<Map<String, dynamic>>> getContentByCourse(String courseName) async {
    final feed = await getFeed();
    return feed.where((content) => content['course'] == courseName).toList();
  }

  Future<List<String>> getCourseNames() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final courses = _mockContents.map((content) => content['course'] as String).toSet().toList();
    courses.sort();
    return courses;
  }
}

class PrivacyPolicy {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Sections> sections; // List of Sections

  PrivacyPolicy({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.sections,
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    print(json);

    // Map the sections field from a JSON array to a List<Sections>
    var sectionsFromJson = json['sections'] as List;
    List<Sections> sectionsList =
        sectionsFromJson.map((i) => Sections.fromJson(i)).toList();

    return PrivacyPolicy(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      sections: sectionsList, // Assign the list to sections
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Sections {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Sections({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sections.fromJson(Map<String, dynamic> json) {
    return Sections(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

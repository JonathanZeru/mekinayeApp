class Rules {
  final int id;
  final String name;
  final String cityName;
  final String subCityName;
  final String countryName;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Rules({
    required this.id,
    required this.name,
    required this.cityName,
    required this.subCityName,
    required this.countryName,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Rules.fromJson(Map<String, dynamic> json) {
    return Rules(
      id: json['id'],
      name: json['name'],
      cityName: json['cityName'],
      subCityName: json['subCityName'],
      countryName: json['countryName'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

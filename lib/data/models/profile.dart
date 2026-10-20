class Profile {
  const Profile({
    required this.name,
    required this.role,
    required this.tagline,
    required this.location,
    required this.availability,
    required this.email,
    required this.github,
    required this.linkedin,
    required this.cv,
    required this.about,
    required this.stack,
    required this.experience,
  });

  final String name;
  final String role;
  final String tagline;
  final String location;
  final String availability;
  final String email;
  final String github;
  final String linkedin;

  /// PDF público del CV, sin teléfono. Vacío si todavía no está publicado.
  final String cv;
  final List<String> about;
  final List<String> stack;
  final List<Experience> experience;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      location: json['location'] as String? ?? '',
      availability: json['availability'] as String? ?? '',
      email: json['email'] as String? ?? '',
      github: json['github'] as String? ?? '',
      linkedin: json['linkedin'] as String? ?? '',
      cv: json['cv'] as String? ?? '',
      about: _stringList(json['about']),
      stack: _stringList(json['stack']),
      experience: (json['experience'] as List<dynamic>? ?? const [])
          .map((item) => Experience.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Experience {
  const Experience({
    required this.company,
    required this.role,
    required this.period,
    required this.description,
  });

  final String company;
  final String role;
  final String period;
  final String description;

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'] as String? ?? '',
      role: json['role'] as String? ?? '',
      period: json['period'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList();
}

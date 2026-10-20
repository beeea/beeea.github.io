class Project {
  const Project({
    required this.slug,
    required this.name,
    required this.type,
    required this.company,
    required this.year,
    required this.platforms,
    required this.summary,
    required this.description,
    required this.highlights,
    required this.stack,
    required this.featured,
    required this.anonymized,
    required this.links,
    this.media,
  });

  final String slug;
  final String name;

  /// "Empresa", "Personal", "Open source" o "Académico".
  final String type;
  final String company;
  final String year;
  final List<String> platforms;
  final String summary;
  final String description;
  final List<String> highlights;
  final List<String> stack;
  final bool featured;

  /// Si es true, el proyecto se muestra sin nombre de cliente ni capturas.
  final bool anonymized;
  final List<ProjectLink> links;

  /// Grabación o captura del proyecto, si existe.
  final ProjectMedia? media;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      company: json['company'] as String? ?? '',
      year: json['year'] as String? ?? '',
      platforms: _stringList(json['platforms']),
      summary: json['summary'] as String? ?? '',
      description: json['description'] as String? ?? '',
      highlights: _stringList(json['highlights']),
      stack: _stringList(json['stack']),
      featured: json['featured'] as bool? ?? false,
      anonymized: json['anonymized'] as bool? ?? false,
      links: (json['links'] as List<dynamic>? ?? const [])
          .map((item) => ProjectLink.fromJson(item as Map<String, dynamic>))
          .toList(),
      media: json['media'] == null
          ? null
          : ProjectMedia.fromJson(json['media'] as Map<String, dynamic>),
    );
  }
}

/// Imagen o GIF que acompaña a la ficha del proyecto.
class ProjectMedia {
  const ProjectMedia({required this.asset, required this.caption});

  final String asset;
  final String caption;

  factory ProjectMedia.fromJson(Map<String, dynamic> json) {
    return ProjectMedia(
      asset: json['asset'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }
}

class ProjectLink {
  const ProjectLink({required this.label, required this.url});

  final String label;
  final String url;

  factory ProjectLink.fromJson(Map<String, dynamic> json) {
    return ProjectLink(
      label: json['label'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList();
}

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile.dart';
import '../models/project.dart';

/// Carga el contenido del portfolio desde `assets/raw/*.json`.
///
/// Todo el contenido editable vive en JSON: para añadir o cambiar un proyecto
/// no hace falta tocar Dart.
class ContentRepository {
  const ContentRepository();

  static const String _profilePath = 'assets/raw/profile.json';
  static const String _projectsPath = 'assets/raw/projects.json';

  Future<Profile> loadProfile() async {
    final raw = await rootBundle.loadString(_profilePath);
    return Profile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<List<Project>> loadProjects() async {
    final raw = await rootBundle.loadString(_projectsPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final projects = decoded['projects'] as List<dynamic>? ?? const [];
    return projects
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => const ContentRepository(),
);

final profileProvider = FutureProvider<Profile>(
  (ref) => ref.read(contentRepositoryProvider).loadProfile(),
);

final projectsProvider = FutureProvider<List<Project>>(
  (ref) => ref.read(contentRepositoryProvider).loadProjects(),
);

final featuredProjectsProvider = Provider<AsyncValue<List<Project>>>((ref) {
  return ref.watch(projectsProvider).whenData(
        (projects) => projects.where((project) => project.featured).toList(),
      );
});

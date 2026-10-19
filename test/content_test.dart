import 'dart:convert';

import 'package:beatriz_portfolio/data/models/profile.dart';
import 'package:beatriz_portfolio/data/models/project.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('profile.json se parsea correctamente', () async {
    final raw = await rootBundle.loadString('assets/raw/profile.json');
    final profile = Profile.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    expect(profile.name, isNotEmpty);
    expect(profile.role, contains('Flutter'));
    expect(profile.email, contains('@'));
    expect(profile.stack, isNotEmpty);
    expect(profile.experience, isNotEmpty);
  });

  test('projects.json se parsea y todos los slugs son únicos', () async {
    final raw = await rootBundle.loadString('assets/raw/projects.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final projects = (decoded['projects'] as List<dynamic>)
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();

    expect(projects, isNotEmpty);
    final slugs = projects.map((project) => project.slug).toSet();
    expect(slugs.length, projects.length, reason: 'Los slugs deben ser únicos');

    for (final project in projects) {
      expect(project.name, isNotEmpty);
      expect(project.summary, isNotEmpty);
      expect(project.stack, isNotEmpty);
    }
  });

  test('los proyectos anonimizados no exponen enlaces de cliente', () async {
    final raw = await rootBundle.loadString('assets/raw/projects.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final projects = (decoded['projects'] as List<dynamic>)
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();

    for (final project in projects.where((project) => project.anonymized)) {
      expect(project.links, isEmpty);
    }
  });
}

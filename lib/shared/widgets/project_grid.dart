import 'package:flutter/material.dart';

import '../../data/models/project.dart';
import 'project_card.dart';

class ProjectGrid extends StatelessWidget {
  const ProjectGrid({super.key, required this.projects, this.maxColumns = 2});

  final List<Project> projects;
  final int maxColumns;

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return const Text('Todavía no hay proyectos para mostrar.');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 24.0;
        final fitsTwo = constraints.maxWidth >= 960 && maxColumns >= 2;
        final columns = fitsTwo ? 2 : 1;
        final itemWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final project in projects)
              SizedBox(
                width: itemWidth,
                child: ProjectCard(project: project),
              ),
          ],
        );
      },
    );
  }
}

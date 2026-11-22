import 'package:flutter/material.dart';

import '../../data/models/project.dart';
import 'project_card.dart';

/// Rejilla de proyectos en filas de como mucho dos columnas.
///
/// Se construye por filas (y no con un `Wrap`) para que las tarjetas de una
/// misma fila tengan la misma altura y el pie quede alineado. Si la última
/// fila se queda con una sola tarjeta, esa tarjeta ocupa todo el ancho y se
/// pinta en horizontal.
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

        final rows = <Widget>[];
        for (var start = 0; start < projects.length; start += columns) {
          final end = (start + columns).clamp(0, projects.length);
          final slice = projects.sublist(start, end);
          final lastOddRow = columns > 1 && slice.length == 1;

          rows.add(
            Padding(
              padding: EdgeInsets.only(
                bottom: end < projects.length ? spacing : 0,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < slice.length; i++) ...[
                      if (i > 0) const SizedBox(width: spacing),
                      Expanded(
                        child: ProjectCard(
                          project: slice[i],
                          wide: lastOddRow,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }

        return Column(children: rows);
      },
    );
  }
}

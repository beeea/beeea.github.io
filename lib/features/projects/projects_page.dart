import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/content_repository.dart';
import '../../shared/widgets/page_container.dart';
import '../../shared/widgets/project_grid.dart';
import '../../shared/widgets/section_title.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);

    return SingleChildScrollView(
      child: PageContainer(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Proyectos',
              subtitle:
                  'Una selección del trabajo en el que he participado: producto real, proyectos personales y ejercicios técnicos.',
            ),
            const SizedBox(height: 32),
            projects.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Text('No se pudieron cargar: $error'),
              data: (data) => ProjectGrid(projects: data),
            ),
          ],
        ),
      ),
    );
  }
}

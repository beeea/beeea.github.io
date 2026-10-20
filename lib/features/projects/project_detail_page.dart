import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/project.dart';
import '../../data/repositories/content_repository.dart';
import '../../shared/widgets/page_container.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/tag_chip.dart';

class ProjectDetailPage extends ConsumerWidget {
  const ProjectDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);

    return SingleChildScrollView(
      child: PageContainer(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: projects.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 64),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Text('No se pudo cargar el proyecto: $error'),
          data: (data) {
            final matches = data.where((project) => project.slug == slug);
            if (matches.isEmpty) {
              return const _MissingProject();
            }
            return _ProjectDetail(project: matches.first);
          },
        ),
      ),
    );
  }
}

class _ProjectDetail extends StatelessWidget {
  const _ProjectDetail({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => context.go('/proyectos'),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('Todos los proyectos'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            TagChip(label: project.type, highlighted: true),
            const SizedBox(width: 8),
            if (project.year.isNotEmpty) TagChip(label: project.year),
            const SizedBox(width: 8),
            for (final platform in project.platforms) ...[
              TagChip(label: platform),
              const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 20),
        Text(
          project.name,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          project.summary,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        if (project.anonymized) ...[
          const SizedBox(height: 16),
          Card(
            color: theme.colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 20,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Caso anonimizado por confidencialidad con el cliente. '
                      'No se publican nombre, capturas ni métricas internas.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 40),
        if (project.media != null) ...[
          Center(
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    project.media!.asset,
                    fit: BoxFit.contain,
                    semanticLabel: project.media!.caption,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  project.media!.caption,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
        Text(
          project.description,
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
        ),
        const SizedBox(height: 48),
        if (project.highlights.isNotEmpty) ...[
          const SectionTitle(title: 'Qué hice'),
          const SizedBox(height: 16),
          for (final highlight in project.highlights) ...[
            _Bullet(text: highlight),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 40),
        ],
        const SectionTitle(title: 'Stack'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tech in project.stack) TagChip(label: tech),
          ],
        ),
        if (project.links.isNotEmpty) ...[
          const SizedBox(height: 40),
          const SectionTitle(title: 'Enlaces'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final link in project.links)
                OutlinedButton.icon(
                  onPressed: () => _open(link.url),
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: Text(link.label),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(
            Icons.check_circle_outline,
            size: 18,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
        ),
      ],
    );
  }
}

class _MissingProject extends StatelessWidget {
  const _MissingProject();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Proyecto no encontrado',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => context.go('/proyectos'),
          child: const Text('Volver a proyectos'),
        ),
      ],
    );
  }
}

Future<void> _open(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/profile.dart';
import '../../data/repositories/content_repository.dart';
import '../../shared/widgets/page_container.dart';
import '../../shared/widgets/project_grid.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/tag_chip.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final featured = ref.watch(featuredProjectsProvider);

    return SingleChildScrollView(
      child: PageContainer(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: profile.when(
          loading: () => const _Loader(),
          error: (error, _) => _ErrorBox(message: '$error'),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Hero(profile: data),
              const SizedBox(height: 72),
              const SectionTitle(
                title: 'Proyectos destacados',
                subtitle: 'Trabajo real, con contexto y decisiones técnicas.',
              ),
              const SizedBox(height: 24),
              featured.when(
                loading: () => const _Loader(),
                error: (error, _) => _ErrorBox(message: '$error'),
                data: (projects) => ProjectGrid(projects: projects),
              ),
              const SizedBox(height: 72),
              const SectionTitle(title: 'Stack'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tech in data.stack) TagChip(label: tech),
                ],
              ),
              const SizedBox(height: 72),
              const SectionTitle(title: 'Experiencia'),
              const SizedBox(height: 16),
              for (final experience in data.experience) ...[
                _ExperienceCard(experience: experience),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 60),
              _Footer(profile: data),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.surfaceContainerHighest],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.name,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            profile.role,
            style: theme.textTheme.titleLarge?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              profile.tagline,
              style: theme.textTheme.titleMedium?.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TagChip(label: profile.location, highlighted: true),
              TagChip(label: profile.availability),
            ],
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () => context.go('/proyectos'),
                icon: const Icon(Icons.grid_view_outlined),
                label: const Text('Ver proyectos'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/contacto'),
                icon: const Icon(Icons.mail_outline),
                label: const Text('Hablemos'),
              ),
              TextButton.icon(
                onPressed: () => _open(profile.linkedin),
                icon: const Icon(Icons.business_center_outlined),
                label: const Text('LinkedIn'),
              ),
              TextButton.icon(
                onPressed: () => _open(profile.github),
                icon: const Icon(Icons.code),
                label: const Text('GitHub'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.role,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        experience.company,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                TagChip(label: experience.period),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              experience.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            TextButton(
              onPressed: () => _open(profile.email, email: true),
              child: Text(profile.email),
            ),
            TextButton(
              onPressed: () => _open(profile.linkedin),
              child: const Text('LinkedIn'),
            ),
            TextButton(
              onPressed: () => _open(profile.github),
              child: const Text('GitHub'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '© ${DateTime.now().year} ${profile.name}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('No se pudo cargar el contenido: $message'),
      ),
    );
  }
}

Future<void> _open(String value, {bool email = false}) async {
  final uri = email ? Uri(scheme: 'mailto', path: value) : Uri.tryParse(value);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/content_repository.dart';
import '../../shared/widgets/page_container.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/tag_chip.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: PageContainer(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: profile.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 64),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Text('No se pudo cargar el perfil: $error'),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Sobre mí'),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final paragraph in data.about) ...[
                      Text(
                        paragraph,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 48),
              const SectionTitle(title: 'Experiencia'),
              const SizedBox(height: 16),
              for (final experience in data.experience) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '${experience.role} · ${experience.company}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
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
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 40),
              const SectionTitle(title: 'Stack'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tech in data.stack) TagChip(label: tech),
                ],
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: () => context.go('/contacto'),
                icon: const Icon(Icons.mail_outline),
                label: const Text('Hablemos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

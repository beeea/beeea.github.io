import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/content_repository.dart';
import '../../shared/widgets/chunky_button.dart';
import '../../shared/widgets/hard_card.dart';
import '../../shared/widgets/page_container.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/site_footer.dart';
import '../../shared/widgets/tag_chip.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return SingleChildScrollView(
      child: PageContainer(
        maxWidth: 960,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: profile.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 64),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Text('No se pudo cargar el perfil: $error'),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                kicker: '01 — quién soy',
                title: 'Sobre mí',
              ),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final paragraph in data.about) ...[
                      Text(
                        paragraph,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: palette.inkSoft,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 56),
              const SectionTitle(
                kicker: '02 — trayectoria',
                title: 'Experiencia',
              ),
              const SizedBox(height: 20),
              for (final experience in data.experience) ...[
                HardCard(
                  padding: const EdgeInsets.all(22),
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
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  experience.company,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: palette.violet,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          TagChip(label: experience.period),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        experience.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: palette.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 48),
              const SectionTitle(
                kicker: '03 — herramientas',
                title: 'Stack',
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tech in data.stack) TagChip(label: tech),
                ],
              ),
              const SizedBox(height: 56),
              ChunkyButton(
                label: 'Hablemos',
                icon: Icons.mail_outline,
                onPressed: () => context.go('/contacto'),
              ),
              const SizedBox(height: 56),
              SiteFooter(
                profile: data,
                onLink: (url) async {
                  final uri = Uri.tryParse(url);
                  if (uri == null) return;
                  await launchUrl(uri,
                      mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

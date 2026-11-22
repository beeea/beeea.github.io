import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/profile.dart';
import '../../data/repositories/content_repository.dart';
import '../../shared/widgets/chunky_button.dart';
import '../../shared/widgets/dashed_divider.dart';
import '../../shared/widgets/hard_card.dart';
import '../../shared/widgets/page_container.dart';
import '../../shared/widgets/project_grid.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/site_footer.dart';
import '../../shared/widgets/sticker.dart';
import '../../shared/widgets/tag_chip.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final featured = ref.watch(featuredProjectsProvider);

    return SingleChildScrollView(
      child: PageContainer(
        maxWidth: 1160,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: profile.when(
          loading: () => const _Loader(),
          error: (error, _) => _ErrorBox(message: '$error'),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Hero(profile: data),
              const SizedBox(height: 48),
              _TechStrip(stack: data.stack),
              const SizedBox(height: 72),
              const SectionTitle(
                kicker: '01 — trabajo',
                title: 'Proyectos destacados',
                subtitle:
                    'Producto real, proyectos personales y ejercicios técnicos. Sin nombres de cliente ni capturas cuando hay confidencialidad de por medio.',
              ),
              const SizedBox(height: 28),
              featured.when(
                loading: () => const _Loader(),
                error: (error, _) => _ErrorBox(message: '$error'),
                data: (projects) => ProjectGrid(projects: projects),
              ),
              const SizedBox(height: 80),
              const SectionTitle(
                kicker: '02 — herramientas',
                title: 'Con lo que trabajo',
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tech in data.stack) TagChip(label: tech),
                ],
              ),
              const SizedBox(height: 80),
              const SectionTitle(
                kicker: '03 — trayectoria',
                title: 'Experiencia',
              ),
              const SizedBox(height: 20),
              for (final experience in data.experience) ...[
                _ExperienceCard(experience: experience),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 64),
              SiteFooter(profile: data, onLink: _open),
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
    final palette = AppPalette.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final titleSize = wide ? 62.0 : 42.0;

        Widget buildIntro({required bool inlineAvatar, double avatarWidth = 72, bool showCaption = false}) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (inlineAvatar)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Polaroid(
                    asset: 'assets/media/bea-portrait.jpg',
                    aspectRatio: 3 / 4,
                    width: avatarWidth,
                    caption: showCaption ? 'hola, soy bea' : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: palette.coral,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '[ MOBILE SOFTWARE ENGINEER ]',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: palette.inkSoft,
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Hola, soy ${profile.name}',
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: titleSize,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mobile Software Engineer · Flutter & Kotlin · Valencia',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: palette.violet,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: palette.coral,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '[ MOBILE SOFTWARE ENGINEER ]',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: palette.inkSoft,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Hola, soy ${profile.name}',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: titleSize,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mobile Software Engineer · Flutter & Kotlin · Valencia',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: palette.violet,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
            const SizedBox(height: 22),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(
                'Construyo producto móvil en Flutter para Android, iOS y Web, '
                'y bajo a Kotlin cuando el proyecto lo pide. En Ideable he '
                'llevado una app de música y he participado en la migración '
                'de una plataforma de teleasistencia, dentro de un equipo de '
                'dos personas.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: palette.inkSoft,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TagChip(label: profile.location, color: palette.mint),
                TagChip(label: profile.availability, color: palette.sun),
                const TagChip(label: 'Remoto o híbrido'),
              ],
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ChunkyButton(
                  label: 'Ver proyectos',
                  icon: Icons.grid_view_outlined,
                  onPressed: () => context.go('/proyectos'),
                ),
                ChunkyButton(
                  label: 'Hablemos',
                  icon: Icons.mail_outline,
                  variant: ChunkyVariant.outline,
                  onPressed: () => context.go('/contacto'),
                ),
                _MiniLink(
                  label: 'CV',
                  icon: Icons.description_outlined,
                  onTap: () => _open(profile.cv),
                ),
                _MiniLink(
                  label: 'GitHub',
                  icon: Icons.code,
                  onTap: () => _open(profile.github),
                ),
                _MiniLink(
                  label: 'LinkedIn',
                  icon: Icons.business_center_outlined,
                  onTap: () => _open(profile.linkedin),
                ),
              ],
            ),
          ],
        );

        // La foto se pega como una pegatina en la esquina superior izquierda
        // del bloque de texto: pequeña, girada y con sombra dura.
        // En pantallas muy anchas la foto cuelga como pegatina por la
        // izquierda. En el resto se integra en línea con el nombre (como en
        // móvil) para no cortarse ni tapar el texto.
        Widget introWithSticker({required bool w}) {
          if (!w) {
            return buildIntro(inlineAvatar: true, avatarWidth: 72, showCaption: false);
          }
          final viewportWidth = MediaQuery.sizeOf(context).width;
          // Solo se cuelga cuando hay hueco suficiente a la izquierda:
          // por debajo de ~1340 la foto colgada caería sobre el título.
          final hangOff = viewportWidth >= 1340;
          // Cuanto se puede colgar la foto sin salirse del viewport: el
          // contenido va centrado con maxWidth 1160 y 24 px de padding.
          final sideMargin = (viewportWidth - (constraints.maxWidth + 48)) / 2 + 24;
          final hangLeft = hangOff
              ? -((sideMargin - 16).clamp(0.0, 130.0)).toDouble()
              : 0.0;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                // Sin colgar, la foto queda arriba a la izquierda: dejar
                // espacio suficiente para que no tape el kicker.
                padding: EdgeInsets.only(left: 30, top: hangOff ? 22 : 136),
                child: buildIntro(inlineAvatar: false),
              ),
              Positioned(
                top: hangOff ? 56 : -8,
                left: hangLeft,
                child: Transform.rotate(
                  angle: -6 * 3.14159265 / 180,
                  child: const _Polaroid(
                    asset: 'assets/media/bea-portrait.jpg',
                    aspectRatio: 3 / 4,
                    width: 120,
                  ),
                ),
              ),
            ],
          );
        }

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildIntro(inlineAvatar: true, avatarWidth: 72, showCaption: false),
              const SizedBox(height: 32),
              _ProfileTicket(profile: profile),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: introWithSticker(w: true)),
            const SizedBox(width: 56),
            Expanded(flex: 5, child: _ProfileTicket(profile: profile)),
          ],
        );
      },
    );
  }
}

class _ProfileTicket extends StatelessWidget {
  const _ProfileTicket({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: HardCard(
            // 2 px = el grosor del borde, para que la cabecera lilá sea
            // interior y se vea el contorno de la tarjeta por los lados.
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: palette.lilac,
                    // El mismo radio que el borde interior de la tarjeta
                    // (20 menos los 2 px del borde) para que la cabecera
                    // siga la curva y no asome por las esquinas.
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    border: Border(
                      bottom: BorderSide(color: palette.line, width: 2),
                    ),
                  ),
                  child: Row(
                    children: [
                      for (final color in [
                        palette.coral,
                        palette.sun,
                        palette.mint,
                      ])
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: palette.line, width: 1.5),
                          ),
                        ),
                      const Spacer(),
                      Text(
                        'perfil.ticket',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TicketRow(label: 'rol', value: profile.role),
                      const SizedBox(height: 10),
                      const DashedDivider(),
                      const SizedBox(height: 10),
                      const _TicketRow(
                        label: 'foco',
                        value: 'Flutter · Android · IA aplicada',
                      ),
                      const SizedBox(height: 10),
                      const DashedDivider(),
                      const SizedBox(height: 10),
                      _TicketRow(label: 'base', value: profile.location),
                      const SizedBox(height: 10),
                      const DashedDivider(),
                      const SizedBox(height: 10),
                      _TicketRow(label: 'ahora', value: 'Precio Luz · en desarrollo'),
                      const SizedBox(height: 18),
                      DashedDivider(color: palette.inkSoft),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'gracias por pasarte',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: palette.inkSoft,
                                fontFamily: 'JetBrainsMono',
                                fontSize: 11,
                              ),
                            ),
                          ),
                          _Barcode(color: palette.ink),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: 12,
          child: Sticker(
            label: 'abierta a oportunidades',
            color: palette.coral,
            angle: 4,
          ),
        ),
      ],
    );
  }
}

class _TicketRow extends StatelessWidget {
  const _TicketRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 62,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: palette.inkSoft,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _Barcode extends StatelessWidget {
  const _Barcode({required this.color});

  final Color color;

  static const _widths = [2.0, 1.0, 3.0, 1.0, 2.0, 2.0, 1.0, 3.0, 1.0, 2.0];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final width in _widths)
          Container(
            width: width,
            height: 22,
            margin: const EdgeInsets.only(right: 2),
            color: color,
          ),
      ],
    );
  }
}

class _TechStrip extends StatelessWidget {
  const _TechStrip({required this.stack});

  final List<String> stack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.symmetric(
          horizontal: BorderSide(color: palette.line, width: 2),
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < stack.length; i++) ...[
            Text(
              stack[i].toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: palette.ink,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            if (i < stack.length - 1)
              Text(
                '✦',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.violet,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _MiniLink extends StatelessWidget {
  const _MiniLink({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: palette.ink),
            const SizedBox(width: 6),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: palette.ink,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                decoration: TextDecoration.underline,
                decorationColor: palette.violet,
                decorationThickness: 2,
              ),
            ),
          ],
        ),
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
    final palette = AppPalette.of(context);

    return HardCard(
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
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return HardCard(
      child: Text('No se pudo cargar el contenido.\n$message'),
    );
  }
}

/// Foto estilo polaroid: borde grueso, sombra dura y una pizca de giro.
/// Así la cara aparece en la portada sin romper el lenguaje del resto del
/// sitio. Si la imagen no carga, deja un hueco con un icono.
class _Polaroid extends StatelessWidget {
  const _Polaroid({
    required this.asset,
    this.aspectRatio = 3 / 4,
    this.width = 120,
    this.caption = 'hola, soy bea',
  });

  final String asset;
  final double aspectRatio;
  final double width;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return SizedBox(
      width: width,
      child: Transform.rotate(
        angle: -2 * 3.14159265 / 180,
        child: HardCard(
          padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, 0.05),
                  errorBuilder: (_, __, ___) => Container(
                    color: palette.lilac,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person_outline,
                      size: 32,
                      color: palette.inkSoft,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (caption != null)
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        caption!,
                        maxLines: 1,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.ink,
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    '✦',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: palette.sun,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      ),     // cierra el SizedBox
    );
  }
}

Future<void> _open(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  // Las rutas relativas (p. ej. el CV incluido en build/web) se resuelven
  // contra la base del sitio, así funciona tanto en "/" como en una
  // subcarpeta de GitHub Pages. El resto (https:, mailto:) ya son absolutas.
  final target = uri.hasScheme ? uri : Uri.base.resolveUri(uri);
  await launchUrl(target, mode: LaunchMode.externalApplication);
}

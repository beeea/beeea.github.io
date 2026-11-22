import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/project.dart';
import 'hard_card.dart';
import 'sticker.dart';
import 'tag_chip.dart';

/// Tarjeta de proyecto.
///
/// En la rejilla normal ocupa una columna. Cuando le toca ocupar la fila
/// entera (la última de un número impar) se pinta en horizontal con una
/// pequeña ficha a la derecha, para que no quede medio hueco vacío.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, this.wide = false});

  final Project project;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final accent = palette.forProjectType(project.type);

    final compact = MediaQuery.sizeOf(context).width < 400;

    final Widget? statusBadge = !wide
        ? (project.status.isNotEmpty
            ? Sticker(
                label: project.status,
                color: palette.sun,
                angle: 3,
                icon: Icons.bolt,
              )
            : project.anonymized
                ? Tooltip(
                    message: 'Caso anonimizado por confidencialidad',
                    child: Icon(
                      Icons.lock_outline,
                      size: 17,
                      color: palette.inkSoft,
                    ),
                  )
                : null)
        : null;

    // En móviles estrechos la cabecera se reparte en líneas para no recortar
    // el estado (p. ej. «En desarrollo»). En el resto se mantiene el tipo y el
    // año a la izquierda y el estado a la derecha, como siempre.
    final header = compact
        ? Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              Sticker(label: project.type, color: accent, angle: -2),
              if (project.year.isNotEmpty)
                Text(project.year, style: theme.textTheme.labelSmall),
              if (statusBadge != null) statusBadge,
            ],
          )
        : Row(
            children: [
              Sticker(label: project.type, color: accent, angle: -2),
              const SizedBox(width: 10),
              if (project.year.isNotEmpty)
                Text(project.year, style: theme.textTheme.labelSmall),
              const Spacer(),
              if (statusBadge != null) statusBadge,
            ],
          );

    final title = Text(project.name, style: theme.textTheme.headlineSmall);

    final summary = Text(
      project.summary,
      style: theme.textTheme.bodyMedium?.copyWith(color: palette.inkSoft),
    );

    final tags = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final platform in project.platforms) TagChip(label: platform),
        for (final tech in project.stack.take(3)) TagChip(label: tech),
      ],
    );

    // FittedBox evita que el CTA se recorte en tarjetas muy estrechas: se
    // reduce apenas un poco cuando no cabe, sin cambiar su aspecto normal.
    final cta = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'VER CASO COMPLETO',
            style: theme.textTheme.labelSmall?.copyWith(
              color: palette.violet,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.arrow_forward, size: 15, color: palette.violet),
        ],
      ),
    );

    return HardCard(
      onTap: () => context.go('/proyectos/${project.slug}'),
      padding: EdgeInsets.all(wide ? 30 : 26),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header,
                      const SizedBox(height: 22),
                      title,
                      const SizedBox(height: 10),
                      summary,
                      const SizedBox(height: 20),
                      tags,
                    ],
                  ),
                ),
                const SizedBox(width: 36),
                Expanded(
                  flex: 4,
                  child: _ProjectSheet(project: project, cta: cta),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                const SizedBox(height: 22),
                title,
                const SizedBox(height: 10),
                summary,
                const SizedBox(height: 20),
                tags,
                const Spacer(),
                const SizedBox(height: 24),
                cta,
              ],
            ),
    );
  }
}

/// Ficha lateral de la tarjeta ancha: estado, año y plataformas.
class _ProjectSheet extends StatelessWidget {
  const _ProjectSheet({required this.project, required this.cta});

  final Project project;
  final Widget cta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.lilac,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.line, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '// ficha',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.inkSoft,
                ),
              ),
              const Spacer(),
              if (project.status.isNotEmpty)
                Sticker(
                  label: project.status,
                  color: palette.sun,
                  angle: 2,
                  icon: Icons.bolt,
                )
              else
                Icon(
                  project.anonymized
                      ? Icons.lock_outline
                      : Icons.check_circle_outline,
                  size: 16,
                  color: palette.inkSoft,
                ),
            ],
          ),
          const SizedBox(height: 14),
          _SheetRow(label: 'año', value: project.year),
          const SizedBox(height: 8),
          _SheetRow(
            label: 'plataforma',
            value: project.platforms.join(' · '),
          ),
          const Spacer(),
          const SizedBox(height: 16),
          cta,
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({required this.label, required this.value});

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
          width: 92,
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
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

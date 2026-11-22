import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Cabecera de sección: etiqueta mono entre corchetes y titular grande.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.kicker,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? kicker;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kicker != null) ...[
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: palette.coral,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '[ ${kicker!.toUpperCase()} ]',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.inkSoft,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: palette.ink,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 16),
              trailing!,
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: palette.inkSoft,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/profile.dart';
import 'dashed_divider.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({
    super.key,
    required this.profile,
    this.onLink,
  });

  final Profile profile;
  final void Function(String url)? onLink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashedDivider(),
        const SizedBox(height: 20),
        Wrap(
          spacing: 24,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '// hecho con flutter',
              style: theme.textTheme.labelSmall?.copyWith(
                color: palette.inkSoft,
              ),
            ),
            _FooterLink(
              label: 'GitHub',
              onTap: () => onLink?.call(profile.github),
            ),
            _FooterLink(
              label: 'LinkedIn',
              onTap: () => onLink?.call(profile.linkedin),
            ),
            _FooterLink(
              label: profile.email,
              onTap: () => onLink?.call('mailto:${profile.email}'),
            ),
            Text(
              '© 2026 bea barber',
              style: theme.textTheme.labelSmall?.copyWith(
                color: palette.inkSoft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return InkWell(
      onTap: onTap,
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: palette.ink,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: palette.violet,
          decorationThickness: 2,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/theme_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.currentPath,
    required this.child,
  });

  final String currentPath;
  final Widget child;

  static const List<_NavItem> _items = [
    _NavItem(label: 'Inicio', path: '/'),
    _NavItem(label: 'Proyectos', path: '/proyectos'),
    _NavItem(label: 'Sobre mí', path: '/sobre-mi'),
    _NavItem(label: 'Contacto', path: '/contacto'),
  ];

  int get _selectedIndex {
    if (currentPath.startsWith('/proyectos')) return 1;
    if (currentPath.startsWith('/sobre-mi')) return 2;
    if (currentPath.startsWith('/contacto')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 840;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: isWide ? 32 : 8,
        title: InkWell(
          onTap: () => context.go('/'),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'beatriz.barber',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        actions: [
          if (isWide) ...[
            for (var i = 0; i < _items.length; i++)
              TextButton(
                onPressed: () => context.go(_items[i].path),
                child: Text(
                  _items[i].label,
                  style: TextStyle(
                    fontWeight:
                        i == _selectedIndex ? FontWeight.w700 : FontWeight.w500,
                    color: i == _selectedIndex
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            const SizedBox(width: 8),
          ],
          IconButton(
            tooltip: isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: child,
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => context.go(_items[index].path),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view),
                  label: 'Proyectos',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Sobre mí',
                ),
                NavigationDestination(
                  icon: Icon(Icons.mail_outline),
                  selectedIcon: Icon(Icons.mail),
                  label: 'Contacto',
                ),
              ],
            ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.path});

  final String label;
  final String path;
}

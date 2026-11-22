import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_colors.dart';

/// Observador de rutas compartido con [MaterialApp] para detectar cambios de
/// página y disparar el scroll hacia arriba.
final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();

class AppShell extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with RouteAware {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      appRouteObserver.subscribe(this, route);
    }
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Buscamos el Scrollable descendiente (el SingleChildScrollView de la
      // página) y animamos su posición hasta arriba.
      ScrollableState? found;
      void visit(Element e) {
        if (found != null) return;
        if (e is StatefulElement && e.state is ScrollableState) {
          found = e.state as ScrollableState;
          return;
        }
        e.visitChildren(visit);
      }
      context.visitChildElements(visit);
      if (found != null && found!.position.pixels != 0) {
        found!.position.animateTo(
          0,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didPush() {
    _scrollToTop();
  }

  @override
  void didPopNext() {
    _scrollToTop();
  }

  int get _selectedIndex {
    if (widget.currentPath.startsWith('/proyectos')) return 1;
    if (widget.currentPath.startsWith('/sobre-mi')) return 2;
    if (widget.currentPath.startsWith('/contacto')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: isWide ? 32 : 16,
        title: InkWell(
          onTap: () {
            if (widget.currentPath == '/') {
              _scrollToTop();
            } else {
              context.go('/');
            }
          },
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: 0.12,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: palette.violet,
                      border: Border.all(color: palette.line, width: 2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'bea.barber',
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                if (isWide) ...[
                  const SizedBox(width: 14),
                  Text(
                    '// mobile software engineer',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: palette.inkSoft,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: palette.line),
        ),
        actions: [
          if (isWide) ...[
            for (var i = 0; i < AppShell._items.length; i++)
              _NavLink(
                label: AppShell._items[i].label,
                path: AppShell._items[i].path,
                selected: i == _selectedIndex,
              ),
            const SizedBox(width: 10),
          ],
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 4),
            child: Tooltip(
              message:
                  isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  ref.read(themeModeProvider.notifier).state =
                      isDark ? ThemeMode.light : ThemeMode.dark;
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: palette.line, width: 2),
                  ),
                  child: Icon(
                    isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    size: 19,
                    color: palette.ink,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // PrimaryScrollController compartido: las páginas (SingleChildScrollView
      // con primary: true) lo usan, así que desde aquí podemos animar el
      // scroll hasta arriba al cambiar de ruta o pulsar el logo.
      body: PrimaryScrollController(
        controller: _scrollController,
        child: widget.child,
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  context.go(AppShell._items[index].path),
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

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.path,
    required this.selected,
  });

  final String label;
  final String path;
  final bool selected;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final active = widget.selected || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: () => context.go(widget.path),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: active ? palette.violet : palette.inkSoft,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.9,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                height: 3,
                width: widget.selected ? 18 : 0,
                decoration: BoxDecoration(
                  color: palette.violet,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.path});

  final String label;
  final String path;
}

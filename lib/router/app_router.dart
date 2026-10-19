import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/about/about_page.dart';
import '../features/contact/contact_page.dart';
import '../features/home/home_page.dart';
import '../features/projects/project_detail_page.dart';
import '../features/projects/projects_page.dart';
import '../shared/widgets/app_shell.dart';
import '../shared/widgets/not_found_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Sin initialLocation: go_router parte de la URL del navegador. Fijarla en
    // '/' hacía que /proyectos/estanteria abriera la portada sin avisar.
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(currentPath: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/proyectos',
            name: 'projects',
            builder: (context, state) => const ProjectsPage(),
          ),
          GoRoute(
            path: '/proyectos/:slug',
            name: 'project',
            builder: (context, state) => ProjectDetailPage(
              slug: state.pathParameters['slug'] ?? '',
            ),
          ),
          GoRoute(
            path: '/sobre-mi',
            name: 'about',
            builder: (context, state) => const AboutPage(),
          ),
          GoRoute(
            path: '/contacto',
            name: 'contact',
            builder: (context, state) => const ContactPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
});

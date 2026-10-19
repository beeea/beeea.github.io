import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/repositories/content_repository.dart';
import '../../shared/widgets/page_container.dart';
import '../../shared/widgets/section_title.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send(String email) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Contacto desde el portfolio — ${_nameController.text}',
        'body': '${_messageController.text}\n\n'
            '— ${_nameController.text} (${_emailController.text})',
      },
    );

    await launchUrl(uri);
  }

  Future<void> _copyEmail(String email) async {
    await Clipboard.setData(ClipboardData(text: email));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email copiado al portapapeles')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          error: (error, _) => Text('No se pudo cargar el contacto: $error'),
          data: (data) => ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  title: 'Hablemos',
                  subtitle:
                      'Cuéntame la vacante o el proyecto. Te respondo en 24-48 horas.',
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Escribe tu nombre'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Escribe tu email';
                          }
                          if (!value.contains('@')) return 'Email no válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Mensaje',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) =>
                            (value == null || value.trim().length < 10)
                                ? 'Cuéntame algo más'
                                : null,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => _send(data.email),
                        icon: const Icon(Icons.send_outlined),
                        label: const Text('Enviar mensaje'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'El formulario abre tu cliente de correo con el mensaje preparado.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                const Divider(),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _copyEmail(data.email),
                      icon: const Icon(Icons.copy_outlined, size: 18),
                      label: Text(data.email),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => launchUrl(
                        Uri.parse(data.linkedin),
                        mode: LaunchMode.externalApplication,
                      ),
                      icon:
                          const Icon(Icons.business_center_outlined, size: 18),
                      label: const Text('LinkedIn'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => launchUrl(
                        Uri.parse(data.github),
                        mode: LaunchMode.externalApplication,
                      ),
                      icon: const Icon(Icons.code, size: 18),
                      label: const Text('GitHub'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

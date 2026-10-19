# beatriz.barber — Portfolio

Portfolio personal de **Beatriz Barber**, Mobile Developer (Flutter & Android nativo).

Construido con **Flutter Web** para demostrar el stack con el que trabajo a diario. Todo el contenido vive en JSON, así que añadir o editar un proyecto no requiere tocar Dart.

🔗 Sitio en producción: _(pendiente de publicar)_

---

## Stack

- Flutter Web (Flutter 3.27+, Material 3)
- Riverpod para estado
- go_router para rutas limpias (`/proyectos/:slug`)
- Contenido en `assets/raw/*.json` con modelos tipados
- `url_launcher` para LinkedIn, GitHub y email
- Semántica de accesibilidad activada al arrancar
- GitHub Actions para análisis, tests y build

## Estructura

```
lib/
├── main.dart                     # Arranque + semántica web
├── app.dart                      # MaterialApp.router + temas
├── core/
│   ├── platform/                 # Accesibilidad en web
│   ├── providers/                # Tema claro/oscuro
│   └── theme/                    # Tema Material 3
├── data/
│   ├── models/                   # Profile, Experience, Project
│   └── repositories/             # Carga de JSON + providers
├── router/                       # go_router
├── features/
│   ├── home/                     # Hero, destacados, stack, experiencia
│   ├── projects/                 # Grid y detalle de proyecto
│   ├── about/                    # Sobre mí
│   └── contact/                  # Formulario (mailto) + enlaces
└── shared/widgets/               # Shell, tarjetas, chips, contenedores
assets/raw/
├── profile.json                  # Datos personales, stack y experiencia
└── projects.json                 # Proyectos (fuente única de verdad)
web/
├── index.html                    # Metadatos, Open Graph, JSON-LD y parche de viewport
├── robots.txt                    # Permite el rastreo y apunta al sitemap
├── sitemap.xml                   # Rutas públicas del sitio
└── og-image.png                  # Tarjeta 1200×630 al compartir el enlace
tool/
└── generate_og_image.py          # Regenera web/og-image.png
```

## Cómo ejecutarlo

```bash
flutter pub get
flutter run -d chrome
```

## Tests

```bash
flutter analyze
flutter test
```

Los tests comprueban que `profile.json` y `projects.json` se parsean, que los slugs son únicos y que ningún proyecto anonimizado expone enlaces de cliente.

## Build para web

```bash
flutter build web --release --tree-shake-icons
```

El resultado queda en `build/web`. En producción se sirve comprimido con Brotli desde el hosting.

## Editar contenido

1. Abre `assets/raw/projects.json`.
2. Copia un bloque de proyecto y cambia los campos.
3. `slug` es la URL (`/proyectos/<slug>`), así que debe ser único y sin espacios.
4. Marca `"featured": true` para que aparezca en la home.
5. Si el proyecto está bajo confidencialidad, pon `"anonymized": true` y deja `links` vacío.

## SEO y accesibilidad

Los ficheros estáticos de `web/` se copian tal cual a `build/web` en cada build:

- `robots.txt` permite el rastreo y apunta al sitemap.
- `sitemap.xml` lista las rutas públicas: home, proyectos, cada proyecto, sobre mí y contacto.
- `og-image.png` es la tarjeta que aparece al compartir el enlace (1200×630) y se regenera con `python3 tool/generate_og_image.py` (Pillow + la Roboto de la caché del SDK de Flutter, para que la tipografía coincida con la app).

`index.html` incluye `canonical`, Open Graph, Twitter Card y datos estructurados JSON-LD (`Person`) con formación, empresa y áreas de conocimiento. También lleva un parche pequeño que devuelve al `<meta name="viewport">` la capacidad de zoom: el motor de Flutter Web lo reescribe con `user-scalable=no` y eso impide ampliar la página en el móvil (WCAG 1.4.4), aunque el HTML de origen no lo pida.

Las URLs absolutas del HTML (`canonical`, Open Graph, Twitter Card, JSON-LD) y las del sitemap apuntan a `https://beeea.github.io`, que es la dirección final del portfolio.

Auditoría de Lighthouse sobre `build/web` servido en local (19/10/2026): **SEO 100**, **buenas prácticas 100**, **accesibilidad 93**. Queda `landmark-one-main` porque Flutter monta la app directamente en el `<body>`, sin un `<main>` propio; se puede revisar cuando el motor permita elegir el elemento host.

## Despliegue

El workflow `.github/workflows/deploy.yml` analiza, testea y publica en GitHub Pages en cada push a `main`. Incluye un paso que copia `index.html` a `404.html`, porque GitHub Pages no reescribe las rutas de una SPA: sin él, abrir `https://<sitio>/proyectos` directamente daría 404 y el enlace no funcionaría fuera de la navegación interna.

El sitio se publica como **sitio de usuario**: el repositorio de GitHub se llama `beeea.github.io`, así que la URL final es `https://beeea.github.io/` (raíz, sin subruta) y el `--base-href` se queda en `/` (por defecto). Para activarlo la primera vez: Settings → Pages → Source → «GitHub Actions».

Si alguna vez se publica como página de proyecto (`https://beeea.github.io/beatriz-portfolio`), habría que definir la variable `BASE_HREF` como `/beatriz-portfolio/` en Settings → Secrets and variables → Actions → Variables, y actualizar las URLs absolutas del HTML y del sitemap.

Para probar los enlaces profundos en local hace falta imitar ese comportamiento, porque un servidor de ficheros normal devuelve su propio 404: `tool/spa_server.py` sirve `build/web` y responde `index.html` en cualquier ruta desconocida. Con `python3 tool/spa_server.py` el sitio queda en `http://127.0.0.1:8131` y `/proyectos/estanteria` funciona igual que en producción.

Si algún día hay dominio propio, basta con añadirlo en Settings → Pages → Custom domain, crear el registro DNS que indique GitHub y cambiar esas mismas URLs absolutas. Sin dominio propio no hace falta nada de esto.

Alternativa: Cloudflare Pages o Vercel conectados al repo (mejor caché y compresión automática, y admiten repos privados).

## Decisiones técnicas

- **Flutter Web como escaparate:** la web es en sí misma una pieza de portfolio. A cambio, hay que vigilar el peso y el SEO; por eso el contenido se carga desde JSON, las fuentes están subseteadas y `index.html` incluye metadatos, Open Graph y JSON-LD.
- **Contenido en JSON en lugar de hardcodeado:** añadir un proyecto es editar un fichero, no refactorizar widgets.
- **go_router con rutas reales:** cada proyecto tiene URL propia y compartible.
- **Semántica activada al arrancar:** en Flutter Web la accesibilidad viene desactivada por defecto hasta que el usuario pulsa un botón; aquí se activa desde `main()`.

## Roadmap

- [ ] Añadir capturas y GIFs reales de los proyectos.
- [ ] Migrar el formulario de contacto a Web3Forms/Formspree.
- [ ] Añadir versión en inglés (`/en`).
- [ ] Publicar el CV en PDF en `/cv`.
- [ ] Añadir analítica sin cookies (Plausible/Umami).
- [ ] Medir el rendimiento de carga y valorar el renderer Wasm (`--wasm`).

## Licencia

MIT.

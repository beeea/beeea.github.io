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

## Despliegue

El workflow `.github/workflows/deploy.yml` analiza, testea y publica en GitHub Pages en cada push a `main`. Incluye un paso que copia `index.html` a `404.html`, porque GitHub Pages no reescribe las rutas de una SPA: sin él, abrir `https://<sitio>/proyectos` directamente daría 404 y el enlace no funcionaría fuera de la navegación interna.

El `--base-href` se toma de la variable de repositorio `BASE_HREF` (por defecto `/`):

- Dominio propio (`https://beatrizbarber.dev`) o repo `beeea.github.io` → se deja `/`.
- Página de proyecto (`https://beeea.github.io/beatriz-portfolio`) → definir `BASE_HREF` como `/beatriz-portfolio/` en Settings → Secrets and variables → Actions → Variables.

Para un dominio propio:

1. Compra `beatrizbarber.dev`.
2. Añádelo en GitHub → repo → Settings → Pages → Custom domain.
3. Crea el registro DNS que indique GitHub.

Alternativa: Cloudflare Pages o Vercel conectados al repo (mejor caché y compresión automática).

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
- [ ] Revisar Lighthouse (rendimiento, accesibilidad, SEO).

## Licencia

MIT.

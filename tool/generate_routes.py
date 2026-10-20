"""Genera un `index.html` por ruta con su propio canonical y metadatos.

GitHub Pages solo sirve ficheros: sin este paso, `/proyectos/estanteria`
responde 404 (aunque el 404.html arranque la SPA) y todas las rutas comparten
el canonical de la portada, que los buscadores leen como contenido duplicado.

Se ejecuta después de `flutter build web` y antes de subir el artefacto:

    python3 tool/generate_routes.py

Lee las fichas de `assets/raw/projects.json`, así que una ruta nueva no se
queda sin metadatos.
"""

from __future__ import annotations

import html
import json
import pathlib
import re

BASE = "https://beeea.github.io"
ROOT = pathlib.Path(__file__).resolve().parent.parent
BUILD = ROOT / "build" / "web"
PROJECTS = ROOT / "assets" / "raw" / "projects.json"

FIXED_PAGES = {
    "/proyectos": (
        "Proyectos · Beatriz Barber",
        "Apps Flutter, plugins Android y trabajos académicos: qué hace cada "
        "proyecto, con qué stack y qué límites tiene.",
    ),
    "/sobre-mi": (
        "Sobre mí · Beatriz Barber",
        "Mobile Developer en Ideable y antes en Capgemini. Ingeniería Multimedia "
        "con Matrícula de Honor en la Universitat de València.",
    ),
    "/contacto": (
        "Contacto · Beatriz Barber",
        "Contacta con Beatriz Barber, Mobile Developer especializada en Flutter "
        "y Android nativo, en Valencia.",
    ),
}


def snippet(text: str, limit: int = 155) -> str:
    """Recorta una descripción sin partir palabras, como piden los buscadores."""
    collapsed = " ".join(text.split())
    if len(collapsed) <= limit:
        return collapsed
    return collapsed[: limit - 1].rsplit(" ", 1)[0] + "…"


def set_tag(page: str, pattern: str, value: str) -> str:
    escaped = html.escape(value, quote=True)
    new_page, count = re.subn(
        pattern,
        lambda match: match.group(1) + escaped + match.group(2),
        page,
        count=1,
        flags=re.DOTALL,
    )
    if count != 1:
        raise SystemExit(f"no se pudo reescribir: {pattern}")
    return new_page


def pages() -> dict[str, tuple[str, str]]:
    routes = dict(FIXED_PAGES)
    data = json.loads(PROJECTS.read_text(encoding="utf-8"))
    for project in data["projects"]:
        routes[f"/proyectos/{project['slug']}"] = (
            f"{project['name']} · Beatriz Barber",
            project["summary"],
        )
    return routes


def render(index: str, route: str, title: str, description: str) -> str:
    url = f"{BASE}{route}/"
    summary = snippet(description)
    page = index
    page = set_tag(page, r'(<link rel="canonical" href=")[^"]*(")', url)
    page = set_tag(page, r'(<meta property="og:url" content=")[^"]*(")', url)
    page = set_tag(page, r'(<meta name="twitter:url" content=")[^"]*(")', url)
    page = set_tag(page, r"(<title>)[^<]*(</title>)", title)
    page = set_tag(page, r'(<meta property="og:title" content=")[^"]*(")', title)
    page = set_tag(page, r'(<meta name="twitter:title" content=")[^"]*(")', title)
    page = set_tag(page, r'(<meta name="description"\s+content=")[^"]*(")', summary)
    page = set_tag(page, r'(<meta property="og:description"\s+content=")[^"]*(")', summary)
    page = set_tag(page, r'(<meta name="twitter:description"\s+content=")[^"]*(")', summary)
    return page


def main() -> None:
    index_path = BUILD / "index.html"
    if not index_path.exists():
        raise SystemExit(f"falta {index_path}: ejecuta `flutter build web` antes")
    index = index_path.read_text(encoding="utf-8")

    routes = pages()
    for route, (title, description) in sorted(routes.items()):
        target = BUILD / route.lstrip("/")
        target.mkdir(parents=True, exist_ok=True)
        (target / "index.html").write_text(
            render(index, route, title, description),
            encoding="utf-8",
        )

    # 404.html hace que la SPA arranque en rutas desconocidas, pero es una
    # página de error: no debe pedir a los buscadores que la indexen.
    not_found = set_tag(
        index,
        r'(<meta name="robots" content=")[^"]*(")',
        "noindex, follow",
    )
    not_found = set_tag(
        not_found,
        r"(<title>)[^<]*(</title>)",
        "Página no encontrada · Beatriz Barber",
    )
    (BUILD / "404.html").write_text(not_found, encoding="utf-8")

    check_sitemap()
    print(f"{len(routes)} rutas con su propio canonical y metadatos")


def check_sitemap() -> None:
    """El sitemap no debe anunciar URLs que Pages vaya a devolver con 404."""
    sitemap = (ROOT / "web" / "sitemap.xml").read_text(encoding="utf-8")
    urls = re.findall(r"<loc>([^<]+)</loc>", sitemap)
    if not urls:
        raise SystemExit("el sitemap no tiene URLs")

    missing = []
    for url in urls:
        route = url.removeprefix(BASE).strip("/")
        page = BUILD / route / "index.html" if route else BUILD / "index.html"
        if not page.exists():
            missing.append(url)
        elif route:
            canonical = f"{BASE}/{route}/"
            if f'<link rel="canonical" href="{canonical}">' not in page.read_text(
                encoding="utf-8"
            ):
                missing.append(f"{url} (canonical incorrecto)")

    if missing:
        raise SystemExit("el sitemap anuncia rutas sin página: " + ", ".join(missing))


if __name__ == "__main__":
    main()

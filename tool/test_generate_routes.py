"""Tests del generador de rutas. Se ejecutan con:

    python3 -m unittest discover -s tool -p "test_*.py"
"""

from __future__ import annotations

import pathlib
import tempfile
import unittest

import generate_routes

INDEX = """<!DOCTYPE html>
<html lang="es">
<head>
  <meta name="robots" content="index, follow">
  <title>Beatriz Barber · Mobile Developer (Flutter &amp; Android)</title>
  <meta name="description"
    content="Portfolio de Beatriz Barber.">
  <link rel="canonical" href="https://beeea.github.io/">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://beeea.github.io/">
  <meta property="og:title" content="Beatriz Barber · Mobile Developer (Flutter &amp; Android)">
  <meta property="og:description"
    content="De Figma a tienda.">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Beatriz Barber · Mobile Developer">
  <meta name="twitter:url" content="https://beeea.github.io/">
  <meta name="twitter:description"
    content="Flutter y Android.">
</head>
<body></body>
</html>
"""


class SnippetTest(unittest.TestCase):
    def test_collapses_whitespace(self) -> None:
        self.assertEqual(generate_routes.snippet("  hola \n  mundo  "), "hola mundo")

    def test_keeps_short_text(self) -> None:
        self.assertEqual(generate_routes.snippet("texto corto"), "texto corto")

    def test_truncates_on_a_word_boundary(self) -> None:
        text = "palabra " * 40
        result = generate_routes.snippet(text, limit=40)
        self.assertLessEqual(len(result), 40)
        self.assertTrue(result.endswith("…"))
        self.assertFalse(result.endswith(" …"))


class RenderTest(unittest.TestCase):
    def test_sets_route_metadata(self) -> None:
        page = generate_routes.render(
            INDEX,
            "/proyectos/estanteria",
            "Estantería · Beatriz Barber",
            "App offline-first para registrar lecturas.",
        )
        self.assertIn(
            '<link rel="canonical" href="https://beeea.github.io/proyectos/estanteria/">',
            page,
        )
        self.assertIn('<meta property="og:url" content="https://beeea.github.io/proyectos/estanteria/">', page)
        self.assertIn('<meta name="twitter:url" content="https://beeea.github.io/proyectos/estanteria/">', page)
        self.assertIn("<title>Estantería · Beatriz Barber</title>", page)
        self.assertIn('<meta property="og:title" content="Estantería · Beatriz Barber">', page)
        self.assertIn('<meta name="twitter:title" content="Estantería · Beatriz Barber">', page)

    def test_escapes_quotes_and_ampersands(self) -> None:
        page = generate_routes.render(
            INDEX,
            "/proyectos/x",
            "A & B",
            'Texto con "comillas" y & ampersand.',
        )
        self.assertIn("<title>A &amp; B</title>", page)
        self.assertIn("Texto con &quot;comillas&quot; y &amp; ampersand.", page)
        self.assertNotIn('"comillas"', page)

    def test_fails_when_a_tag_is_missing(self) -> None:
        with self.assertRaises(SystemExit):
            generate_routes.render("<html></html>", "/x", "t", "d")

    def test_not_found_page_is_noindex(self) -> None:
        html = generate_routes.set_tag(
            INDEX, r'(<meta name="robots" content=")[^"]*(")', "noindex, follow"
        )
        self.assertIn('<meta name="robots" content="noindex, follow">', html)


class SitemapTest(unittest.TestCase):
    def setUp(self) -> None:
        self.original_build = generate_routes.BUILD
        self.original_root = generate_routes.ROOT
        self.tmp = tempfile.TemporaryDirectory()
        root = pathlib.Path(self.tmp.name)
        (root / "web").mkdir()
        (root / "web" / "sitemap.xml").write_text(
            "<urlset>"
            "<url><loc>https://beeea.github.io/proyectos/</loc></url>"
            "</urlset>",
            encoding="utf-8",
        )
        generate_routes.ROOT = root
        generate_routes.BUILD = root / "build"

    def tearDown(self) -> None:
        generate_routes.BUILD = self.original_build
        generate_routes.ROOT = self.original_root
        self.tmp.cleanup()

    def test_passes_when_every_route_exists(self) -> None:
        page = generate_routes.render(
            INDEX, "/proyectos", "Proyectos", "Todos los proyectos."
        )
        target = generate_routes.BUILD / "proyectos"
        target.mkdir(parents=True)
        (target / "index.html").write_text(page, encoding="utf-8")
        generate_routes.check_sitemap()

    def test_fails_when_a_route_has_no_page(self) -> None:
        with self.assertRaises(SystemExit):
            generate_routes.check_sitemap()

    def test_fails_when_canonical_does_not_match(self) -> None:
        target = generate_routes.BUILD / "proyectos"
        target.mkdir(parents=True)
        (target / "index.html").write_text(INDEX, encoding="utf-8")
        with self.assertRaises(SystemExit):
            generate_routes.check_sitemap()


if __name__ == "__main__":
    unittest.main()

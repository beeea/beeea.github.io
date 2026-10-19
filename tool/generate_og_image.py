#!/usr/bin/env python3
"""Genera `web/og-image.png`, la tarjeta que se ve al compartir el portfolio.

Es la única imagen del sitio que no produce Flutter, así que se mantiene aquí
para poder regenerarla cuando cambie el titular o el stack:

    python3 tool/generate_og_image.py

Usa Roboto, la misma tipografía que la app, desde la caché del SDK de Flutter.
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

WIDTH, HEIGHT = 1200, 630
SURFACE = (20, 18, 24)
ACCENT = (207, 188, 255)
ACCENT_STRONG = (108, 99, 255)
TITLE = (255, 255, 255)
BODY = (202, 196, 208)
CHIP_BORDER = (73, 69, 79)

FONT_DIR = Path.home() / "Developer/flutter/bin/cache/artifacts/material_fonts"

TITLE_LINE = "Beatriz Barber"
LABEL = "MOBILE DEVELOPER · FLUTTER & ANDROID"
BODY_LINES = [
    "De Figma a tienda: apps Flutter y Android nativo",
    "con arquitectura limpia, tests y flujo asistido por IA.",
]
CHIPS = ["media_metadata_kit", "Estantería", "173 tests", "Kotlin nativo"]
FOOTER = "beatrizbarber.dev"


def font(name: str, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(FONT_DIR / name), size)


def draw_tracked(
    draw: ImageDraw.ImageDraw,
    xy: tuple[int, int],
    text: str,
    text_font: ImageFont.FreeTypeFont,
    fill: tuple[int, int, int],
    tracking: float,
) -> None:
    """Dibuja texto con espaciado entre letras (Pillow no lo trae)."""
    x, y = xy
    for char in text:
        draw.text((x, y), char, font=text_font, fill=fill)
        x += draw.textlength(char, font=text_font) + tracking


def background() -> Image.Image:
    image = Image.new("RGBA", (WIDTH, HEIGHT), SURFACE + (255,))
    glow = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
    draw = ImageDraw.Draw(glow)
    cx, cy, radius = 1010, 60, 560
    for step in range(radius, 0, -4):
        alpha = int(72 * (1 - step / radius) ** 2)
        draw.ellipse(
            (cx - step, cy - step, cx + step, cy + step),
            fill=ACCENT_STRONG + (alpha,),
        )
    return Image.alpha_composite(image, glow).convert("RGB")


def main() -> None:
    image = background()
    draw = ImageDraw.Draw(image)

    left = 78

    # Barra de acento sobre el titular.
    draw.rounded_rectangle((left, 92, left + 92, 100), radius=4, fill=ACCENT_STRONG)

    draw_tracked(draw, (left, 128), LABEL, font("Roboto-Medium.ttf", 25), ACCENT, 3.2)

    draw.text((left, 176), TITLE_LINE, font=font("Roboto-Bold.ttf", 96), fill=TITLE)

    body_font = font("Roboto-Regular.ttf", 32)
    for index, line in enumerate(BODY_LINES):
        draw.text((left, 322 + index * 46), line, font=body_font, fill=BODY)

    chip_font = font("Roboto-Medium.ttf", 23)
    x, y, height = left, 474, 52
    for label in CHIPS:
        width = int(draw.textlength(label, font=chip_font)) + 48
        draw.rounded_rectangle(
            (x, y, x + width, y + height),
            radius=height // 2,
            outline=CHIP_BORDER,
            width=2,
        )
        draw.text(
            (x + 24, y + 15),
            label,
            font=chip_font,
            fill=BODY,
        )
        x += width + 14

    footer_font = font("Roboto-Medium.ttf", 26)
    footer_width = int(draw.textlength(FOOTER, font=footer_font))
    draw.text(
        (WIDTH - left - footer_width, HEIGHT - 68),
        FOOTER,
        font=footer_font,
        fill=ACCENT,
    )

    destination = Path(__file__).resolve().parent.parent / "web/og-image.png"
    image.save(destination, optimize=True)
    print(f"{destination} ({destination.stat().st_size / 1024:.0f} KB)")


if __name__ == "__main__":
    main()

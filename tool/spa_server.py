"""Servidor SPA mínimo para imitar GitHub Pages (404.html como fallback).

Sirve build/web y, para cualquier ruta que no sea un fichero real, devuelve
index.html: es lo mismo que hace el workflow al copiar index.html a 404.html.
"""

import http.server
import os
import socketserver

ROOT = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "build", "web"
)


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=ROOT, **kwargs)

    def do_GET(self):
        path = self.translate_path(self.path)
        if os.path.isdir(path):
            path = os.path.join(path, "index.html")
        if not os.path.exists(path):
            # Fallback de SPA: la app resuelve la ruta en el cliente.
            self.path = "/index.html"
        return super().do_GET()

    def log_message(self, *args):
        pass


class Server(socketserver.TCPServer):
    # Sin esto, reiniciar el servidor falla con «Address already in use».
    allow_reuse_address = True


with Server(("127.0.0.1", 8131), Handler) as httpd:
    httpd.serve_forever()

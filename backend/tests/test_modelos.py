import pytest
from app.models import Usuario

def test_nuevo_usuario():
    usuario = Usuario(nombre="Juan", apellido="Pérez", email="juan@example.com")
    assert usuario.nombre == "Juan"

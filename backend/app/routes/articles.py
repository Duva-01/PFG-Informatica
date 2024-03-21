from flask import Blueprint, jsonify, request
from ..models import ArticulosAprendizaje  # Importa el modelo de la tabla de artículos de aprendizaje
from ..extensions import db


# Crea un blueprint para los artículos de aprendizaje
article_bp = Blueprint('articles', __name__)

# Ruta para obtener todos los artículos de aprendizaje
@article_bp.route('/get_articles', methods=['GET'])
def obtener_articulos():
    articulos = ArticulosAprendizaje.query.all()
    # Convierte los objetos de los artículos en un formato JSON y devuelve la lista de artículos
    return jsonify([articulo.to_dict() for articulo in articulos]), 200

# Ruta para obtener un artículo de aprendizaje por su ID
@article_bp.route('/get_article/<int:id>', methods=['GET'])
def obtener_articulo_por_id(id):
    articulo = ArticulosAprendizaje.query.get_or_404(id)
    # Convierte el objeto del artículo en un formato JSON y devuelve el artículo
    return jsonify(articulo.to_dict()), 200
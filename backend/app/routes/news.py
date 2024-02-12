from flask import Blueprint, jsonify, request
import requests

# Crear un Blueprint para las rutas de noticias
news_bp = Blueprint('news', __name__)

# Ruta para obtener noticias financieras
@news_bp.route('/financial_news')
def get_financial_news():
    api_key = 'a7fb25368aa74e8986c641a4f559e5c9'
    tematica = request.args.get('tematica', 'finanzas')  # Obtener el tema de las noticias (por defecto: finanzas)
    url = f'https://newsapi.org/v2/everything?q={tematica}&language=es&apiKey={api_key}'  # Construir la URL de la API de noticias

    response = requests.get(url)  # Realizar la solicitud GET a la API de noticias

    if response.status_code == 200:  # Si la solicitud fue exitosa
        news_data = response.json()  # Obtener los datos de noticias en formato JSON
        return jsonify(news_data['articles'])  # Devolver los artículos de noticias como respuesta JSON
    else:  # Si la solicitud no fue exitosa
        # Devolver un mensaje de error junto con el código de estado de la respuesta
        return jsonify({"error": "No se pudieron obtener las noticias"}), response.status_code

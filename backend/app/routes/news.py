from flask import Blueprint, jsonify
import requests

news_bp = Blueprint('news', __name__)

@news_bp.route('/financial_news')
def get_financial_news():
    api_key = 'a7fb25368aa74e8986c641a4f559e5c9'
    url = f'https://newsapi.org/v2/everything?q=finanzas&language=es&apiKey={api_key}'

    response = requests.get(url)

    if response.status_code == 200:
        news_data = response.json()
        return jsonify(news_data['articles'])
    else:
        return jsonify({"error": "No se pudieron obtener las noticias"}), response.status_code

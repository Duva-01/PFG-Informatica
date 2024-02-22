from flask import Blueprint, jsonify, request
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

# Crear un Blueprint para las rutas de noticias
news_bp = Blueprint('news', __name__)

def get_api_session(retries=3, backoff_factor=0.3, status_forcelist=(500, 502, 504)):
    """
    Retorna una sesión de requests con la lógica de reintento configurada.
    """
    session = requests.Session()
    retry_strategy = Retry(
        total=retries,
        read=retries,
        connect=retries,
        backoff_factor=backoff_factor,
        status_forcelist=status_forcelist,
    )
    adapter = HTTPAdapter(max_retries=retry_strategy)
    session.mount("http://", adapter)
    session.mount("https://", adapter)
    return session

@news_bp.route('/financial_news')
def get_financial_news():
    api_key = 'a7fb25368aa74e8986c641a4f559e5c9'
    tematica = request.args.get('tematica', 'finanzas')
    url = f'https://newsapi.org/v2/everything?q={tematica}&language=es&apiKey={api_key}'

    session = get_api_session()  # Obtener una sesión de requests configurada con reintento
    try:
        response = session.get(url)
        if response.status_code == 200:
            news_data = response.json()
            return jsonify(news_data['articles'])
        else:
            return jsonify({"error": "No se pudieron obtener las noticias"}), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({"error": str(e)}), 500


from flask import Blueprint, jsonify, request
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
from ..auth_decorators import login_required_conditional

# Crear un Blueprint para las rutas de noticias
news_bp = Blueprint('news', __name__)

def get_api_session(retries=3, backoff_factor=0.3, status_forcelist=(500, 502, 504)):
    """
    Retorna una sesión de requests con la lógica de reintento configurada.
    """
    session = requests.Session()
    # Configurar la estrategia de reintento
    retry_strategy = Retry(
        total=retries,
        read=retries,
        connect=retries,
        backoff_factor=backoff_factor,
        status_forcelist=status_forcelist,
    )
    # Crear un adaptador HTTP con la estrategia de reintento
    adapter = HTTPAdapter(max_retries=retry_strategy)
    # Montar el adaptador HTTP en la sesión de requests para manejar las solicitudes
    session.mount("http://", adapter)
    session.mount("https://", adapter)
    return session

# Ruta para obtener noticias financieras
@news_bp.route('/financial_news')
@login_required_conditional
def get_financial_news():
    api_key = 'a7fb25368aa74e8986c641a4f559e5c9'
    # Extraer el tema de las noticias financieras de los parámetros de la solicitud, o usar 'finanzas' como valor predeterminado
    tematica = request.args.get('tematica', 'finanzas')
    # Construir la URL de la API de noticias financieras con el tema proporcionado y la clave de API
    url = f'https://newsapi.org/v2/everything?q={tematica}&language=es&apiKey={api_key}'

    # Obtener una sesión de requests configurada con reintento
    session = get_api_session()
    try:
        # Realizar una solicitud GET a la URL de la API
        response = session.get(url)
        if response.status_code == 200:  # Si la solicitud es exitosa
            # Convertir los datos de respuesta JSON en un formato JSON válido y devolver los artículos de noticias
            news_data = response.json()
            return jsonify(news_data['articles'])
        else:  # Si la solicitud no es exitosa
            # Devolver un mensaje de error junto con el código de estado
            return jsonify({"error": "No se pudieron obtener las noticias"}), response.status_code
    except requests.exceptions.RequestException as e:  # Capturar excepciones de solicitud
        # Devolver un mensaje de error junto con el código de estado
        return jsonify({"error": str(e)}), 500

# Ruta para obtener noticias sobre acciones específicas
@news_bp.route('/stock_news', methods=['GET'])
@login_required_conditional
def get_stock_news():
    api_key = 'a7fb25368aa74e8986c641a4f559e5c9'
    # Obtiene el nombre de la empresa de los parámetros de la solicitud, o usa 'Apple' como valor predeterminado
    company_name = request.args.get('nombreAccion', default="Apple")
    # Opcional: permite especificar el idioma de las noticias a través de los parámetros de la solicitud
    language = request.args.get('idioma', default="es")
    
    # Construir la URL de la API de noticias sobre acciones con el nombre de la empresa y el idioma proporcionados, junto con la clave de API
    url = f'https://newsapi.org/v2/everything?q="{company_name}"&language={language}&apiKey={api_key}'

    # Obtener una sesión de requests configurada con reintento
    session = get_api_session()
    try:
        # Realizar una solicitud GET a la URL de la API
        response = session.get(url)
        if response.status_code == 200:  # Si la solicitud es exitosa
            # Convertir los datos de respuesta JSON en un formato JSON válido y devolver los artículos de noticias junto con el código de estado 200
            news_data = response.json()
            return jsonify(news_data['articles']), 200
        else:  # Si la solicitud no es exitosa
            # Devolver un mensaje de error junto con el código de estado
            return jsonify({"error": "No se pudieron obtener las noticias"}), response.status_code
    except requests.exceptions.RequestException as e:  # Capturar excepciones de solicitud
        # Devolver un mensaje de error junto con el código de estado
        return jsonify({"error": str(e)}), 500

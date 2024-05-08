# Importaciones necesarias
from flask import jsonify, request, Blueprint, current_app as app
from datetime import datetime, timedelta
import yfinance as yf

from app.models import Accion, AccionesFavoritas, Transaccion, Usuario, Cartera
from ..extensions import db 
from ..auth_decorators import login_required_conditional

import numpy as np

finance_bp = Blueprint('finance', __name__)

# Funcion para obtener una seria de tickers de las acciones mas famosas
def get_global_trending_tickers():

    global_tickers = [
    "AAPL", "MSFT", "AMZN", "GOOGL", "FB", "TSLA", "BRK.A", "JPM",
    "JNJ", "V", "PG", "HD", "MA", "UNH", "NVDA", "BAC", "PYPL",
    "NFLX", "ADBE", "KO", "CMCSA", "XOM", "T", "INTC", "VZ",
    "PFE", "DIS", "CSCO", "CRM", "WMT", "ABT", "PEP", "NKE",
    "MCD", "WFC", "CVX", "BA", "ABNB", "AAL", "DAL", "UAL",
    "TWTR", "SQ", "ZM", "ROKU", "SNAP", "DOCU", "UBER", "LYFT",
    "GOLD", "TGT", "COST", "CAT", "IBM", "ORCL", "TGT", "CVS",
    "FDX", "UPS", "X", "ZS", "DDOG", "DOV", "DAL", "EMR",
    "EXC", "CMI", "LMT", "NOC", "RTX", "REGN", "AMGN", "GILD",
    "ABBV", "BIIB", "VRTX", "CELG", "REGN", "ILMN", "IDXX", "ALXN",
    "ALGN", "CDNS", "CTSH", "NTES", "SNPS", "WBA", "WDAY", "FIS",
    "ADP", "KLAC", "MCHP", "CTAS", "MTD", "ANET", "MNST", "XEL",
    "YUM", "MNST", "CPRT", "CTRP", "WIX", "BMRN", "FOX", "FOXA",
    "NTAP", "SGEN", "RCL", "AZO", "ADI", "RMD", "PHM", "AMD",
    "YUMC", "LULU", "ALB", "URI", "CHTR", "SYF", "FTNT", "NOW",
    "ZBRA", "SIVB", "IDXX", "TWLO", "PAYC", "AMAT", "KLAC", "ADSK",
    "CDW", "AAP", "NVTA", "WDC", "FLT", "RNG", "MTCH", "GRMN",
    "WYNN", "ULTA", "TXN", "CTXS", "FTNT", "STX", "NTGR", "COUP",
    "PEGA", "OKTA", "STNE", "OKTA", "VEEV", "PANW", "TWLO", "WDAY",
    "FICO", "HUBS", "TTD", "MDB", "DOCU", "PINS", "RNG", "SQ",
    "ZM", "FSLY", "CRWD", "SPLK", "PD", "ETSY", "PTON", "ZEN",
    "FTCH", "CRSP", "SHOP", "TWOU", "EVBG", "AYX", "DDOG", 
    
    "SAN", "BBVA", "TEF", "ITX", "IBE", "REP", "AMS", "FER",
    "ELE", "CABK", "SAB", "MAP"]

    return global_tickers
pass

# Actualizar las acciones con los tickers globales populares
def actualizar_acciones_global_tickers():
    # Obtenemos los tickers globales populares
    global_tickers = get_global_trending_tickers()

    # Iteramos sobre cada ticker en los tickers globales
    for ticker_symbol in global_tickers:
        # Creamos un objeto Ticker para el ticker actual
        ticker = yf.Ticker(ticker_symbol)
        try:
            # Intentamos obtener el nombre de la acción
            nombre = ticker.info.get('longName', None)
            # Verificamos si se obtuvo el nombre
            if nombre:
                # Verificamos si la acción no existe ya en la base de datos
                if not Accion.query.filter_by(codigoticker=ticker_symbol).first():
                    # Creamos una nueva acción y la añadimos a la base de datos
                    nueva_accion = Accion(nombre=nombre, codigoticker=ticker_symbol)
                    db.session.add(nueva_accion)
                    # Imprimimos un mensaje indicando que se añadió la nueva acción
                    print(f"Añadiendo nueva acción: {nombre} ({ticker_symbol})")
        except Exception as e:
            # Imprimimos un mensaje en caso de que no se pueda obtener la información para el ticker actual
            print(f"No se pudo obtener la información para {ticker_symbol}: {e}")

    # Confirmamos los cambios en la base de datos
    db.session.commit()

# Ruta para obtener datos de acciones populares
@finance_bp.route('/popular_stocks_data')
@login_required_conditional
def get_popular_stocks_data():
    # Obtener el número de página y el número de elementos por página de los argumentos de la solicitud
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=10, type=int)
    
    # Calcular el índice de inicio y obtener las acciones correspondientes a la página actual
    start_index = (page - 1) * per_page
    acciones = Accion.query.offset(start_index).limit(per_page).all()
    
    # Definir las fechas de inicio y fin para obtener los datos de las acciones
    end_date = datetime.now()
    start_date = end_date - timedelta(days=2)
    popular_stocks_data = {}
    
    # Iterar sobre cada acción obtenida
    for accion in acciones:
        # Obtener el símbolo del ticker de la acción
        ticker_symbol = accion.codigoticker
        # Crear un objeto Ticker para el ticker actual
        ticker = yf.Ticker(ticker_symbol)
        # Obtener los datos históricos de la acción para las fechas especificadas
        data = ticker.history(start=start_date, end=end_date)
        # Verificar si hay datos disponibles para la acción
        if not data.empty:
            # Obtener la última fila de datos (el dato más reciente)
            last_row = data.iloc[-1]
            # Crear un diccionario con la información de la acción
            stock_info = {
                'id': accion.id_accion, 
                'name': ticker.info.get('longName', 'Unknown'),
                'ticker_symbol': ticker_symbol,
                'current_price': last_row['Close'],
                'change': last_row['Close'] - last_row['Open'],
                'change_percent': ((last_row['Close'] - last_row['Open']) / last_row['Open']) * 100,
            }
            # Agregar la información de la acción al diccionario de datos de acciones populares
            popular_stocks_data[accion.id_accion] = stock_info
        else:
            # Imprimir un mensaje si no hay datos disponibles para el ticker actual
            print(f"No hay datos disponibles para el ticker: {ticker_symbol}")
    
    # Devolver los datos de las acciones populares en formato JSON
    return jsonify(list(popular_stocks_data.values()))


# Definir una ruta para obtener datos de una acción específica mediante su símbolo de ticker
@finance_bp.route('/stock_data/<string:ticker_symbol>')
@login_required_conditional
def get_stock_data(ticker_symbol):
    # Definir las fechas de inicio y fin para obtener los datos históricos de la acción
    end_date = datetime.now()
    start_date = end_date - timedelta(days=2)  
    
    # Crear un objeto Ticker para el símbolo de ticker proporcionado
    ticker = yf.Ticker(ticker_symbol)
    # Obtener los datos históricos de la acción para las fechas especificadas
    data = ticker.history(start=start_date, end=end_date)
    
    # Verificar si hay datos disponibles para la acción
    if not data.empty:
        # Obtener la última fila de datos (el dato más reciente)
        last_row = data.iloc[-1]
        # Crear un diccionario con la información de la acción
        stock_info = {
            'name': ticker.info.get('longName', 'Unknown'),
            'ticker_symbol': ticker_symbol,
            'current_price': last_row['Close'],
            'change': last_row['Close'] - last_row['Open'],
            'change_percent': ((last_row['Close'] - last_row['Open']) / last_row['Open']) * 100,
        }
        # Devolver la información de la acción en formato JSON
        return jsonify(stock_info)
    else:
        # Devolver un mensaje de error si no hay datos disponibles para el ticker proporcionado
        return jsonify({'error': f"No hay datos disponibles para el ticker: {ticker_symbol}"}), 404



# Definir una ruta para obtener las acciones favoritas de un usuario
@finance_bp.route('/acciones_favs', methods=['GET'])
@login_required_conditional
def get_acciones_favoritas_usuario():
    # Obtener el ID de usuario de los argumentos de la solicitud
    id_usuario = request.args.get('id_usuario', type=int)
    # Verificar si se proporcionó el ID de usuario
    if not id_usuario:
        # Devolver un mensaje de error si no se proporcionó el ID de usuario
        return jsonify({'error': 'Se requiere el ID de usuario'}), 400
    
    # Obtener las acciones favoritas del usuario de la base de datos
    acciones_favoritas = AccionesFavoritas.query.filter_by(id_usuario=id_usuario).join(Accion).all()
    
    # Definir las fechas de inicio y fin para obtener los datos históricos de las acciones
    end_date = datetime.now()
    start_date = end_date - timedelta(days=2)
    favoritas_data = {}
    
    # Iterar sobre cada acción favorita del usuario
    for favorita in acciones_favoritas:
        # Obtener el símbolo del ticker de la acción favorita
        ticker_symbol = favorita.accion.codigoticker
        # Crear un objeto Ticker para el símbolo de ticker de la acción favorita
        ticker = yf.Ticker(ticker_symbol)
        # Obtener los datos históricos de la acción favorita para las fechas especificadas
        data = ticker.history(start=start_date, end=end_date)
        # Verificar si hay datos disponibles para la acción favorita
        if not data.empty:
            # Obtener la última fila de datos (el dato más reciente)
            last_row = data.iloc[-1]
            # Crear un diccionario con la información de la acción favorita
            stock_info = {
                'id': favorita.accion.id_accion,
                'name': ticker.info['longName'],
                'ticker_symbol': ticker_symbol,
                'current_price': last_row['Close'],
                'change': last_row['Close'] - last_row['Open'],
                'change_percent': ((last_row['Close'] - last_row['Open']) / last_row['Open']) * 100,
            }
            # Agregar la información de la acción favorita al diccionario de datos de acciones favoritas
            favoritas_data[favorita.accion.id_accion] = stock_info
        else:
            # Imprimir un mensaje si no hay datos disponibles para la acción favorita
            print(f"No hay datos disponibles para el ticker: {ticker_symbol}")
            # Agregar un mensaje de error al diccionario de datos de acciones favoritas
            favoritas_data[favorita.accion.id_accion] = {'error': 'No hay datos disponibles'}
    
    # Devolver los datos de las acciones favoritas en formato JSON
    return jsonify(list(favoritas_data.values()))

# Definir una ruta para obtener datos históricos de una acción
@finance_bp.route('/historical_data')
@login_required_conditional
def get_historical_data():
    # Obtener el símbolo del ticker y el intervalo de los argumentos de la solicitud
    ticker_symbol = request.args.get('symbol')
    interval = request.args.get('interval', default='1mo')  # Puede ser 1d, 1wk, 1mo, 3mo, 1y, etc.

    # Verificar si se proporcionó el símbolo del ticker
    if not ticker_symbol:
        # Devolver un mensaje de error si no se proporcionó el símbolo del ticker
        return jsonify(error='Se requiere el símbolo del ticker'), 400

    # Crear un objeto Ticker para el símbolo de ticker proporcionado
    ticker = yf.Ticker(ticker_symbol)
    # Obtener los datos históricos de la acción para el periodo especificado
    data = ticker.history(period=interval)
    # Rellenar los valores NaN con 0 y formatear el índice como '%Y-%m-%d'
    data.fillna(0, inplace=True)
    data.index = data.index.strftime('%Y-%m-%d')

    # Devolver los datos históricos de la acción en formato JSON
    return jsonify(data.to_dict(orient='index'))


# Ruta para agregar una acción a favoritos
@finance_bp.route('/agregar_accion_fav', methods=['POST'])
@login_required_conditional
def agregar_accion_favorita():
    # Obtener los datos JSON de la solicitud
    data = request.get_json()
    id_usuario = data.get('id_usuario')
    id_accion = data.get('id_accion')
    # Verificar si se proporcionaron ambos el ID de usuario y el ID de acción
    if not id_usuario or not id_accion:
        # Devolver un mensaje de error si falta alguno de los datos necesarios
        return jsonify({'error': 'Faltan datos para agregar a favoritos'}), 400
    # Crear un nuevo registro de acción favorita en la base de datos
    nueva_favorita = AccionesFavoritas(id_usuario=id_usuario, id_accion=id_accion)
    db.session.add(nueva_favorita)
    db.session.commit()
    # Devolver un mensaje de éxito
    return jsonify({'mensaje': 'Acción agregada a favoritos con éxito'})

# Ruta para eliminar una acción de favoritos
@finance_bp.route('/eliminar_accion_fav', methods=['POST'])
@login_required_conditional
def eliminar_accion_favorita():
    # Obtener los datos JSON de la solicitud
    data = request.get_json()
    id_usuario = data.get('id_usuario')
    id_accion = data.get('id_accion')
    # Verificar si se proporcionaron ambos el ID de usuario y el ID de acción
    if not id_usuario or not id_accion:
        # Devolver un mensaje de error si falta alguno de los datos necesarios
        return jsonify({'error': 'Faltan datos para eliminar de favoritos'}), 400
    # Eliminar la acción favorita de la base de datos
    AccionesFavoritas.query.filter_by(id_usuario=id_usuario, id_accion=id_accion).delete()
    db.session.commit()
    # Devolver un mensaje de éxito
    return jsonify({'mensaje': 'Acción eliminada de favoritos con éxito'})

#---------------------------------------------------------
#-------------- Pagina mis acciones ----------------------

@finance_bp.route('/acciones_usuario', methods=['GET'])
@login_required_conditional
def acciones_usuario():
    email = request.args.get('email')
    if not email:
        return jsonify({'error': 'Se requiere el parámetro email'}), 400
    
    # Busca el usuario por email
    usuario = Usuario.query.filter_by(email=email).first()
    if not usuario:
        return jsonify({'error': 'Usuario no encontrado'}), 404

    # Obtener el id de la cartera del usuario
    cartera_usuario = Cartera.query.filter_by(id_usuario=usuario.id).first()
    if not cartera_usuario:
        return jsonify({'error': 'Cartera no encontrada para el usuario'}), 404
    
    # Filtrar las transacciones basadas en el id_cartera de la cartera del usuario
    compras = db.session.query(
        Transaccion.id_accion,
        db.func.sum(Transaccion.cantidad).label('total_compras')
    ).filter_by(
        id_cartera=cartera_usuario.id_cartera,
        tipo='compra'
    ).group_by(Transaccion.id_accion).all()

    ventas = db.session.query(
        Transaccion.id_accion,
        db.func.sum(Transaccion.cantidad).label('total_ventas')
    ).filter_by(
        id_cartera=cartera_usuario.id_cartera,
        tipo='venta'
    ).group_by(Transaccion.id_accion).all()

    # Convertir las ventas a un diccionario para facilitar el acceso
    ventas_dict = {venta.id_accion: venta.total_ventas for venta in ventas}

    # Calcular las acciones que aún posee el usuario
    acciones_usuario = []
    for compra in compras:
        id_accion = compra.id_accion
        total_compras = compra.total_compras
        total_ventas = ventas_dict.get(id_accion, 0)
        acciones_restantes = total_compras - total_ventas

        if acciones_restantes > 0:
            # Obtener información adicional de la acción
            accion_info = Accion.query.get(id_accion)
            
            # Obtener el precio actual de la acción usando yfinance
            ticker = yf.Ticker(accion_info.codigoticker)
            data = ticker.history(period="1d")
            if not data.empty:
                last_row = data.iloc[-1]
                current_price = last_row['Close']
            else:
                current_price = None  # En caso de no obtener datos
            
            acciones_usuario.append({
                'id_accion': id_accion,
                'nombre': accion_info.nombre,
                'codigoticker': accion_info.codigoticker,
                'acciones_restantes': acciones_restantes,
                'precio_actual': current_price,
            })

    return jsonify(acciones_usuario)

#---------------------------------------------------------
#-------------- Pagina inicio ----------------------

@finance_bp.route('/resumen_mercado', methods=['GET'])
@login_required_conditional
def obtener_resumen_mercado():
    # Índices principales
    indices = ['^DJI', '^GSPC', '^IXIC']
    resumen_indices = {}
    for indice in indices:
        try:
            ticker = yf.Ticker(indice)
            hist = ticker.history(period="1d")
            if not hist.empty:
                resumen_indices[ticker.info['shortName']] = {
                    'current_price': hist['Close'].iloc[-1],
                    'change': hist['Close'].iloc[-1] - hist['Open'].iloc[-1],
                    'percent_change': ((hist['Close'].iloc[-1] - hist['Open'].iloc[-1]) / hist['Open'].iloc[-1]) * 100
                }
        except Exception as e:
            print(f"Error al obtener datos para {indice}: {e}")
    
    # Sectores en movimiento
    sectores = {
        'Tecnología': ['AAPL', 'MSFT', 'GOOGL', 'INTC', 'AMD'],
        'Salud': ['JNJ', 'PFE', 'MRK', 'ABBV', 'GILD'],
        'Energía': ['XOM', 'CVX', 'TOT', 'BP', 'SLB'],  
        'Finanzas': ['JPM', 'BAC', 'WFC', 'C', 'GS']   
    }
    resumen_sectores = {}
    for sector, tickers in sectores.items():
        rendimiento_total = 0
        datos_validos = 0
        for ticker in tickers:
            try:
                accion = yf.Ticker(ticker)
                hist = accion.history(period="3d")
                if not hist.empty:
                    rendimiento = ((hist['Close'].iloc[-1] - hist['Open'].iloc[-1]) / hist['Open'].iloc[-1]) * 100
                    rendimiento_total += rendimiento
                    datos_validos += 1
                    if datos_validos == 3:  # Si ya se obtuvieron datos de 3 acciones válidas, detener el bucle
                        break
            except Exception as e:
                print(f"Error al obtener datos para {ticker}: {e}")
        if datos_validos > 0:
            rendimiento_promedio = rendimiento_total / datos_validos
            resumen_sectores[sector] = rendimiento_promedio
    
    # Análisis de sentimiento simplificado
    sentimiento = 'Positivo' if sum(resumen_sectores.values()) > 0 else 'Negativo'

    return jsonify({
        'indices': resumen_indices,
        'sectores': resumen_sectores,
        'sentimiento_mercado': sentimiento
    })

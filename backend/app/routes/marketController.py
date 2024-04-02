from flask import jsonify, request, Blueprint, current_app as app
from datetime import datetime, timedelta
import yfinance as yf

from app.models import Accion, AccionesFavoritas, Transaccion, Usuario, Cartera
from ..extensions import db 

import numpy as np

finance_bp = Blueprint('finance', __name__)


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
    global_tickers = get_global_trending_tickers()

    for ticker_symbol in global_tickers:
        ticker = yf.Ticker(ticker_symbol)
        try:
            nombre = ticker.info.get('longName', None)
            if nombre:
                if not Accion.query.filter_by(codigoticker=ticker_symbol).first():
                    nueva_accion = Accion(nombre=nombre, codigoticker=ticker_symbol)
                    db.session.add(nueva_accion)
                    print(f"Añadiendo nueva acción: {nombre} ({ticker_symbol})")
        except Exception as e:
            print(f"No se pudo obtener la información para {ticker_symbol}: {e}")

    db.session.commit()

# Ruta para obtener datos de acciones populares
@finance_bp.route('/popular_stocks_data')
def get_popular_stocks_data():
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=10, type=int)
    
    start_index = (page - 1) * per_page
    acciones = Accion.query.offset(start_index).limit(per_page).all()
    
    end_date = datetime.now()
    start_date = end_date - timedelta(days=2)
    popular_stocks_data = {}
    
    for accion in acciones:
        ticker_symbol = accion.codigoticker
        ticker = yf.Ticker(ticker_symbol)
        data = ticker.history(start=start_date, end=end_date)
        if not data.empty:
            last_row = data.iloc[-1]
            stock_info = {
                'id': accion.id_accion, 
                'name': ticker.info.get('longName', 'Unknown'),
                'ticker_symbol': ticker_symbol,
                'current_price': last_row['Close'],
                'change': last_row['Close'] - last_row['Open'],
                'change_percent': ((last_row['Close'] - last_row['Open']) / last_row['Open']) * 100,
            }
            popular_stocks_data[accion.id_accion] = stock_info
        else:
            print(f"No hay datos disponibles para el ticker: {ticker_symbol}")
    
    return jsonify(list(popular_stocks_data.values()))

@finance_bp.route('/stock_data/<string:ticker_symbol>')
def get_stock_data(ticker_symbol):
    end_date = datetime.now()
    start_date = end_date - timedelta(days=2)  # Cambia este valor según lo que quieras mostrar
    
    ticker = yf.Ticker(ticker_symbol)
    data = ticker.history(start=start_date, end=end_date)
    
    if not data.empty:
        last_row = data.iloc[-1]
        stock_info = {
            'name': ticker.info.get('longName', 'Unknown'),
            'ticker_symbol': ticker_symbol,
            'current_price': last_row['Close'],
            'change': last_row['Close'] - last_row['Open'],
            'change_percent': ((last_row['Close'] - last_row['Open']) / last_row['Open']) * 100,
        }
        return jsonify(stock_info)
    else:
        return jsonify({'error': f"No hay datos disponibles para el ticker: {ticker_symbol}"}), 404


# Ruta para obtener acciones favoritas de un usuario
@finance_bp.route('/acciones_favs', methods=['GET'])
def get_acciones_favoritas_usuario():
    id_usuario = request.args.get('id_usuario', type=int)
    if not id_usuario:
        return jsonify({'error': 'Se requiere el ID de usuario'}), 400
    
    acciones_favoritas = AccionesFavoritas.query.filter_by(id_usuario=id_usuario).join(Accion).all()
    
    end_date = datetime.now()
    start_date = end_date - timedelta(days=2)
    favoritas_data = {}
    
    for favorita in acciones_favoritas:
        ticker_symbol = favorita.accion.codigoticker
        ticker = yf.Ticker(ticker_symbol)
        data = ticker.history(start=start_date, end=end_date)
        if not data.empty:
            last_row = data.iloc[-1]
            stock_info = {
                'id': favorita.accion.id_accion,
                'name': ticker.info['longName'],
                'ticker_symbol': ticker_symbol,
                'current_price': last_row['Close'],
                'change': last_row['Close'] - last_row['Open'],
                'change_percent': ((last_row['Close'] - last_row['Open']) / last_row['Open']) * 100,
            }
            favoritas_data[favorita.accion.id_accion] = stock_info
        else:
            print(f"No hay datos disponibles para el ticker: {ticker_symbol}")
            favoritas_data[favorita.accion.id_accion] = {'error': 'No hay datos disponibles'}
    
    return jsonify(list(favoritas_data.values()))

# Ruta para obtener datos históricos de una acción
@finance_bp.route('/historical_data')
def get_historical_data():
    ticker_symbol = request.args.get('symbol')
    interval = request.args.get('interval', default='1mo')  # Puede ser 1d, 1wk, 1mo, 3mo, 1y, etc.

    if not ticker_symbol:
        return jsonify(error='Se requiere el símbolo del ticker'), 400

    ticker = yf.Ticker(ticker_symbol)
    data = ticker.history(period=interval)
    data.fillna(0, inplace=True)
    data.index = data.index.strftime('%Y-%m-%d')

    return jsonify(data.to_dict(orient='index'))

# Ruta para agregar una acción a favoritos
@finance_bp.route('/agregar_accion_fav', methods=['POST'])
def agregar_accion_favorita():
    data = request.get_json()
    id_usuario = data.get('id_usuario')
    id_accion = data.get('id_accion')
    if not id_usuario or not id_accion:
        return jsonify({'error': 'Faltan datos para agregar a favoritos'}), 400
    nueva_favorita = AccionesFavoritas(id_usuario=id_usuario, id_accion=id_accion)
    db.session.add(nueva_favorita)
    db.session.commit()
    return jsonify({'mensaje': 'Acción agregada a favoritos con éxito'})

# Ruta para eliminar una acción de favoritos
@finance_bp.route('/eliminar_accion_fav', methods=['POST'])
def eliminar_accion_favorita():
    data = request.get_json()
    id_usuario = data.get('id_usuario')
    id_accion = data.get('id_accion')
    if not id_usuario or not id_accion:
        return jsonify({'error': 'Faltan datos para eliminar de favoritos'}), 400
    AccionesFavoritas.query.filter_by(id_usuario=id_usuario, id_accion=id_accion).delete()
    db.session.commit()
    return jsonify({'mensaje': 'Acción eliminada de favoritos con éxito'})


#---------------------------------------------------------
#-------------- Pagina mis acciones ----------------------

@finance_bp.route('/acciones_usuario', methods=['GET'])
def acciones_usuario():
    email = request.args.get('email')
    if not email:
        return jsonify({'error': 'Se requiere el parámetro email'}), 400
    
    # Busca el usuario por email
    usuario = Usuario.query.filter_by(email=email).first()
    if not usuario:
        return jsonify({'error': 'Usuario no encontrado'}), 404
    
    # Ahora, en lugar de filtrar Transaccion directamente por id_usuario,
    # debes obtener la cartera del usuario y luego filtrar las transacciones
    # basadas en el id_cartera.

    # Obtener el id de la cartera del usuario
    cartera_usuario = Cartera.query.filter_by(id_usuario=usuario.id).first()
    if not cartera_usuario:
        return jsonify({'error': 'Cartera no encontrada para el usuario'}), 404
    
    # Ahora puedes filtrar las transacciones basadas en el id_cartera de la cartera del usuario
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

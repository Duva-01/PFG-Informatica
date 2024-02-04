from flask import jsonify, request, Blueprint, current_app as app
from datetime import datetime, timedelta
import yfinance as yf

from app.models import Accion, AccionesFavoritas  
from ..extensions import db 

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

def actualizar_acciones_global_tickers():
    global_tickers = get_global_trending_tickers()

    for ticker_symbol in global_tickers:
        ticker = yf.Ticker(ticker_symbol)
        try:
            # Intenta obtener el nombre largo de la acción
            nombre = ticker.info.get('longName', None)
            if nombre:
                # Verifica si ya existe en la base de datos
                if not Accion.query.filter_by(codigoticker=ticker_symbol).first():
                    nueva_accion = Accion(nombre=nombre, codigoticker=ticker_symbol)
                    db.session.add(nueva_accion)
                    print(f"Añadiendo nueva acción: {nombre} ({ticker_symbol})")
        except Exception as e:
            print(f"No se pudo obtener la información para {ticker_symbol}: {e}")

    db.session.commit()

# ----------------------------------------------------------------------   
# ---------------------------------------------------------------------- 
# ----------------------------------------------------------------------

@finance_bp.route('/popular_stocks_data')
def get_popular_stocks_data():
    # Obtener parámetros de la solicitud
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=10, type=int)
    
    # Calcular el rango de acciones a cargar
    start_index = (page - 1) * per_page
    end_index = start_index + per_page
    
    # Consultar las acciones de la base de datos en el rango especificado
    acciones = Accion.query.offset(start_index).limit(per_page).all()
    
    end_date = datetime.now()
    start_date = end_date - timedelta(days=1)
    popular_stocks_data = {}
    
    for accion in acciones:
        ticker_symbol = accion.codigoticker
        ticker = yf.Ticker(ticker_symbol)
        data = ticker.history(start=start_date.strftime('%Y-%m-%d'), end=end_date.strftime('%Y-%m-%d'))
        
        if not data.empty:
            last_row = data.iloc[-1]
            stock_info = {
                'name': ticker.info.get('longName', 'Unknown'),  # Usar get para manejar la posibilidad de que 'longName' no esté disponible
                'ticker_symbol': ticker_symbol,
                'current_price': last_row['Close'],
                'change': last_row['Close'] - last_row['Open'],
                'change_percent': ((last_row['Close'] - last_row['Open']) / last_row['Open']) * 100,
            }
            popular_stocks_data[ticker_symbol] = stock_info
        else:
            print(f"No data available for ticker: {ticker_symbol}")
    
    return jsonify(popular_stocks_data)
pass

@finance_bp.route('/acciones_favs', methods=['GET'])
def get_acciones_favoritas_usuario(id_usuario):
    acciones_favoritas = AccionesFavoritas.query.filter_by(id_usuario=id_usuario).join(Accion).all()
    end_date = datetime.now()
    start_date = end_date - timedelta(days=1)
    
    favoritas_data = {}

    for favorita in acciones_favoritas:
        ticker_symbol = favorita.accion.codigoticker
        ticker = yf.Ticker(ticker_symbol)
        data = ticker.history(start=start_date.strftime('%Y-%m-%d'), end=end_date.strftime('%Y-%m-%d'))

        if not data.empty:
            last_row = data.iloc[-1]
            stock_info = {
                'name': ticker.info['longName'],
                'ticker_symbol': ticker_symbol,
                'current_price': last_row['Close'],
                'change': last_row['Close'] - last_row['Open'],
                'change_percent': ((last_row['Close'] - last_row['Open']) / last_row['Open']) * 100,
            }
            favoritas_data[ticker_symbol] = stock_info
        else:
            print(f"No data available for ticker: {ticker_symbol}")
            favoritas_data[ticker_symbol] = {'error': 'No data available'}

    return jsonify(favoritas_data)


@finance_bp.route('/historical_data')
def get_historical_data():
    ticker_symbol = request.args.get('symbol')
    interval = request.args.get('interval', default='1mo')  # Puede ser 1d, 1wk, 1mo, 3mo, 1y, etc.

    if not ticker_symbol:
        return jsonify(error='Ticker symbol is required'), 400

    ticker = yf.Ticker(ticker_symbol)
    data = ticker.history(period=interval)
    data.index = data.index.strftime('%Y-%m-%d')

    return jsonify(data.to_dict(orient='index'))
pass

@finance_bp.route('/agregar_accion_fav', methods=['POST'])
def agregar_accion_favorita(id_usuario, id_accion):
    nueva_favorita = AccionesFavoritas(id_usuario=id_usuario, id_accion=id_accion)
    db.session.add(nueva_favorita)
    db.session.commit()
    return jsonify({'mensaje': 'Acción agregada a favoritas con éxito'})

@finance_bp.route('/eliminar_accion_fav', methods=['POST'])
def eliminar_accion_favorita(id_usuario, id_accion):
    AccionesFavoritas.query.filter_by(id_usuario=id_usuario, id_accion=id_accion).delete()
    db.session.commit()
    return jsonify({'mensaje': 'Acción eliminada de favoritas con éxito'})




from flask import jsonify, request, current_app as app
from datetime import datetime, timedelta
import yfinance as yf


def get_ibex35_data():
    end_date = datetime.now()
    start_date = end_date - timedelta(days=30)
    ibex35 = yf.Ticker("^IBEX")

    data = ibex35.history(start=start_date.strftime('%Y-%m-%d'), end=end_date.strftime('%Y-%m-%d'))
    data.index = data.index.strftime('%Y-%m-%d')

    return jsonify(data.to_dict(orient='index'))
pass

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

def get_popular_stocks_data():
    page = request.args.get('page', default=1, type=int)  
    per_page = request.args.get('per_page', default=2, type=int) 
    global_tickers = get_global_trending_tickers()  # Obtén los símbolos de ticker globales
    
    # Pagina la lista de tickers primero
    start_index = (page - 1) * per_page
    end_index = start_index + per_page
    paginated_tickers = global_tickers[start_index:end_index]

    end_date = datetime.now()
    start_date = end_date - timedelta(days=1)  # Obtén datos del último día
    
    popular_stocks_data = {}
    for ticker_symbol in paginated_tickers:  # Itera solo sobre los tickers paginados
        ticker = yf.Ticker(ticker_symbol)
        data = ticker.history(start=start_date.strftime('%Y-%m-%d'), end=end_date.strftime('%Y-%m-%d'))
        if not data.empty:
            last_row = data.iloc[-1]
            stock_info = {
                'name': ticker.info['longName'],  # Nombre completo de la acción
                'ticker_symbol': ticker_symbol,  # Símbolo del ticker
                'current_price': last_row['Close'],
                'change': last_row['Close'] - last_row['Open'],
                'change_percent': ((last_row['Close'] - last_row['Open']) / last_row['Open']) * 100,
            }
            popular_stocks_data[ticker_symbol] = stock_info
        else:
            print(f"No data available for ticker: {ticker_symbol}")
            popular_stocks_data[ticker_symbol] = {'error': 'No data available'}

    # Ordena las acciones por cambio porcentual descendente
    popular_stocks_data_sorted = dict(sorted(popular_stocks_data.items(), key=lambda x: x[1].get('change_percent', 0), reverse=True))
    
    return jsonify(popular_stocks_data_sorted)

pass

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


def get_market_summary():
    try:
        resumen_mercado = calcularResumenMercado()
        return jsonify(resumen_mercado)
    except Exception as e:
        return jsonify(error=str(e)), 500
pass

def calcularResumenMercado():
    popular_tickers = get_global_trending_tickers()
    
    resumen_mercado = {
        "accion_mayor_incremento": "",
        "incremento": 0,
        "accion_mayor_caida": "",
        "caida": 0,
        "variacion_promedio": 0,
    }
    
    total_variacion = 0
    count = 0  # Contador para el número de acciones con datos disponibles
    
    end_date = datetime.now()
    start_date = end_date - timedelta(days=1)  # Obtén datos del último día
    
    for ticker_symbol in popular_tickers:
        ticker = yf.Ticker(ticker_symbol)
        data = ticker.history(start=start_date.strftime('%Y-%m-%d'), end=end_date.strftime('%Y-%m-%d'))
        if not data.empty:
            count += 1
            last_row = data.iloc[-1]
            variacion = last_row['Close'] - last_row['Open']
            total_variacion += variacion
            
            if variacion > resumen_mercado['incremento']:
                resumen_mercado['accion_mayor_incremento'] = ticker_symbol
                resumen_mercado['incremento'] = variacion
                
            if variacion < resumen_mercado['caida']:
                resumen_mercado['accion_mayor_caida'] = ticker_symbol
                resumen_mercado['caida'] = variacion
                
    if count > 0:  # Evita la división por cero
        resumen_mercado['variacion_promedio'] = total_variacion / count
        
    return resumen_mercado

pass
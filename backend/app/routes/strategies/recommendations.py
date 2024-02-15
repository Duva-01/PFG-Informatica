from flask import Blueprint, jsonify, request
import yfinance as yf
from datetime import datetime
from backtesting import Backtest
from app.routes.strategies.strategies import SmaCross, RsiStrategy, BollingerBandsStrategy, MACDStrategy, CCIStrategy, EMACrossStrategy, StochasticStrategy, OBVStrategy, HMAStrategy
import talib
import numpy as np  

from ...models import Usuario, Cartera, Accion, Transaccion

# Crea un Blueprint llamado 'recommendations' para gestionar las rutas relacionadas con las recomendaciones
recommendations_bp = Blueprint('recommendations', __name__)

# Ruta para obtener recomendaciones basadas en estrategias de trading
@recommendations_bp.route('/<string:symbol>', methods=['POST'])
def get_recommendation(symbol):

    # Obtiene los datos del cuerpo de la solicitud
    datos = request.json
    email = datos.get('email')  # Obtiene el correo electrónico del usuario de los datos de la solicitud
    usuario = Usuario.query.filter_by(email=email).first()  # Busca al usuario en la base de datos

    # Verifica si el usuario existe
    if not usuario:
        return jsonify({"error": "Usuario no encontrado"}), 404
    
    cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()  # Busca la cartera del usuario

    # Verifica si la cartera existe
    if not cartera:
        return jsonify({"error": "Cartera no encontrada"}), 404

    saldo = cartera.saldo  # Utiliza el saldo de la cartera como efectivo inicial

    data = yf.download(symbol, period="1y")  # Descarga datos de mercado para el símbolo especificado
    recommendation_details = []  # Lista para almacenar detalles de recomendaciones

    # Estrategias a evaluar
    strategies = [
        (SmaCross, "Cruce de Medias Móviles Simples", "Compra cuando la SMA rápida cruza por encima de la SMA lenta, y vende en el caso contrario."),
        (RsiStrategy, "Índice de Fuerza Relativa (RSI)", "Estrategia basada en el RSI. Compra por debajo de 30 (sobreventa) y vende por encima de 70 (sobrecompra)."),
        (BollingerBandsStrategy, "Bandas de Bollinger", "Compra cuando el precio cae por debajo de la banda inferior y vende cuando supera la banda superior."),
        (MACDStrategy, "Convergencia y Divergencia de Medias Móviles (MACD)", "Compra cuando la línea MACD cruza por encima de la línea de señal y vende cuando la línea MACD cruza por debajo."),
        (CCIStrategy, "Índice de Canal de Mercancía (CCI)", "Compra cuando el CCI sale de una condición de sobreventa y vende cuando el CCI sale de una condición de sobrecompra."),
        (EMACrossStrategy, "Cruce de Medias Móviles Exponenciales (EMA)", "Compra cuando la EMA rápida cruza por encima de la EMA lenta, y vende en el caso contrario."),
        (StochasticStrategy, "Índice de Fuerza Estocástica", "Vende en condiciones de sobrecompra y compra en condiciones de sobreventa."),
        (OBVStrategy, "Volumen de Balance (OBV)", "Compra cuando el OBV cruza por encima de su EMA y vende cuando cruza por debajo."),
        (HMAStrategy, "Media Móvil de Hull (HMA)", "Compra cuando el precio cruza por encima de la HMA y vende cuando cruza por debajo."),
    ]

    # Itera sobre cada estrategia
    for strategy_class, name, description in strategies:
        bt = Backtest(data, strategy_class, cash=saldo, commission=.002)  # Inicializa el backtest con la estrategia y el efectivo inicial
        stats = bt.run()  # Ejecuta el backtest y obtiene las estadísticas

        # Comprueba si la estrategia es rentable
        if stats['Equity Final [$]'] > saldo:
            result = "Recomendación de compra."
        else:
            result = "Sin recomendación clara."

        # Agrega detalles de la estrategia a la lista
        recommendation_details.append({
            "estrategia": name,
            "descripcion": description,
            "recomendacion": result,
            "equity_final": stats['Equity Final [$]'],
            "retorno": stats['Return [%]']
        })

    # Construye la recomendación final
    if recommendation_details:
        recommendation = "Recomendaciones: " + ", ".join([d['estrategia'] + ": " + d['recomendacion'] for d in recommendation_details])
    else:
        recommendation = "Mantener. No hay recomendaciones claras basadas en las estrategias aplicadas."

    # Retorna los resultados como un objeto JSON
    return jsonify({'symbol': symbol, 'recommendations': recommendation_details, 'summary': recommendation})

# Ruta para obtener indicadores técnicos para un símbolo dado
@recommendations_bp.route('/indicators/<string:symbol>', methods=['GET'])
def get_indicators(symbol):
    data = yf.download(symbol, start="2020-01-01", end=datetime.now().strftime("%Y-%m-%d"))  # Descarga datos de mercado para el símbolo desde el 1 de enero de 2020 hasta la fecha actual
    close_prices = data['Close'].values.astype(np.float64)  # Obtiene los precios de cierre como un array de punto flotante

    # Convierte otros arrays relevantes a punto flotante
    high_prices = data['High'].values.astype(np.float64)
    low_prices = data['Low'].values.astype(np.float64)
    open_prices = data['Open'].values.astype(np.float64)
    volume = data['Volume'].values.astype(np.float64)

    # Calcula algunos indicadores técnicos adicionales utilizando TA-Lib
    sma = talib.SMA(close_prices, timeperiod=20)
    ema = talib.EMA(close_prices, timeperiod=20)
    rsi = talib.RSI(close_prices, timeperiod=14)
    bb_upper, bb_middle, bb_lower = talib.BBANDS(close_prices, timeperiod=20)
    bop = talib.BOP(open_prices, high_prices, low_prices, close_prices)
    mfi = talib.MFI(high_prices, low_prices, close_prices, volume, timeperiod=14)
    p = talib.WILLR(high_prices, low_prices, close_prices, timeperiod=14)
    stddev = talib.STDDEV(close_prices, timeperiod=5)
    vwma = talib.WMA(close_prices, timeperiod=20)
    percent_r = talib.WILLR(high_prices, low_prices, close_prices, timeperiod=14)

    # Diccionario de indicadores y sus descripciones
    indicators = {
        'SMA': sma[-1],
        'EMA': ema[-1],
        'RSI': rsi[-1],
        'BB_Upper': bb_upper[-1],
        'BB_Middle': bb_middle[-1],
        'BB_Lower': bb_lower[-1],
        'BOP': bop[-1],
        'MFI': mfi[-1],
        'P': p[-1],
        'STDDEV': stddev[-1],
        'VWMA': vwma[-1],
        'Percent_R': percent_r[-1],
    }

    descriptions = {  # Descripciones de los indicadores
        'SMA': 'Promedio Móvil Simple (SMA) - promedio móvil simple de los últimos 20 periodos.',
        'EMA': 'Promedio Móvil Exponencial (EMA) - promedio móvil exponencial de los últimos 20 periodos.',
        'RSI': 'Índice de Fuerza Relativa (RSI) - mide la velocidad y cambio de los movimientos de precios.',
        'BB_Upper': 'Banda Superior de las Bandas de Bollinger - banda superior de las bandas de Bollinger.',
        'BB_Middle': 'Banda Media de las Bandas de Bollinger - banda media de las bandas de Bollinger.',
        'BB_Lower': 'Banda Inferior de las Bandas de Bollinger - banda inferior de las bandas de Bollinger.',
        'BOP': 'Balance of Power (BOP) - mide la relación entre el precio de cierre y el rango entre máximos y mínimos.',
        'MFI': 'Índice de Flujo de Dinero (MFI) - indica la entrada y salida de dinero en un valor.',
        'P': 'Williams %R (P) - indica la situación de sobrecompra o sobreventa de un activo.',
        'STDDEV': 'Desviación Estándar (STDDEV) - desviación estándar de los precios de cierre.',
        'VWMA': 'Promedio Móvil Ponderado por Volumen (VWMA) - promedio móvil ponderado por volumen.',
        'Percent_R': 'Williams %R (Percent_R) - indica la situación de sobrecompra o sobreventa de un activo.',
    }

    # Retorna los indicadores y sus descripciones como un objeto JSON
    return jsonify({'symbol': symbol, 'indicators': indicators, 'descriptions': descriptions})

# Ruta para realizar un backtest de una estrategia de trading para un símbolo dado
@recommendations_bp.route('/backtest/<string:symbol>', methods=['GET'])
def backtest(symbol):
    start_date = request.args.get('start', "2020-01-01")  # Obtiene la fecha de inicio de la solicitud (por defecto: 1 de enero de 2020)
    end_date = request.args.get('end', datetime.now().strftime("%Y-%m-%d"))  # Obtiene la fecha de finalización de la solicitud (por defecto: fecha actual)
    data = yf.download(symbol, start=start_date, end=end_date)  # Descarga datos de mercado para el símbolo y el rango de fechas especificado

    bt = Backtest(data, SmaCross, cash=10000, commission=.002)  # Inicializa el backtest con la estrategia de cruce de medias móviles simples y el efectivo inicial de $10,000
    stats = bt.run()  # Ejecuta el backtest y obtiene las estadísticas
    bt.plot()  # Genera un gráfico del backtest

    # Retorna un mensaje de éxito y las estadísticas del backtest como un objeto JSON
    return jsonify({'success': True, 'message': 'Backtesting completado', 'stats': stats._trade_data})

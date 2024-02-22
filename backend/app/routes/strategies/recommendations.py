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

    # Establece un saldo predeterminado de 10.000 € si no se encuentra el usuario
    if usuario:
        cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()
        saldo = cartera.saldo if cartera else 10000  # Si no hay cartera, usa 10.000 €
    else:
        saldo = 10000  # Saldo predeterminado si no se encuentra el usuario

    data = yf.download(symbol, period="1y")
    recommendation_details = []# Lista para almacenar detalles de recomendaciones

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
        bt = Backtest(data, strategy_class, cash=saldo, commission=.002)
        stats = bt.run()
        
        # Aquí identificas si la estrategia sugiere comprar, vender, o no hacer nada
        recommendation = "Sin recomendación clara."
        if stats['_trades'].empty:
            recommendation = "Sin recomendación clara debido a la ausencia de operaciones."
        else:
            last_trade = stats['_trades'].iloc[-1]
            if last_trade['Size'] > 0:
                recommendation = "Recomendación de compra."
            elif last_trade['Size'] < 0:
                recommendation = "Recomendación de venta."

        recommendation_details.append({
            "estrategia": name,
            "descripcion": description,
            "recomendacion": recommendation,
            "equity_final": stats['Equity Final [$]'],
            "retorno": stats['Return [%]']
        })

    if recommendation_details:
        recommendation_summary = "Recomendaciones: " + ", ".join(
            [d['estrategia'] + ": " + d['recomendacion'] for d in recommendation_details])
    else:
        recommendation_summary = "Mantener. No hay recomendaciones claras basadas en las estrategias aplicadas."

    return jsonify({'symbol': symbol, 'recommendations': recommendation_details, 'summary': recommendation_summary})

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


# ----------------------- Pagina de Analisis ------------------------------ #

def calcular_soportes_resistencias(df):
    # Obtiene los últimos 360 precios de cierre
    ultimos_360_precios = df["Close"].tail(360)
    # Calcula la media de los últimos 360 precios
    precio_medio = ultimos_360_precios.mean()
    # Calcula la desviación estándar de los precios
    std_precio = ultimos_360_precios.std()
    # Calcula los niveles de soporte y resistencia
    precio_soporte = precio_medio - std_precio
    precio_resistencia = precio_medio + std_precio
    # Obtiene el último precio de cierre
    ultimo_precio = df["Close"].iloc[-1]

    # Compara el último precio con los niveles de soporte y resistencia
    if ultimo_precio > precio_resistencia:
        estado = "resistencia"
        diferencia = ultimo_precio - precio_resistencia
    elif ultimo_precio < precio_soporte:
        estado = "soporte"
        diferencia = precio_soporte - ultimo_precio
    else:
        estado = "neutral"
        diferencia = 0

    # Mensajes basados en el análisis
    print(f"El último precio ({ultimo_precio}) está en {estado} con una diferencia de {diferencia}.")

    if estado == "resistencia":
        accion = "Vender"
    elif estado == "soporte":
        accion = "Comprar"
    else:
        accion = "Mantener/O Nada"

    return precio_soporte, precio_resistencia, estado, accion

@recommendations_bp.route('/analisis_tecnico/<string:simbolo>', methods=['GET'])
def obtener_analisis_tecnico(simbolo):

    intervalo = request.args.get('intervalo', '1y')  # Permite especificar el intervalo mediante parámetros URL

    ticker = yf.Ticker(simbolo)
    datos = ticker.history(period=intervalo)
    datos.fillna(0, inplace=True)
    datos.index = datos.index.strftime('%Y-%m-%d')

    # Aquí implementas la lógica para calcular soportes y resistencias
    precio_soporte, precio_resistencia, estado, accion_recomendada = calcular_soportes_resistencias(datos)

    # Prepara los datos para enviar, incluyendo tanto los datos históricos como el análisis técnico
    datos_analisis = {
        'simbolo': simbolo,
        'datos_historicos': datos.to_dict(orient='index'),  # Incluye los datos históricos en la respuesta
        'analisis_tecnico': {
            'precio_soporte': precio_soporte,
            'precio_resistencia': precio_resistencia,
            'estado': estado,
            'accion_recomendada': accion_recomendada
        }
    }
    
    return jsonify(datos_analisis)

@recommendations_bp.route('/simbolos-acciones', methods=['GET'])
def obtener_simbolos_acciones():
    try:
        # Consulta todos los códigos de ticker de la tabla de acciones
        acciones = Accion.query.with_entities(Accion.codigoticker).all()
        # Convierte la lista de tuplas en una lista de códigos de ticker
        codigos_ticker = [accion.codigoticker for accion in acciones]
        # Devuelve la lista de códigos de ticker como una respuesta JSON
        return jsonify({'codigos_ticker': codigos_ticker}), 200
    except Exception as e:
        return jsonify({'error': 'No se pudieron recuperar los códigos de ticker de las acciones', 'detalle': str(e)}), 500

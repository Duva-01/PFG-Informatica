# Importaciones
import math
from flask import Blueprint, jsonify, request, send_file
import yfinance as yf
from datetime import datetime
from backtesting import Backtest
from app.routes.strategies.strategies import SmaCross, RsiStrategy, BollingerBandsStrategy, MACDStrategy, CCIStrategy, EMACrossStrategy, StochasticStrategy, OBVStrategy, HMAStrategy

import talib
import numpy as np  
import sys
from ..marketController import get_historical_data
import pandas as pd
import json

from ...models import Usuario, Cartera, Accion, Transaccion
from ...auth_decorators import login_required_conditional

# Crea un Blueprint llamado 'recommendations' para gestionar las rutas relacionadas con las recomendaciones
recommendations_bp = Blueprint('recommendations', __name__)

# Ruta para obtener recomendaciones basadas en estrategias de trading
@recommendations_bp.route('/<string:symbol>', methods=['POST'])
@login_required_conditional
def recommendation_route(symbol):
    datos = request.json
    email = datos.get('email')
    return jsonify(get_recommendation(symbol, email))

def get_recommendation(symbol, email):
    usuario = Usuario.query.filter_by(email=email).first()

    if usuario:
        cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()
        saldo = cartera.saldo if cartera else 10000
    else:
        saldo = 10000

    data = yf.download(symbol, period="1y")
    recommendation_details = []

    strategies = [
        SmaCross,
        RsiStrategy,
        BollingerBandsStrategy,
        MACDStrategy,
        CCIStrategy,
        EMACrossStrategy,
        StochasticStrategy,
        OBVStrategy,
        HMAStrategy
    ]

    for strategy_class in strategies:
        bt = Backtest(data, strategy_class, cash=saldo, commission=.002)
        stats = bt.run()
        
        recommendation = "Sin recomendación clara."
        if not stats['_trades'].empty:
            last_trade = stats['_trades'].iloc[-1]
            if last_trade['Size'] > 0:
                recommendation = "Recomendación de compra."
            elif last_trade['Size'] < 0:
                recommendation = "Recomendación de venta."
        
        recommendation_details.append({
            "estrategia": strategy_class.name,
            "descripcion": strategy_class.description,
            "recomendacion": recommendation,
            "equity_final": stats['Equity Final [$]'],
            "retorno": stats['Return [%]']
        })

    if recommendation_details:
        recommendation_summary = "Recomendaciones: " + ", ".join(
            [d['estrategia'] + ": " + d['recomendacion'] for d in recommendation_details])
    else:
        recommendation_summary = "Mantener. No hay recomendaciones claras basadas en las estrategias aplicadas."

    return {'symbol': symbol, 'recommendations': recommendation_details, 'summary': recommendation_summary}


# Ruta para obtener indicadores técnicos para un símbolo dado
@recommendations_bp.route('/indicators/<string:symbol>', methods=['GET'])
@login_required_conditional
def get_indicators(symbol):
    data = yf.download(symbol, start="2020-01-01", end=datetime.now().strftime("%Y-%m-%d"))  # Descarga datos de mercado para el símbolo desde el 1 de enero de 2020 hasta la fecha actual
    close_prices = data['Close'].values.astype(np.float64)  # Obtiene los precios de cierre como un array de punto flotante

    # Convierte otros arrays relevantes a punto flotante
    high_prices = data['High'].values.astype(np.float64)
    low_prices = data['Low'].values.astype(np.float64)
    open_prices = data['Open'].values.astype(np.float64)
    volume = data['Volume'].values.astype(np.float64)

    # Algunos indicadores técnicos adicionales utilizando TA-Lib
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
@login_required_conditional
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


def resumir_datos(precios_cierre, frecuencia='M'):
    """
    Resumen los precios de cierre a una frecuencia semanal o mensual.

    :param precios_cierre: Serie de pandas con los precios de cierre diarios.
    :param frecuencia: 'W' para semanal, 'M' para mensual.
    :return: Serie de pandas con precios resumidos.
    """
    resumen = precios_cierre.resample(frecuencia).mean()  
    return resumen



def calcular_soportes_resistencias(precios_cierre, ventana=20, tolerancia=0.02):
    """
    Calcula soportes y resistencias significativos dentro de una serie de precios.

    :param precios_cierre: Serie de pandas con los precios de cierre.
    :param ventana: Número de días para considerar en la búsqueda de mínimos y máximos locales.
    :param tolerancia: Porcentaje de tolerancia para filtrar niveles cercanos.
    :return: listas de soportes y resistencias.
    """
    minimos = precios_cierre.rolling(window=ventana, center=True).min()
    maximos = precios_cierre.rolling(window=ventana, center=True).max()

    soportes = []
    resistencias = []

    for i in range(len(precios_cierre)):
        precio_actual = precios_cierre[i]
        min_local = minimos[i]
        max_local = maximos[i]

        if abs(precio_actual - min_local) / precio_actual < tolerancia:
            soportes.append(precio_actual)
        elif abs(precio_actual - max_local) / precio_actual < tolerancia:
            resistencias.append(precio_actual)

    # Filtrar soportes y resistencias para reducir la proximidad
    soportes_filtrados = filtrar_proximidad(soportes, tolerancia)
    resistencias_filtradas = filtrar_proximidad(resistencias, tolerancia)

    return soportes_filtrados, resistencias_filtradas

def filtrar_proximidad(niveles, tolerancia):
    """
    Filtra una lista de niveles (soportes o resistencias) para reducir aquellos que están muy próximos entre sí.

    :param niveles: Lista de niveles de soporte o resistencia.
    :param tolerancia: Porcentaje de tolerancia para determinar la proximidad.
    :return: Lista filtrada de niveles.
    """
    niveles_filtrados = []
    ultimo_nivel = None

    for nivel in sorted(niveles):
        if ultimo_nivel is None or abs(nivel - ultimo_nivel) / nivel > tolerancia:
            niveles_filtrados.append(nivel)
            ultimo_nivel = nivel

    return niveles_filtrados


@recommendations_bp.route('/analisis_tecnico/<string:simbolo>', methods=['GET'])
@login_required_conditional
def obtener_analisis_tecnico(simbolo):
    intervalo = request.args.get('intervalo', '1y')  

    ticker = yf.Ticker(simbolo)
    datos = ticker.history(period=intervalo)
    datos.fillna(0, inplace=True)
    datos.index = datos.index.strftime('%Y-%m-%d')

    if intervalo == '3y' or intervalo == '1y':
        datos_resumidos = resumir_datos(datos['Close'], 'M')
    else:
        datos_resumidos = datos['Close']

    soportes, resistencias = calcular_soportes_resistencias(datos_resumidos)

    # Calcular SMA20 y SMA50
    sma20 = datos_resumidos.rolling(window=20).mean().fillna(method='bfill')  # Reemplaza NaN con el próximo valor válido
    sma50 = datos_resumidos.rolling(window=50).mean().fillna(method='bfill')  # Reemplaza NaN con el próximo valor válido

    # Convierte la serie de pandas a lista, manejando NaN
    sma20_list = sma20.tolist()
    sma50_list = sma50.tolist()

    # Prepara los datos para enviar
    datos_analisis = {
        'simbolo': simbolo,
        'datos_historicos': datos.to_dict(orient='index'),
        'soportes': soportes,
        'resistencias': resistencias,
        'sma20': sma20_list,
        'sma50': sma50_list,
    }

    return jsonify(datos_analisis)

def limpiar_valores_nan(datos):
    if isinstance(datos, dict):
        for k, v in datos.items():
            if isinstance(v, float) and math.isnan(v):
                datos[k] = 0  # o None si prefieres representar NaN como null en JSON
            elif isinstance(v, dict):
                datos[k] = limpiar_valores_nan(v)  # Llamada recursiva para diccionarios anidados
    return datos

@recommendations_bp.route('/analisis_fundamental/<string:simbolo>', methods=['GET'])
@login_required_conditional
def obtener_analisis_fundamental(simbolo):
    ticker = yf.Ticker(simbolo)
    info = ticker.info

    # Ratios financieros clave
    pe_ratio = info.get('trailingPE', 0)
    eps = info.get('epsTrailingTwelveMonths', 0)
    roi = info.get('returnOnEquity', 0)

    # Rendimiento del dividendo
    dividend_yield = info.get('dividendYield', 0) * 100 if info.get('dividendYield') is not None else 0

    # Resumen financiero
    ultimo_balance = {k: v for k, v in ticker.balance_sheet.iloc[:, 0].to_dict().items() if v != 0} if not ticker.balance_sheet.empty else {}
    ultimos_ingresos = {k: v for k, v in ticker.financials.iloc[:, 0].to_dict().items() if v != 0} if not ticker.financials.empty else {}

    analisis_fundamental = {
        'PE Ratio': pe_ratio,
        'EPS': eps,
        'ROI': roi,
        'Rendimiento Dividendo (%)': dividend_yield,
        'Último Balance': ultimo_balance,
        'Últimos Ingresos': ultimos_ingresos,
    }

    analisis_fundamental_limpio = limpiar_valores_nan(analisis_fundamental)

    return jsonify(analisis_fundamental_limpio)



@recommendations_bp.route('/simbolos-acciones', methods=['GET'])
@login_required_conditional
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


#-----------------------------------------------------------------------

from statsmodels.tsa.arima.model import ARIMA


def generar_predicciones_precio(symbol):
    # Creo un modelo ARIMA basado en datos históricos de precios utilizando mi símbolo favorito
    data = yf.download(symbol, period="2y")
    
    # Extraigo precios de cierre y los convierto a tipo flotante
    precios_cierre = data['Close'].astype(float)
    
    # Ajusto la frecuencia de los precios de cierre a días laborables, porque es más realista
    precios_cierre = precios_cierre.asfreq('B')  # 'B' representa días laborables

    # Creo un modelo ARIMA y lo ajusto a mis datos para hacer predicciones de precios
    modelo_arima = ARIMA(precios_cierre, order=(5,1,0))
    modelo_ajustado = modelo_arima.fit()

    # Decido cuántos días quiero predecir hacia el futuro
    n_dias = 30
    
    # Hago mis propias predicciones de precios para los próximos 'n_dias' días
    pronostico = modelo_ajustado.forecast(steps=n_dias)

    # Creo fechas futuras para mis predicciones
    fechas_futuras = pd.date_range(start=precios_cierre.index[-1], periods=n_dias + 1)
    
    # Filtro y excluyo los valores NaN de mis predicciones, porque no me gustan los datos incorrectos
    predicciones = pd.Series(pronostico, index=fechas_futuras)
    predicciones_filtradas = {fecha.strftime("%Y-%m-%dT%H:%M:%S"): valor for fecha, valor in predicciones.items() if not math.isnan(valor)}

    return predicciones_filtradas

def generar_recomendacion_final(precio_actual, data_recomendaciones, soportes, resistencias, indicadores_economicos, predicciones_precio):
    recomendacion_final = "Mantener"
    precio_compra_recomendado = None
    precio_venta_recomendado = None
    explicaciones = []
    puntos_compra = 0
    puntos_venta = 0

    # Evaluar recomendaciones de estrategias
    for estrategia in data_recomendaciones.get('recommendations', []):
        if estrategia['recomendacion'] == "Recomendación de compra.":
            puntos_compra += 1
        elif estrategia['recomendacion'] == "Recomendación de venta.":
            puntos_venta += 1


    # Evaluar indicadores técnicos
    rsi = indicadores_economicos['RSI']
    if rsi is not None:
        if rsi < 30:
            puntos_compra += 2  # Aumento de puntos si el indicador es muy fuerte
            explicaciones.append(f"El RSI está en {rsi}, indicando que el activo está sobrevendido. Esto sugiere un buen momento para comprar.")
        elif rsi > 70:
            puntos_venta += 2
            explicaciones.append(f"El RSI está en {rsi}, indicando que el activo está sobrecomprado. Esto sugiere un buen momento para vender.")

    # Bandas de Bollinger
    bb_lower = indicadores_economicos['BB_Lower']
    bb_middle = indicadores_economicos['BB_Middle']
    bb_upper = indicadores_economicos['BB_Upper']
    if bb_upper is not None and precio_actual > bb_upper:
            puntos_venta += 1
            explicaciones.append("El precio está por encima de la banda superior de Bollinger, lo que puede indicar una condición de sobrecompra.")
    if bb_lower is not None and precio_actual < bb_lower:
            puntos_compra += 1
            explicaciones.append("El precio está por debajo de la banda inferior de Bollinger, lo que puede indicar una condición de sobreventa.")

    # MFI y Percent R
    mfi = indicadores_economicos['MFI']
    if mfi is not None:
        if mfi < 20:
            puntos_compra += 1
            explicaciones.append("El MFI es bajo, indicando que el activo podría estar sobrevendido y puede ser un buen momento para comprar.")
        elif mfi > 80:
            puntos_venta += 1
            explicaciones.append("El MFI es alto, indicando que el activo podría estar sobrecomprado y puede ser un buen momento para vender.")
    
    percent_r = indicadores_economicos['Percent_R']
    if percent_r is not None:
        if percent_r < -80:
            puntos_compra += 1
            explicaciones.append("El indicador Williams %R sugiere que el mercado está sobrevendido, potencialmente ofreciendo un buen punto de entrada para comprar.")
        elif percent_r > -20:
            puntos_venta += 1
            explicaciones.append("El indicador Williams %R sugiere que el mercado está sobrecomprado, potencialmente ofreciendo un buen punto para vender.")

    # Evaluar soportes y resistencias
    if soportes:
        precio_soporte_cercano = min(soportes)
        precio_compra_recomendado = precio_soporte_cercano * 0.98
        puntos_compra += 1
        explicaciones.append(f"El precio actual está cerca de un soporte en {precio_soporte_cercano:.2f}, recomendando comprar a {precio_compra_recomendado:.2f}, ligeramente por debajo para asegurar margen.")
    if resistencias:
        precio_resistencia_cercano = max(resistencias)
        precio_venta_recomendado = precio_resistencia_cercano * 1.02
        puntos_venta += 1
        explicaciones.append(f"El precio actual está cerca de una resistencia en {precio_resistencia_cercano:.2f}, recomendando vender a {precio_venta_recomendado:.2f}, ligeramente por encima para capturar ganancias potenciales.")

    # Evaluar predicciones de precio
    precios_futuros = list(predicciones_precio.values())
    if precios_futuros:
        promedio_precio_futuro = sum(precios_futuros) / len(precios_futuros)
        tendencia = "comprar" if promedio_precio_futuro > precio_actual else "vender"
        explicaciones.append(f"Las predicciones futuras de precios muestran una tendencia a {tendencia}, basado en un precio promedio futuro de {promedio_precio_futuro:.2f} comparado con el actual de {precio_actual:.2f}.")
        if promedio_precio_futuro > precio_actual:
            puntos_compra += 1  # Tendencia a aumentar
        else:
            puntos_venta += 1  # Tendencia a disminuir

    # Decidir recomendación final basada en puntos
    if puntos_compra > puntos_venta:
        recomendacion_final = "Comprar"
    elif puntos_venta > puntos_compra:
        recomendacion_final = "Vender"

    return {
        "recomendacion": recomendacion_final,
        "precio_compra_recomendado": precio_compra_recomendado,
        "precio_venta_recomendado": precio_venta_recomendado,
        "explicaciones": explicaciones  # Lista de razones detalladas
    }



@recommendations_bp.route('/analisis_completo/<string:simbolo>', methods=['GET'])
@login_required_conditional
def obtener_recomendacion_completa(simbolo):
    
    email = request.args.get('email', 'default@email.com')  # Obtiene el email desde los parámetros de consulta, con un valor predeterminado
    try:
        # Usa el email obtenido como argumento
        recomendaciones_estrategias = get_recommendation(simbolo, email)
        #print(f"Recomendacion estrategias: {recomendaciones_estrategias}", file=sys.stderr)
        
    except Exception as e:
        print(f"Error al obtener recomendaciones estratégicas: {e}", file=sys.stderr)
        recomendaciones_estrategias = "Error al obtener recomendaciones estratégicas"

    try:
        # Descargar datos de yfinance y calcular soportes y resistencias
        data = yf.download(simbolo, period="1y")
        precios_cierre = data['Close']
        soportes, resistencias = calcular_soportes_resistencias(precios_cierre)
        # Convertir soportes y resistencias a listas simples si no lo son ya
        soportes = list(soportes)
        resistencias = list(resistencias)
    except Exception as e:
        print(f"Error al descargar datos o calcular soportes y resistencias: {e}")
        soportes, resistencias = [], []

    try:
        # Integrar indicadores económicos
        indicadores_economicos_respuesta = get_indicators(simbolo)
        indicadores_economicos = indicadores_economicos_respuesta.get_json() 

    except Exception as e:
        print(f"Error al obtener indicadores económicos: {e}")
        indicadores_economicos = "Error al obtener indicadores económicos"
    try:
        # Generar predicciones de precios futuros
        predicciones_precio = generar_predicciones_precio(simbolo)
        
        # Generar_predicciones_precio devuelve un diccionario serializable a JSON
    except Exception as e:
        print(f"Error al generar predicciones de precios: {e}", file=sys.stderr)
        predicciones_precio = "Error al generar predicciones de precios"

    # Compilar toda la información en una estructura de datos para enviar al frontend
    resultado = {
        'precio_actual': data['Close'][-1] if 'data' in locals() else "No disponible",
        'recomendaciones_estrategias': recomendaciones_estrategias,
        'soportes': soportes,
        'resistencias': resistencias,
        'indicadores_economicos': indicadores_economicos,
        'predicciones_precio': predicciones_precio,
    }

    # Llamar a la función para generar la recomendación final
    recomendacion_final = generar_recomendacion_final(
        precio_actual=resultado['precio_actual'],
        data_recomendaciones=recomendaciones_estrategias,
        soportes=soportes,
        resistencias=resistencias,
        indicadores_economicos=indicadores_economicos['indicators'],  
        predicciones_precio=predicciones_precio
    )


    # Añadir la recomendación final al resultado
    resultado['recomendacion_final'] = recomendacion_final

    return jsonify(resultado)

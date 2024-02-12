from flask import Blueprint, jsonify, request
import yfinance as yf
from datetime import datetime
from backtesting import Backtest
from strategies import SmaCross, RsiStrategy  # Asegúrate de importar tus estrategias aquí

recommendations_bp = Blueprint('recommendations', __name__)

@recommendations_bp.route('/<string:symbol>')
def get_recommendation(symbol):
    # Aquí implementarías la lógica para escoger y aplicar distintas estrategias
    data = yf.download(symbol, period="1mo")
    recommendation_details = []

    # Ejemplo de cómo aplicar y justificar la estrategia SMA Cross
    bt_sma = Backtest(data, SmaCross, cash=10000, commission=.002)
    stats_sma = bt_sma.run()
    if stats_sma['Equity Final [$]'] > 10000:
        recommendation_details.append("Comprar basado en SMA Cross debido al incremento del capital final.")

    # Ejemplo de cómo aplicar y justificar la estrategia RSI
    bt_rsi = Backtest(data, RsiStrategy, cash=10000, commission=.002)
    stats_rsi = bt_rsi.run()
    if stats_rsi['Equity Final [$]'] > 10000:
        recommendation_details.append("Comprar basado en RSI debido al incremento del capital final.")

    # Puedes agregar más estrategias y sus justificaciones aquí

    if recommendation_details:
        recommendation = "Recomendaciones: " + " | ".join(recommendation_details)
    else:
        recommendation = "Mantener. No hay recomendaciones claras basadas en las estrategias aplicadas."

    return jsonify({'symbol': symbol, 'recommendation': recommendation})


@recommendations_bp.route('/backtest/<string:symbol>', methods=['GET'])
def backtest(symbol):
    start_date = request.args.get('start', "2020-01-01")
    end_date = request.args.get('end', datetime.now().strftime("%Y-%m-%d"))
    data = yf.download(symbol, start=start_date, end=end_date)

    bt = Backtest(data, SmaCross, cash=10000, commission=.002)
    stats = bt.run()
    bt.plot()

    return jsonify({'success': True, 'message': 'Backtesting completado', 'stats': stats._trade_data})

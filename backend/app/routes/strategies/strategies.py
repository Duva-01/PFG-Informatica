from backtesting import Strategy  # Importa la clase Strategy desde el módulo backtesting
from backtesting.lib import crossover  # Importa la función crossover del módulo backtesting.lib
from backtesting.test import SMA  # Importa la clase SMA desde el módulo backtesting.test
from talib import RSI, BBANDS, MACD, CCI, EMA, STOCH, OBV, WMA  # Importa los indicadores técnicos de TA-Lib
import numpy as np  # Importa numpy para operaciones numéricas

# Documentación en: https://kernc.github.io/backtesting.py/doc/backtesting/backtesting.html#backtesting.backtesting.Strategy

# Define una estrategia de cruce de medias móviles simples (SMA Cross)
class SmaCross(Strategy):
    n1 = 10
    n2 = 20
    name = "Cruce de Medias Móviles Simples"
    description = "Compra cuando la SMA rápida cruza por encima de la SMA lenta, y vende en el caso contrario."

    # Inicializa la estrategia
    def init(self):
        close = self.data.Close
        # Calcula las medias móviles simples (SMA) con los periodos n1 y n2
        self.sma1 = self.I(SMA, close, self.n1)
        self.sma2 = self.I(SMA, close, self.n2)

    # Define la lógica de la estrategia
    def next(self):
        if crossover(self.sma1, self.sma2):
            self.buy()
        elif crossover(self.sma2, self.sma1):
            self.sell()

# Define una estrategia basada en el Índice de Fuerza Relativa (RSI)
class RsiStrategy(Strategy):
    name = "Índice de Fuerza Relativa (RSI)"
    description = "Estrategia basada en el RSI. Compra por debajo de 30 (sobreventa) y vende por encima de 70 (sobrecompra)."

    def init(self):
        close = self.data.Close
        # Calcula el RSI con un período de 14
        self.rsi = self.I(RSI, close, timeperiod=14)

    def next(self):
        if self.rsi[-1] < 30:
            self.buy()
        elif self.rsi[-1] > 70:
            self.sell()

# Define una estrategia basada en las Bandas de Bollinger
class BollingerBandsStrategy(Strategy):
    name = "Bandas de Bollinger"
    description = "Compra cuando el precio cae por debajo de la banda inferior y vende cuando supera la banda superior."

    def init(self):
        close = self.data.Close
        # Calcula las Bandas de Bollinger con un período de 20
        self.upper, self.middle, self.lower = self.I(BBANDS, close, timeperiod=20)

    def next(self):
        if self.data.Close[-1] < self.lower[-1]:
            self.buy()
        elif self.data.Close[-1] > self.upper[-1]:
            self.sell()

# Define una estrategia basada en la Convergencia y Divergencia de Medias Móviles (MACD)
class MACDStrategy(Strategy):
    name = "Convergencia y Divergencia de Medias Móviles (MACD)"
    description = "Compra cuando la línea MACD cruza por encima de la línea de señal y vende cuando la línea MACD cruza por debajo."

    def init(self):
        close = self.data.Close
        # Calcula el MACD con periodos rápidos y lentos de 12 y 26 respectivamente, y un período de señal de 9
        self.macd, self.signal, _ = self.I(MACD, close, fastperiod=12, slowperiod=26, signalperiod=9)

    def next(self):
        if crossover(self.macd, self.signal):
            self.buy()
        elif crossover(self.signal, self.macd):
            self.sell()

# Define una estrategia basada en el Índice de Canal de Mercancía (CCI)
class CCIStrategy(Strategy):
    name = "Índice de Canal de Mercancía (CCI)"
    description = "Compra cuando el CCI sale de una condición de sobreventa y vende cuando el CCI sale de una condición de sobrecompra."

    def init(self):
        high = self.data.High
        low = self.data.Low
        close = self.data.Close
        # Calcula el CCI con un período de 20
        self.cci = self.I(CCI, high, low, close, timeperiod=20)

    def next(self):
        if self.cci[-1] > 100 and self.cci[-2] <= 100:
            self.sell()
        elif self.cci[-1] < -100 and self.cci[-2] >= -100:
            self.buy()

# Define una estrategia de cruce de medias móviles exponenciales (EMA Cross)
class EMACrossStrategy(Strategy):
    name = "Cruce de Medias Móviles Exponenciales (EMA)"
    description = "Compra cuando la EMA rápida cruza por encima de la EMA lenta, y vende en el caso contrario."

    n_fast = 12
    n_slow = 26

    def init(self):
        close = self.data.Close
        # Calcula las medias móviles exponenciales (EMA) con periodos rápidos y lentos de 12 y 26 respectivamente
        self.ema_fast = self.I(EMA, close, timeperiod=self.n_fast)
        self.ema_slow = self.I(EMA, close, timeperiod=self.n_slow)

    def next(self):
        if crossover(self.ema_fast, self.ema_slow):
            self.buy()
        elif crossover(self.ema_slow, self.ema_fast):
            self.sell()

# Define una estrategia basada en el Índice de Fuerza Estocástica
class StochasticStrategy(Strategy):
    name = "Índice de Fuerza Estocástica"
    description = "Vende en condiciones de sobrecompra y compra en condiciones de sobreventa."

    def init(self):
        high = self.data.High
        low = self.data.Low
        close = self.data.Close
        # Calcula el Estocástico con los parámetros predeterminados
        self.k, self.d = self.I(STOCH, high, low, close)

    def next(self):
        if self.k[-1] > 80 and self.d[-1] > 80 and crossover(self.k, self.d):
            self.sell()
        elif self.k[-1] < 20 and self.d[-1] < 20 and crossover(self.d, self.k):
            self.buy()

# Define una estrategia basada en el Volumen de Balance (OBV)
class OBVStrategy(Strategy):
    name = "Volumen de Balance (OBV)"
    description = "Compra cuando el OBV cruza por encima de su EMA y vende cuando cruza por debajo."

    def init(self):
        close = self.data.Close.astype(np.float64)
        volume = self.data.Volume.astype(np.float64)
        # Calcula el OBV con un período de 20
        self.obv = self.I(OBV, close, volume)

    def next(self):
        if crossover(self.obv, EMA(self.obv, 20)):
            self.buy()
        elif crossover(EMA(self.obv, 20), self.obv):
            self.sell()

# Define una estrategia basada en la Media Móvil de Hull (HMA)
class HMAStrategy(Strategy):
    name = "Media Móvil de Hull (HMA)"
    description = "Compra cuando el precio cruza por encima de la HMA y vende cuando cruza por debajo."

    def init(self):
        close = self.data.Close
        # Calcula la HMA con parámetros personalizados
        self.hma = self.I(lambda x: WMA(2*WMA(x, int(len(x)/2)) - WMA(x, len(x)), int(np.sqrt(len(x)))), close)

    def next(self):
        if crossover(self.hma, self.data.Close):
            self.buy()
        elif crossover(self.data.Close, self.hma):
            self.sell()

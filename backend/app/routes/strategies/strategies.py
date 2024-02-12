from backtesting import Strategy
from backtesting.lib import crossover
from backtesting.test import SMA
from talib import RSI


# Documentación en: https://kernc.github.io/backtesting.py/doc/backtesting/backtesting.html#backtesting.backtesting.Strategy
class SmaCross(Strategy):
    n1 = 10
    n2 = 20

    def init(self):
        close = self.data.Close
        # Esto es para crear indicadores, podemos usar los de ta-lib tal y como viene en la documentación
        self.sma1 = self.I(SMA, close, self.n1)
        self.sma2 = self.I(SMA, close, self.n2)

    def next(self):
        if crossover(self.sma1, self.sma2):
            self.buy()
        elif crossover(self.sma2, self.sma1):
            self.sell()

class RsiStrategy(Strategy):
    def init(self):
        close = self.data.Close
        self.rsi = self.I(RSI, close, timeperiod=14)

    def next(self):
        if self.rsi[-1] < 30:
            self.buy()
        elif self.rsi[-1] > 70:
            self.sell()
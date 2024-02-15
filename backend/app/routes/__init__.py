from .finance_data import finance_bp  # Importar el blueprint para datos financieros
from .auth import auth_bp  # Importar el blueprint para autenticación
from .news import news_bp  # Importar el blueprint para noticias
from .home import home_bp  # Importar el blueprint para la página de inicio
from .portfolio import portfolio_bp  # Importar el blueprint para la cartera
from .strategies.recommendations import recommendations_bp

def register_blueprints(app):
    # Registrar los blueprints en la aplicación Flask
    app.register_blueprint(finance_bp, url_prefix='/finance')  # Registrar el blueprint de datos financieros con prefijo de URL '/finance'
    app.register_blueprint(auth_bp, url_prefix='/auth')  # Registrar el blueprint de autenticación con prefijo de URL '/auth'
    app.register_blueprint(news_bp, url_prefix='/news')  # Registrar el blueprint de noticias con prefijo de URL '/news'
    app.register_blueprint(portfolio_bp, url_prefix='/portfolio')  # Registrar el blueprint de la cartera con prefijo de URL '/portfolio'
    app.register_blueprint(recommendations_bp, url_prefix='/recommendations')  # Registrar el blueprint de la cartera con prefijo de URL '/recomendations'  
    app.register_blueprint(home_bp)  # Registrar el blueprint de la página de inicio sin prefijo de URL


from .marketController import finance_bp  # Importar el blueprint para datos financieros
from .userController import auth_bp  # Importar el blueprint para autenticación
from .newsController import news_bp  # Importar el blueprint para noticias
from .home import home_bp  # Importar el blueprint para la página de inicio
from .portfolioController import portfolio_bp  # Importar el blueprint para la cartera
from .articlesController import article_bp # Importar el blueprint para los articulos
from .strategies.recommendationsController import recommendations_bp # Importar el blueprint para las recomendaciones

# Registrar los blueprints en la aplicación Flask
def register_blueprints(app):
    
    app.register_blueprint(finance_bp, url_prefix='/finance')  # Registrar el blueprint de datos financieros con prefijo de URL '/finance'
    app.register_blueprint(auth_bp, url_prefix='/auth')  # Registrar el blueprint de autenticación con prefijo de URL '/auth'
    app.register_blueprint(news_bp, url_prefix='/news')  # Registrar el blueprint de noticias con prefijo de URL '/news'
    app.register_blueprint(portfolio_bp, url_prefix='/portfolio')  # Registrar el blueprint de la cartera con prefijo de URL '/portfolio'
    app.register_blueprint(recommendations_bp, url_prefix='/recommendations')  # Registrar el blueprint de la cartera con prefijo de URL '/recomendations' 
    app.register_blueprint(article_bp, url_prefix='/articles')  # Registrar el blueprint de la cartera con prefijo de URL '/recomendations'   
    app.register_blueprint(home_bp)  # Registrar el blueprint de la página de inicio sin prefijo de URL


# Importaciones necesarias
from flask import Flask
from flask_cors import CORS
from flask_admin import Admin
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_mail import Mail
from flask_socketio import SocketIO
from flask_admin.contrib.sqla import ModelView
from dotenv import load_dotenv
import os

# Importaciones locales
from .extensions import db, login_manager
from .models import Usuario, Accion, AccionesFavoritas, Cartera, Transaccion, ArticulosAprendizaje, AccionesFavoritasModelView, Notificacion
from .routes import register_blueprints
from .scheduler import configura_tareas, logger
from .socketIO_config import socketio

from .models import MyModelView, MyAdminIndexView
from datetime import timedelta

# Cargar las variables de entorno desde el archivo .env
load_dotenv()

# Función para crear la aplicación de Flask y configurar tanto las extensiones, como los sockets... etc
def create_app():
    app = Flask(__name__)
    configure_app(app)
    init_extensions(app)
    init_admin(app)
    init_socketio(app)
    configura_tareas(app)

    return app

# Función para configurar la instancia de la aplicación Flask.
def configure_app(app):
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('SQLALCHEMY_DATABASE_URI')
    app.config['MAIL_SERVER'] = os.getenv('MAIL_SERVER')
    app.config['MAIL_PORT'] = int(os.getenv('MAIL_PORT'))
    app.config['MAIL_USE_TLS'] = os.getenv('MAIL_USE_TLS') == 'True'
    app.config['MAIL_USERNAME'] = os.getenv('MAIL_USERNAME')
    app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD')
    app.config['MAIL_DEFAULT_SENDER'] = os.getenv('MAIL_DEFAULT_SENDER')
    app.config['SESSION_PERMANENT'] = False  # Hace que la sesión no sea permanente
    app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=5)  # Tiempo de vida de la sesión

# Configura y añade vistas al componente Flask-Admin.
def init_admin(app):
    admin = Admin(app, name='Grownomics', template_mode='bootstrap3', index_view=MyAdminIndexView())  # Crear una instancia de Admin con el nombre 'Grownomics' y el modo de plantilla 'bootstrap3'
    admin.add_view(MyModelView(Usuario, db.session))  # Agregar una vista para el modelo Usuario
    admin.add_view(MyModelView(Cartera, db.session, name='Cartera'))  # Agregar una vista para el modelo Cartera con el nombre 'Cartera'
    admin.add_view(MyModelView(Transaccion, db.session, name='Transaccion'))  # Agregar una vista para el modelo Transaccion con el nombre 'Transaccion'
    admin.add_view(MyModelView(Notificacion, db.session, name='Notificaciones'))
    admin.add_view(MyModelView(Accion, db.session, name='Accion'))  # Agregar una vista para el modelo Accion con el nombre 'Accion'
    admin.add_view(AccionesFavoritasModelView(AccionesFavoritas, db.session, name='Acciones Favoritas'))  # Agregar una vista personalizada para el modelo AccionesFavoritas con el nombre 'Acciones Favoritas'
    admin.add_view(MyModelView(ArticulosAprendizaje, db.session, name='Artículos de Aprendizaje'))

# Función que asocia Flask-SocketIO con la aplicación Flask.
def init_socketio(app):
    socketio.init_app(app, cors_allowed_origins="*")

# Función que inicializa las extensiones Flask con la aplicación.
def init_extensions(app):
    db.init_app(app)
    login_manager.init_app(app)
    login_manager.login_view = 'web_auth.login'
    login_manager.login_message = "Please log in to access this page."
    login_manager.login_message_category = "info"
    CORS(app)
    Mail(app)

    # Función para cargar un usuario
    @login_manager.user_loader
    def load_user(user_id):
        return Usuario.query.get(int(user_id))

    register_blueprints(app)  # Registrar los blueprints en la aplicación

# Esto sirve para rellenar la base de datos de las acciones
# from app.routes.finance_data import actualizar_acciones_global_tickers
# with app.app_context():
#    actualizar_acciones_global_tickers()

app = create_app()

# Ejecutar la aplicación si se ejecuta este script directamente
if __name__ == '__main__':
    #app.run(debug=True, host='0.0.0.0', port=5000)
    socketio.run(app, debug=True, host='0.0.0.0', port=5000)

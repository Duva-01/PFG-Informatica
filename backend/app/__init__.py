# Importaciones necesarias
from flask import Flask
from flask_cors import CORS
from flask_admin import Admin
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_mail import Mail
from flask_socketio import SocketIO
from flask_admin.contrib.sqla import ModelView  

# Importaciones locales
from .extensions import db, login_manager
from .models import Usuario, Accion, AccionesFavoritas, Cartera, Transaccion, ArticulosAprendizaje, AccionesFavoritasModelView, Notificacion
from .routes import register_blueprints
from .scheduler import configura_tareas, logger
from .socketIO_config import socketio

# Funcion para crearme la aplicacionde Flask y configurar tanto las extensions, como los sockets... etc
def create_app():
    app = Flask(__name__)
    configure_app(app)
    init_extensions(app)
    init_admin(app)
    init_socketio(app)
    configura_tareas(app)

    return app

# Funcion para configurar la instancia de la aplicación Flasks.
def configure_app(app):
    app.config['SECRET_KEY'] = 'una_clave_secreta_muy_segura'
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:example@grownomics-db/grownomics_db'
    app.config['MAIL_SERVER'] = 'smtp.gmail.com'
    app.config['MAIL_PORT'] = 587
    app.config['MAIL_USE_TLS'] = True
    app.config['MAIL_USERNAME'] = 'grownomicss@gmail.com'
    app.config['MAIL_PASSWORD'] = 'mqkj rwox ekmn celf'
    app.config['MAIL_DEFAULT_SENDER'] = 'grownomicss@gmail.com'

#Configura y añade vistas al componente Flask-Admin.
def init_admin(app):
    admin = Admin(app, name='Grownomics', template_mode='bootstrap3')  # Crear una instancia de Admin con el nombre 'Grownomics' y el modo de plantilla 'bootstrap3'
    admin.add_view(ModelView(Usuario, db.session))  # Agregar una vista para el modelo Usuario
    admin.add_view(ModelView(Cartera, db.session, name='Cartera'))  # Agregar una vista para el modelo Cartera con el nombre 'Cartera'
    admin.add_view(ModelView(Transaccion, db.session, name='Transaccion'))  # Agregar una vista para el modelo Transaccion con el nombre 'Transaccion'
    admin.add_view(ModelView(Notificacion, db.session, name='Notificaciones'))
    admin.add_view(ModelView(Accion, db.session, name='Accion'))  # Agregar una vista para el modelo Accion con el nombre 'Accion'
    admin.add_view(AccionesFavoritasModelView(AccionesFavoritas, db.session, name='Acciones Favoritas'))  # Agregar una vista personalizada para el modelo AccionesFavoritas con el nombre 'Acciones Favoritas'
    admin.add_view(ModelView(ArticulosAprendizaje, db.session, name='Artículos de Aprendizaje'))
    
# Funcion que asocia Flask-SocketIO con la aplicación Flask.
def init_socketio(app):
    socketio.init_app(app, cors_allowed_origins="*")

# Función que inicializa las extensiones Flask con la aplicación.
def init_extensions(app):
    db.init_app(app)
    login_manager.init_app(app)
    CORS(app)
    Mail(app)

    # Función para cargar un usuario
    @login_manager.user_loader
    def load_user(user_id):
        return Usuario.query.get(int(user_id)) 

    register_blueprints(app) # Registrar los blueprints en la aplicación
   

# Esto sirve para rellenar la base de datos de las acciones
# from app.routes.finance_data import actualizar_acciones_global_tickers
# with app.app_context():
#    actualizar_acciones_global_tickers()

app = create_app()

# Ejecutar la aplicación si se ejecuta este script directamente
if __name__ == '__main__':
    #app.run(debug=True, host='0.0.0.0', port=5000)  
    socketio.run(app, debug=True, host='0.0.0.0', port=5000) 
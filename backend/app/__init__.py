from flask import Flask  # Importar la clase Flask desde el módulo flask
from flask_cors import CORS  # Importar el módulo CORS desde flask_cors
from flask_admin import Admin  # Importar la clase Admin desde el módulo flask_admin
from flask_admin.contrib.sqla import ModelView  # Importar la clase ModelView desde el módulo flask_admin.contrib.sqla
from .extensions import db, login_manager  # Importar las extensiones db y login_manager desde el archivo extensions en el mismo paquete

def create_app():
    app = Flask(__name__)  # Crear una instancia de la aplicación Flask
    app.config['SECRET_KEY'] = 'una_clave_secreta_muy_segura'  # Configurar la clave secreta de la aplicación
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:example@grownomics-db/grownomics_db'  # Configurar la URI de la base de datos SQLAlchemy

    CORS(app)  # Aplicar CORS a la aplicación
    db.init_app(app)  # Inicializar la extensión db con la aplicación
    login_manager.init_app(app)  # Inicializar la extensión login_manager con la aplicación
    
    from app.models import Usuario, Accion, AccionesFavoritas, AccionesFavoritasModelView, Cartera, Transaccion  # Importar los modelos de datos desde el módulo models

    admin = Admin(app, name='Grownomics', template_mode='bootstrap3')  # Crear una instancia de Admin con el nombre 'Grownomics' y el modo de plantilla 'bootstrap3'

    admin.add_view(ModelView(Usuario, db.session))  # Agregar una vista para el modelo Usuario
    admin.add_view(ModelView(Accion, db.session, name='Accion'))  # Agregar una vista para el modelo Accion con el nombre 'Accion'
    admin.add_view(AccionesFavoritasModelView(AccionesFavoritas, db.session, name='Acciones Favoritas'))  # Agregar una vista personalizada para el modelo AccionesFavoritas con el nombre 'Acciones Favoritas'
    admin.add_view(ModelView(Cartera, db.session, name='Cartera'))  # Agregar una vista para el modelo Cartera con el nombre 'Cartera'
    admin.add_view(ModelView(Transaccion, db.session, name='Transaccion'))  # Agregar una vista para el modelo Transaccion con el nombre 'Transaccion'
    
    from .routes import register_blueprints  # Importar la función register_blueprints desde el módulo routes
    register_blueprints(app)  # Registrar los blueprints en la aplicación

    @login_manager.user_loader
    def load_user(user_id):
        return Usuario.query.get(int(user_id))  # Definir una función para cargar un usuario

    # Esto sirve para rellenar la base de datos de las acciones
    # from app.routes.finance_data import actualizar_acciones_global_tickers
    # with app.app_context():
    #    actualizar_acciones_global_tickers()

    return app  # Devolver la aplicación Flask

from app import create_app  # Importar la función create_app desde el módulo app

app = create_app()  # Crear una instancia de la aplicación Flask

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)  # Ejecutar la aplicación si se ejecuta este script directamente

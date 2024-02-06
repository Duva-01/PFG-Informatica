from flask import Flask
from flask_cors import CORS
from flask_admin import Admin
from flask_admin.contrib.sqla import ModelView
from .extensions import db, login_manager


def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'una_clave_secreta_muy_segura'
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:example@grownomics-db/grownomics_db'

    CORS(app)
    db.init_app(app)
    login_manager.init_app(app)
    
    from app.models import Usuario, Accion, AccionesFavoritas, AccionesFavoritasModelView
    
    admin = Admin(app, name='Grownomics', template_mode='bootstrap3')

    admin.add_view(ModelView(Usuario, db.session))
    admin.add_view(ModelView(Accion, db.session, name='Tabla Accion'))
    admin.add_view(AccionesFavoritasModelView(AccionesFavoritas, db.session, name='Tabla Acciones Favoritas'))
    
    from .routes import register_blueprints
    register_blueprints(app)

    @login_manager.user_loader
    def load_user(user_id):
        return Usuario.query.get(int(user_id))

    # Esto sirve para rellenar la base de datos de las acciones
    # from app.routes.finance_data import actualizar_acciones_global_tickers
    # with app.app_context():
    #    actualizar_acciones_global_tickers()

    return app

from app import create_app

app = create_app()

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
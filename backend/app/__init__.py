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
    
    from app.models import Usuario
    admin = Admin(app, name='MiAdmin', template_mode='bootstrap3')
    admin.add_view(ModelView(Usuario, db.session))
    
    from .routes import bp as routes_bp
    app.register_blueprint(routes_bp, url_prefix='/')

    @login_manager.user_loader
    def load_user(user_id):
        return Usuario.query.get(int(user_id))

    return app

from app import create_app

app = create_app()

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
from .finance_data import finance_bp
from .auth import auth_bp

def register_blueprints(app):
    app.register_blueprint(finance_bp, url_prefix='/finance')
    app.register_blueprint(auth_bp, url_prefix='/auth')

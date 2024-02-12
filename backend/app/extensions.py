from flask_sqlalchemy import SQLAlchemy  # Importar la clase SQLAlchemy desde el módulo flask_sqlalchemy
from flask_login import LoginManager  # Importar la clase LoginManager desde el módulo flask_login

db = SQLAlchemy()  # Crear una instancia de SQLAlchemy llamada db
login_manager = LoginManager()  # Crear una instancia de LoginManager llamada login_manager

# En un nuevo archivo llamado socketio_config.py

from flask_socketio import SocketIO

socketio = SocketIO(cors_allowed_origins="*")

def init_socketio(app):
    socketio.init_app(app)

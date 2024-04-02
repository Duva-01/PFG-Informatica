import logging
import sys
from flask_apscheduler import APScheduler
from flask import current_app
from flask_mail import Message
import yfinance as yf
# Asegúrate de importar las extensiones y modelos correctamente
from .extensions import db
from .models import Accion, AccionesFavoritas, Usuario, Notificacion
from .socketIO_config import socketio
from flask_socketio import join_room, leave_room

# Configura el logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
stdout_handler = logging.StreamHandler(sys.stdout)
stdout_handler.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
stdout_handler.setFormatter(formatter)
logger.addHandler(stdout_handler)

#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------

# Instancia del scheduler
scheduler = APScheduler()

@socketio.on('connect')
def connect():
    print("\n Cliente conectado al socket \n")

@socketio.on('disconnect')
def disconnect():
    print('\n Cliente desconectado del socket \n')

# Definir la función para manejar el evento 'test'
@socketio.on('test')
def handle_test_event(message):
    logger.info(f"\n Me llega este mensaje del cliente: {message} \n")
    socketio.emit('test_response', 'Recibo tu mensaje cliente')

@socketio.on('join')
def on_join(data):
    email = data['email']
    room = email_to_room_mapping(email)  # Asegúrate de que esta función devuelva un identificador único de sala basado en el email
    join_room(room)
    print(f"{email} se ha unido a la sala {room}.")

#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------

# Define la configuración de tareas en APSchedulers
def configura_tareas(app):
    if not scheduler.running:
        scheduler.init_app(app)
        scheduler.start()

    # Guardar la instancia de app en el scheduler para usarla luego en el codigo
    scheduler.app = app
    # Limpia todos los trabajos existentes antes de agregar nuevos al scheduler
    scheduler.remove_all_jobs()
    # Agrega aquí todas las tareas y su programación respectiva
    scheduler.add_job(id='check_favorite_stocks_prices', func=check_favorite_stocks_prices, trigger='interval', minutes=180)
    #scheduler.add_job(id='test_alert', func=test_alert, trigger='interval', seconds=20)

# Tarea para verificar los precios de las acciones favoritas
def check_favorite_stocks_prices():
    with scheduler.app.app_context():  # Asegúrate de ejecutar dentro del contexto de la aplicación el scheduler
        usuarios = Usuario.query.all()
        for usuario in usuarios:
            acciones_favoritas = AccionesFavoritas.query.filter_by(id_usuario=usuario.id).all()
            for favorita in acciones_favoritas:
                # Utiliza la relación `accion` para obtener la instancia de Accion asociada
                accion = favorita.accion
                if accion:  # Comprueba que la relación haya devuelto una instancia válida
                    ticker_symbol = accion.codigoticker
                    ticker = yf.Ticker(ticker_symbol)
                    data = ticker.history(period="1d")
                    
                    if not data.empty:
                        last_row = data.iloc[-1]
                        change_percent = ((last_row['Close'] - last_row['Open']) / last_row['Open']) * 100
                        
                        #if abs(change_percent) >= 5:
                        send_notification(usuario.email, ticker_symbol, change_percent)
                        logger.info(f"Correo enviado a {usuario.email} sobre la acción {ticker_symbol}.")

# Función para enviar notificaciones
def send_notification(email, ticker_symbol, change_percent):
    with scheduler.app.app_context():

        usuario = Usuario.query.filter_by(email=email).first()
        if usuario:
            mensaje = f"Tu acción favorita {ticker_symbol} ha tenido una variación significativa de {change_percent:.2f}% en las últimas 24 horas."
            nueva_notificacion = Notificacion(usuario_id=usuario.id, mensaje=mensaje)
            db.session.add(nueva_notificacion)
            db.session.commit()

        mail = scheduler.app.extensions['mail']

        msg = Message("Alerta de Acción Favorita", 
                      sender=scheduler.app.config['MAIL_DEFAULT_SENDER'],
                      recipients=[email], 
                      body= f"Tu acción favorita {ticker_symbol} ha tenido una variación significativa de {change_percent:.2f}% en las últimas 24 horas.")
        
        room = email_to_room_mapping(email)  # Implementa esta función según tus necesidades
        socketio.emit('stock_alert', {
            'message': f"Tu acción favorita {ticker_symbol} ha tenido una variación significativa de {change_percent:.2f}% en las últimas 24 horas."
        }, room=room)

        mail.send(msg)

def email_to_room_mapping(email):
    # Este es un ejemplo simple que usa el email como identificador de sala.
    # En una implementación real, se debería considerar un identificador único más seguro.
    return email

# Función de prueba para enviar un email
def test_alert():
    # Usar scheduler.app para acceder a la instancia de la aplicación
    with scheduler.app.app_context():
        mail = scheduler.app.extensions['mail']
        email = "david@gmail.com"

        logger.info(f"Enviando notificación a {email}.")
        msg = Message("Test de notificación", 
                      sender=scheduler.app.config['MAIL_DEFAULT_SENDER'],
                      recipients=[email], 
                      body= f"Test de prueba de notificacion.")
        
        room = email_to_room_mapping(email)  
        socketio.emit('test_alert', {
            'message': f"Test de prueba de notificacion."
        }, room=room)

        mail.send(msg)

from flask import Blueprint, jsonify, request, current_app
from flask_login import login_user, logout_user
from ..models import Usuario, Cartera, ResetClaveToken, Notificacion
from ..extensions import db

import random
from datetime import datetime, timedelta

from flask_mail import Message

# Crear un Blueprint para las rutas de autenticación
auth_bp = Blueprint('auth', __name__)

# Rutas para registro, inicio de sesión, cierre de sesión y obtención de usuario
@auth_bp.route('/register', methods=['POST'])
def register():
    if request.method == 'POST':
        # Obtener los datos del formulario de registro
        username = request.form.get('nombre')
        password = request.form.get('password')
        email = request.form.get('email')
        apellido = request.form.get('apellido')

        # Verificar si ya existe un usuario con el mismo correo electrónico
        existeUsuario = Usuario.query.filter_by(email=email).first()
        if existeUsuario:
            return jsonify({'success': False, 'message': 'Ya existe un usuario con este correo electrónico.'}), 409

        # Crear un nuevo usuario
        new_user = Usuario(nombre=username, apellido=apellido, email=email)
        new_user.set_password(password)  # Hashear la contraseña

        db.session.add(new_user)
        db.session.flush()  # Obtener el ID del nuevo usuario antes de hacer commit

        # Crear una nueva cartera para el usuario
        new_cartera = Cartera(id_usuario=new_user.id)
        db.session.add(new_cartera)

        db.session.commit()

        return jsonify({'success': True, 'message': 'Registro exitoso. Ahora puedes iniciar sesión y tienes una cartera creada.'}), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        # Verificar las credenciales del usuario
        user = Usuario.query.filter_by(email=email).first()
        if user and user.check_password(password):
            login_user(user)
            return jsonify({'success': True, 'message': 'Inicio de sesión exitoso.'}), 200
        else:
            return jsonify({'success': False, 'message': 'Credenciales incorrectas. Inténtalo de nuevo.'}), 401

@auth_bp.route('/logout', methods=['GET'])
def logout():
    logout_user()
    return jsonify({'success': True, 'message': 'Has cerrado sesión correctamente.'}), 200

@auth_bp.route('/get_user', methods=['GET'])
def get_user():
    email = request.args.get('email')
    if email:
        # Obtener la información del usuario por su correo electrónico
        usuario = Usuario.query.filter_by(email=email).first()
        if usuario:
            usuario_data = {
                'id': usuario.id,
                'nombre': usuario.nombre,
                'apellido': usuario.apellido,
                'email': usuario.email,
            }
            return jsonify(usuario_data), 200
        else:
            return jsonify({'error': 'Usuario no encontrado'}), 404
    else:
        return jsonify({'error': 'Correo electrónico no proporcionado'}), 400


@auth_bp.route('/update_user', methods=['POST'])
def update_user():
    # Asegúrate de que el usuario esté autenticado aquí
    
    data = request.get_json()
    usuario_id = data.get('id')
    nombre = data.get('nombre')
    apellido = data.get('apellido')
    email  = data.get('correo')
    # No incluyas el correo electrónico aquí si no quieres que sea editable
    nueva_contrasena = data.get('password')  # Opcional, solo si se proporciona una nueva contraseña
    
    usuario = Usuario.query.filter_by(email=email).first()
    
    if not usuario:
        return jsonify({'error': 'Usuario no encontrado'}), 404
    
    # Actualizar la información del usuario
    if nombre:
        usuario.nombre = nombre
    if apellido:
        usuario.apellido = apellido
    if nueva_contrasena:
        usuario.set_password(nueva_contrasena)  # Asegúrate de que tu modelo Usuario tenga un método para hashear la contraseña
    
    db.session.commit()
    
    return jsonify({'success': True, 'message': 'Información de usuario actualizada con éxito'}), 200


#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

@auth_bp.route('/reset_password', methods=['POST'])
def reset_password():
    data = request.get_json()
    email = data.get('email')
    token_provided = data.get('code')
    new_password = data.get('new_password')

    usuario = Usuario.query.filter_by(email=email).first()
    reset_token = ResetClaveToken.query.filter_by(usuario_id=usuario.id, token=token_provided).first()

    if usuario and reset_token and reset_token.fecha_expiracion >= datetime.utcnow():
        usuario.set_password(new_password)
        db.session.delete(reset_token)  # Eliminar el token ya que ya no será necesario
        db.session.commit()
        return jsonify({'message': 'Contraseña actualizada con éxito.'}), 200
    else:
        return jsonify({'error': 'Código de verificación incorrecto, expirado o usuario no encontrado.'}), 400


@auth_bp.route('/reset_password_request', methods=['POST'])
def reset_password_request():
    data = request.get_json()
    email = data.get('email')
    usuario = Usuario.query.filter_by(email=email).first()

    if usuario:
        token = ''.join([str(random.randint(0, 9)) for _ in range(6)])
        fecha_expiracion = datetime.utcnow() + timedelta(minutes=5)

        # Crear el token de reseteo
        reset_token = ResetClaveToken(usuario_id=usuario.id, token=token, fecha_expiracion=fecha_expiracion)
        db.session.add(reset_token)
        db.session.commit()

        send_verification_code(email, token)  # Asume que esta función ya está implementada

        return jsonify({'message': 'Si el correo electrónico está registrado, recibirás un código de verificación.'}), 200
    
    return jsonify({'message': 'Si el correo electrónico está registrado, recibirás un código de verificación.'}), 200

#-------------------------------------------------------------------------------

def send_verification_code(email_to, verification_code):

    mail = current_app.extensions['mail']
    subject = "Tu Código de Verificación"
    sender = current_app.config['MAIL_DEFAULT_SENDER']
    recipients = [email_to]
    body = f"Tu código de verificación es: {verification_code}"

    msg = Message(subject, sender=sender, recipients=recipients, body=body)

    try:
        mail.send(msg)
        return True
    except Exception as e:
        print(e)
        return False

#-----------------------------------------------------------------------------
    
@auth_bp.route('/get_notifications', methods=['GET'])
def get_notifications():
    email = request.args.get('email')
    if email:
        # Obtener la información del usuario por su correo electrónico
        usuario = Usuario.query.filter_by(email=email).first()
        if usuario:
            # Obtener las notificaciones del usuario
            notificaciones = Notificacion.query.filter_by(usuario_id=usuario.id).all()
            notificaciones_data = [{
                'id': notificacion.id,
                'mensaje': notificacion.mensaje,
                'fecha': notificacion.fecha.strftime('%Y-%m-%d %H:%M:%S')
            } for notificacion in notificaciones]

            return jsonify(notificaciones_data), 200
        else:
            return jsonify({'error': 'Usuario no encontrado'}), 404
    else:
        return jsonify({'error': 'Correo electrónico no proporcionado'}), 400

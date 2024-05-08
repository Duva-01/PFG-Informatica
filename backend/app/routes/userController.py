from flask import Blueprint, jsonify, request, current_app
from flask_login import login_user, logout_user
from ..models import Usuario, Cartera, ResetClaveToken, Notificacion
from ..extensions import db
from ..auth_decorators import login_required_conditional
import random
from datetime import datetime, timedelta

from flask_mail import Message

# Crear un Blueprint para las rutas de autenticación
auth_bp = Blueprint('auth', __name__)

# Rutas para registro, inicio de sesión, cierre de sesión y obtención de usuario
@auth_bp.route('/register', methods=['POST'])
@login_required_conditional
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

# Ruta para iniciar sesión
@auth_bp.route('/login', methods=['POST'])
@login_required_conditional
def login():
    if request.method == 'POST':
        # Obtener el correo electrónico y la contraseña del formulario de inicio de sesión
        email = request.form['email']
        password = request.form['password']

        # Verificar las credenciales del usuario
        user = Usuario.query.filter_by(email=email).first()
        if user and user.check_password(password):
            # Iniciar sesión si las credenciales son válidas
            login_user(user)
            return jsonify({'success': True, 'message': 'Inicio de sesión exitoso.'}), 200
        else:
            # Devolver un mensaje de error si las credenciales son incorrectas
            return jsonify({'success': False, 'message': 'Credenciales incorrectas. Inténtalo de nuevo.'}), 401

# Ruta para cerrar sesión
@auth_bp.route('/logout', methods=['GET'])
@login_required_conditional
def logout():
    # Cerrar sesión del usuario actual
    logout_user()
    return jsonify({'success': True, 'message': 'Has cerrado sesión correctamente.'}), 200

# Ruta para obtener información de usuario por correo electrónico

@auth_bp.route('/get_user', methods=['GET'])
@login_required_conditional
def get_user():
    email = request.args.get('email')
    if email:
        # Obtener la información del usuario por su correo electrónico
        usuario = Usuario.query.filter_by(email=email).first()
        if usuario:
            # Formatear los datos del usuario y devolverlos
            usuario_data = {
                'id': usuario.id,
                'nombre': usuario.nombre,
                'apellido': usuario.apellido,
                'email': usuario.email,
            }
            return jsonify(usuario_data), 200
        else:
            # Devolver un mensaje de error si el usuario no se encuentra
            return jsonify({'error': 'Usuario no encontrado'}), 404
    else:
        # Devolver un mensaje de error si no se proporciona un correo electrónico
        return jsonify({'error': 'Correo electrónico no proporcionado'}), 400


# Ruta para actualizar información de usuario
@auth_bp.route('/update_user', methods=['POST'])
@login_required_conditional
def update_user():
    
    # Obtener los datos JSON de la solicitud
    data = request.get_json()
    usuario_id = data.get('id')
    nombre = data.get('nombre')
    apellido = data.get('apellido')
    email  = data.get('correo')
    nueva_contrasena = data.get('password')  # Opcional, solo si se proporciona una nueva contraseña
    
    # Buscar al usuario por su correo electrónico
    usuario = Usuario.query.filter_by(email=email).first()
    
    if not usuario:
        # Devolver un mensaje de error si el usuario no se encuentra
        return jsonify({'error': 'Usuario no encontrado'}), 404
    
    # Actualizar la información del usuario
    if nombre:
        usuario.nombre = nombre
    if apellido:
        usuario.apellido = apellido
    if nueva_contrasena:
        # Establecer una nueva contraseña si se proporciona
        usuario.set_password(nueva_contrasena)  
    
    db.session.commit()
    
    return jsonify({'success': True, 'message': 'Información de usuario actualizada con éxito'}), 200


#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

# Ruta para restablecer la contraseña
@auth_bp.route('/reset_password', methods=['POST'])
@login_required_conditional
def reset_password():
    # Obtener los datos JSON de la solicitud
    data = request.get_json()
    email = data.get('email')
    token_provided = data.get('code')
    new_password = data.get('new_password')

    # Buscar al usuario por su correo electrónico y el token de restablecimiento de contraseña
    usuario = Usuario.query.filter_by(email=email).first()
    reset_token = ResetClaveToken.query.filter_by(usuario_id=usuario.id, token=token_provided).first()

    if usuario and reset_token and reset_token.fecha_expiracion >= datetime.utcnow():
        # Establecer una nueva contraseña si el usuario y el token son válidos y no han expirado
        usuario.set_password(new_password)
        db.session.delete(reset_token)  # Eliminar el token ya que ya no será necesario
        db.session.commit()
        return jsonify({'message': 'Contraseña actualizada con éxito.'}), 200
    else:
        # Devolver un mensaje de error si el código de verificación es incorrecto, ha expirado o el usuario no se encuentra
        return jsonify({'error': 'Código de verificación incorrecto, expirado o usuario no encontrado.'}), 400


# Ruta para solicitar restablecimiento de contraseña
@auth_bp.route('/reset_password_request', methods=['POST'])
@login_required_conditional
def reset_password_request():
    # Obtener los datos JSON de la solicitud
    data = request.get_json()
    email = data.get('email')
    usuario = Usuario.query.filter_by(email=email).first()

    if usuario:
        # Generar un código de verificación y establecer una fecha de expiración
        token = ''.join([str(random.randint(0, 9)) for _ in range(6)])
        fecha_expiracion = datetime.utcnow() + timedelta(minutes=5)

        # Crear el token de restablecimiento de contraseña y guardarlo en la base de datos
        reset_token = ResetClaveToken(usuario_id=usuario.id, token=token, fecha_expiracion=fecha_expiracion)
        db.session.add(reset_token)
        db.session.commit()

        # Enviar el código de verificación por correo electrónico
        send_verification_code(email, token)  

        return jsonify({'message': 'Si el correo electrónico está registrado, recibirás un código de verificación.'}), 200
    
    return jsonify({'message': 'Si el correo electrónico está registrado, recibirás un código de verificación.'}), 200

#-------------------------------------------------------------------------------

# Función para enviar el código de verificación por correo electrónico
def send_verification_code(email_to, verification_code):

    # Obtener la extensión de correo electrónico de la aplicación
    mail = current_app.extensions['mail']
    subject = "Tu Código de Verificación"
    sender = current_app.config['MAIL_DEFAULT_SENDER']
    recipients = [email_to]
    body = f"Tu código de verificación es: {verification_code}"

    # Crear y enviar el correo electrónico
    msg = Message(subject, sender=sender, recipients=recipients, body=body)

    try:
        mail.send(msg)
        return True
    except Exception as e:
        # Devolver False si ocurre algún error durante el envío del correo electrónico
        print(e)
        return False

#-----------------------------------------------------------------------------
    
# Ruta para obtener las notificaciones de un usuario
@auth_bp.route('/get_notifications', methods=['GET'])
@login_required_conditional
def get_notifications():
    email = request.args.get('email')
    if email:
        # Obtener la información del usuario por su correo electrónico
        usuario = Usuario.query.filter_by(email=email).first()
        if usuario:
            # Obtener las notificaciones del usuario
            notificaciones = Notificacion.query.filter_by(usuario_id=usuario.id).all()
            # Formatear los datos de las notificaciones y devolverlos
            notificaciones_data = [{
                'id': notificacion.id,
                'mensaje': notificacion.mensaje,
                'fecha': notificacion.fecha.strftime('%Y-%m-%d %H:%M:%S')
            } for notificacion in notificaciones]

            return jsonify(notificaciones_data), 200
        else:
            # Devolver un mensaje de error si el usuario no se encuentra
            return jsonify({'error': 'Usuario no encontrado'}), 404
    else:
        # Devolver un mensaje de error si no se proporciona un correo electrónico
        return jsonify({'error': 'Correo electrónico no proporcionado'}), 400


from flask import Blueprint, jsonify, request
from flask_login import login_user, logout_user
from ..models import Usuario, Cartera
from ..extensions import db

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
        existing_user = Usuario.query.filter_by(email=email).first()
        if existing_user:
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

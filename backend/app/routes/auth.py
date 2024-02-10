from flask import Blueprint, jsonify, request, flash, redirect, url_for
from flask_login import login_user, login_required, logout_user
from ..models import Usuario
from ..extensions import db

auth_bp = Blueprint('auth', __name__)

# Tus funciones de rutas van aquí
@auth_bp.route('/register', methods=['POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        email = request.form.get('email')
        apellido = request.form.get('apellido')

        existing_user = Usuario.query.filter_by(email=email).first()
        if existing_user:
            print(f'El usuario con correo electrónico {email} ya existe.')
            return jsonify({'success': False, 'message': 'Ya existe un usuario con este correo electrónico.'}), 409

        new_user = Usuario(nombre=username, apellido=apellido, email=email)
        new_user.set_password(password)  # Esto hashea la contraseña

        db.session.add(new_user)
        db.session.commit()

        print(f'Nuevo usuario registrado: {username} ({email})')

        return jsonify({'success': True, 'message': 'Registro exitoso. Ahora puedes iniciar sesión.'}), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        user = Usuario.query.filter_by(email=email).first()
        if user and user.check_password(password):
            login_user(user)
            # En lugar de redirigir, devuelve una respuesta JSON
            return jsonify({'success': True, 'message': 'Inicio de sesión exitoso.'}), 200
        else:
            # Devuelve una respuesta JSON indicando fallo en el inicio de sesión
            return jsonify({'success': False, 'message': 'Credenciales incorrectas. Inténtalo de nuevo.'}), 401

@auth_bp.route('/logout', methods=['GET'])
def logout():
    logout_user()
    # Devuelve una respuesta JSON confirmando el cierre de sesión
    return jsonify({'success': True, 'message': 'Has cerrado sesión correctamente.'}), 200

@auth_bp.route('/get_user', methods=['GET'])
def get_user():
    email = request.args.get('email')
    if email:
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

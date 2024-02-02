from flask import Blueprint
from flask import Blueprint, request, flash, redirect, url_for
from flask_login import login_user, login_required, logout_user
from .models import Usuario
from .extensions import db

from flask import jsonify  # Importa jsonify

# Define un objeto Blueprint para las rutas
bp = Blueprint('routes', __name__)

from .finance_data import get_ibex35_data, get_popular_stocks_data, get_historical_data, get_market_summary

# Registra las rutas 

@bp.route('/ibex35_data')
def ibex35_data():
    return get_ibex35_data()

@bp.route('/popular_stocks_data')
def popular_stocks_data():
    return get_popular_stocks_data()

@bp.route('/historical_data')
def historical_data():
    return get_historical_data()

@bp.route('/resumen_mercado')
def market_summary():
    return get_market_summary()

# -----------------------------------------------------------------------
# Inicio de sesion y registrarse

@bp.route('/register', methods=['POST'])
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



@bp.route('/login', methods=['POST'])
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


@bp.route('/logout')
@login_required
def logout():
    logout_user()
    # Devuelve una respuesta JSON confirmando el cierre de sesión
    return jsonify({'success': True, 'message': 'Has cerrado sesión correctamente.'}), 200

# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
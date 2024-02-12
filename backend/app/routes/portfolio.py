from flask import Blueprint, jsonify, request, flash, redirect, url_for
from ..models import Usuario, Cartera, Accion, Transaccion
from ..extensions import db

# Crear un Blueprint para las rutas del portafolio
portfolio_bp = Blueprint('portfolio', __name__)

# Ruta para obtener el portafolio de un usuario
@portfolio_bp.route('/get_portfolio')
def get_portfolio():
    email = request.args.get('email')  # Obtener el correo electrónico del usuario de la solicitud
    usuario = Usuario.query.filter_by(email=email).first()  # Buscar el usuario en la base de datos
    if usuario:  # Si se encuentra el usuario
        cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()  # Buscar la cartera del usuario
        if cartera:  # Si se encuentra la cartera
            # Devolver información sobre el portafolio del usuario
            return jsonify({
                'saldo': cartera.saldo,
                'total_depositado': cartera.total_depositado,
                'total_retirado': cartera.total_retirado,
                'total_transacciones': cartera.total_transacciones
            }), 200
        else:  # Si la cartera no se encuentra
            return jsonify({'error': 'Cartera no encontrada'}), 404
    else:  # Si el usuario no se encuentra
        return jsonify({'error': 'Usuario no encontrado'}), 404

# Ruta para depositar fondos en la cartera de un usuario
@portfolio_bp.route('/deposit_portfolio', methods=['POST'])
def deposit_portfolio():
    data = request.json  # Obtener los datos JSON de la solicitud
    email = data['email']  # Obtener el correo electrónico del usuario
    cantidad = float(data['cantidad'])  # Obtener la cantidad a depositar
    usuario = Usuario.query.filter_by(email=email).first()  # Buscar el usuario en la base de datos
    if usuario:  # Si se encuentra el usuario
        cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()  # Buscar la cartera del usuario
        if cartera:  # Si se encuentra la cartera
            cartera.saldo += cantidad  # Añadir la cantidad al saldo de la cartera
            cartera.total_depositado += cantidad  # Actualizar el total depositado en la cartera
            db.session.commit()  # Confirmar los cambios en la base de datos
            return jsonify({'success': True, 'message': 'Depósito realizado con éxito'}), 200  # Respuesta exitosa
        else:  # Si la cartera no se encuentra
            return jsonify({'error': 'Cartera no encontrada'}), 404
    else:  # Si el usuario no se encuentra
        return jsonify({'error': 'Usuario no encontrado'}), 404

# Ruta para retirar fondos de la cartera de un usuario
@portfolio_bp.route('/withdraw_portfolio', methods=['POST'])
def withdraw_portfolio():
    data = request.json  # Obtener los datos JSON de la solicitud
    email = data['email']  # Obtener el correo electrónico del usuario
    cantidad = float(data['cantidad'])  # Obtener la cantidad a retirar
    usuario = Usuario.query.filter_by(email=email).first()  # Buscar el usuario en la base de datos
    if usuario:  # Si se encuentra el usuario
        cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()  # Buscar la cartera del usuario
        if cartera and cartera.saldo >= cantidad:  # Si se encuentra la cartera y hay suficientes fondos
            cartera.saldo -= cantidad  # Restar la cantidad del saldo de la cartera
            cartera.total_retirado += cantidad  # Actualizar el total retirado en la cartera
            db.session.commit()  # Confirmar los cambios en la base de datos
            return jsonify({'success': True, 'message': 'Retiro realizado con éxito'}), 200  # Respuesta exitosa
        elif cartera.saldo < cantidad:  # Si no hay suficientes fondos en la cartera
            return jsonify({'error': 'Saldo insuficiente'}), 400  # Error de saldo insuficiente
        else:  # Si la cartera no se encuentra
            return jsonify({'error': 'Cartera no encontrada'}), 404
    else:  # Si el usuario no se encuentra
        return jsonify({'error': 'Usuario no encontrado'}), 404

#------------------- Para la simulacion ------------------------#
    
@portfolio_bp.route('/buy_stock', methods=['POST'])
def buy_stock():
    data = request.get_json()
    print("Datos recibidos en la solicitud POST:", data)  # Imprimir los datos recibidos en la solicitud

    user_email = data['email']
    stock_symbol = data['symbol']
    cantidad = int(data['cantidad'])
    precio = float(data['precio'])
    
    usuario = Usuario.query.filter_by(email=user_email).first()
    if not usuario:
        print(f"Usuario no encontrado para el correo electrónico: {user_email}")
        return jsonify({'error': 'Usuario no encontrado'}), 404

    cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()
    if not cartera:
        print("Cartera no encontrada para el usuario:", usuario.id)
        return jsonify({'error': 'Cartera no encontrada'}), 404

    total_cost = precio * cantidad
    if cartera.saldo < total_cost:
        print("Saldo insuficiente en la cartera del usuario:", usuario.id)
        return jsonify({'error': 'Saldo insuficiente'}), 400

    cartera.saldo -= total_cost
    cartera.total_transacciones += 1

    accion = Accion.query.filter_by(codigoticker=stock_symbol).first()
    if not accion:
        accion = Accion(nombre=stock_symbol, codigoticker=stock_symbol)
        db.session.add(accion)
    
    transaccion = Transaccion(id_cartera=cartera.id_cartera, id_accion=accion.id_accion, tipo='compra', cantidad=cantidad, precio=precio)
    db.session.add(transaccion)
    db.session.commit()

    print("Compra realizada con éxito para el usuario:", usuario.id)
    return jsonify({'success': True, 'message': 'Compra realizada con éxito'}), 200


@portfolio_bp.route('/sell_stock', methods=['POST'])
def sell_stock():
    data = request.get_json()
    user_email = data['email']
    stock_symbol = data['symbol']
    cantidad = int(data['cantidad'])
    precio = float(data['precio'])

    usuario = Usuario.query.filter_by(email=user_email).first()
    if not usuario:
        return jsonify({'error': 'Usuario no encontrado'}), 404

    cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()
    if not cartera:
        return jsonify({'error': 'Cartera no encontrada'}), 404

    accion = Accion.query.filter_by(codigoticker=stock_symbol).first()
    if not accion:
        return jsonify({'error': 'Acción no encontrada'}), 404

    transacciones_compra = sum([trans.cantidad for trans in cartera.transacciones if trans.accion == accion and trans.tipo == 'compra'])
    transacciones_venta = sum([trans.cantidad for trans in cartera.transacciones if trans.accion == accion and trans.tipo == 'venta'])
    acciones_poseidas = transacciones_compra - transacciones_venta

    if acciones_poseidas < cantidad:
        return jsonify({'error': 'Cantidad de acciones insuficiente para vender'}), 400

    total_venta = precio * cantidad
    cartera.saldo += total_venta
    cartera.total_transacciones += 1

    nueva_transaccion = Transaccion(id_cartera=cartera.id_cartera, id_accion=accion.id_accion, tipo='venta', cantidad=cantidad, precio=precio)
    db.session.add(nueva_transaccion)
    db.session.commit()

    return jsonify({'success': True, 'message': 'Venta realizada con éxito'}), 200


@portfolio_bp.route('/get_user_transactions')
def get_user_transactions():
    email = request.args.get('email')
    usuario = Usuario.query.filter_by(email=email).first()
    if not usuario:
        return jsonify({'error': 'Usuario no encontrado'}), 404

    cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()
    if not cartera:
        return jsonify({'error': 'Cartera no encontrada'}), 404

    transacciones = Transaccion.query.filter_by(id_cartera=cartera.id_cartera).all()
    transacciones_lista = [{
        'id_transaccion': trans.id_transaccion,
        'tipo': trans.tipo,
        'cantidad': trans.cantidad,
        'precio': trans.precio,
        'fecha': trans.fecha.strftime("%Y-%m-%d %H:%M:%S"),
        'accion': trans.accion.nombre
    } for trans in transacciones]

    return jsonify(transacciones_lista), 200

from flask import Blueprint, jsonify, request, flash, redirect, url_for
from ..models import Usuario, Cartera, Accion, Transaccion
from ..extensions import db
from ..auth_decorators import login_required_conditional

# Crear un Blueprint para las rutas del portafolio
portfolio_bp = Blueprint('portfolio', __name__)

# Ruta para obtener el portafolio de un usuario
@portfolio_bp.route('/get_portfolio')
@login_required_conditional
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
@login_required_conditional
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
@login_required_conditional
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

# Funcion para comprar una accion
@portfolio_bp.route('/buy_stock', methods=['POST'])
@login_required_conditional
def buy_stock():
    data = request.get_json()
    print("Datos recibidos en la solicitud POST:", data)  # Imprimir los datos recibidos en la solicitud

    user_email = data['email']
    stock_symbol = data['symbol']
    cantidad = int(data['cantidad'])
    precio = float(data['precio'])
    
    usuario = Usuario.query.filter_by(email=user_email).first()  # Buscar al usuario por su correo electrónico
    if not usuario:
        print(f"Usuario no encontrado para el correo electrónico: {user_email}")
        return jsonify({'error': 'Usuario no encontrado'}), 404  # Devolver un error si el usuario no existe

    cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()  # Obtener la cartera del usuario
    if not cartera:
        print("Cartera no encontrada para el usuario:", usuario.id)
        return jsonify({'error': 'Cartera no encontrada'}), 404  # Devolver un error si la cartera no existe

    total_cost = precio * cantidad  # Calcular el costo total de la compra
    if cartera.saldo < total_cost:
        print("Saldo insuficiente en la cartera del usuario:", usuario.id)
        return jsonify({'error': 'Saldo insuficiente'}), 400  # Devolver un error si el saldo es insuficiente

    cartera.saldo -= total_cost  # Restar el costo total de la compra al saldo de la cartera
    cartera.total_transacciones += 1  # Incrementar el contador de transacciones de la cartera

    accion = Accion.query.filter_by(codigoticker=stock_symbol).first()  # Buscar la acción por su símbolo
    if not accion:
        accion = Accion(nombre=stock_symbol, codigoticker=stock_symbol)  # Crear una nueva acción si no existe
        db.session.add(accion)
    
    transaccion = Transaccion(id_cartera=cartera.id_cartera, id_accion=accion.id_accion, tipo='compra', cantidad=cantidad, precio=precio)  # Crear una nueva transacción de compra
    db.session.add(transaccion)  # Agregar la transacción a la sesión de la base de datos
    db.session.commit()  # Confirmar la transacción en la base de datos

    print("Compra realizada con éxito para el usuario:", usuario.id)
    return jsonify({'success': True, 'message': 'Compra realizada con éxito'}), 200  # Devolver una respuesta exitosa

# Funcion para vender una accion
@portfolio_bp.route('/sell_stock', methods=['POST'])
@login_required_conditional
def sell_stock():
    data = request.get_json()
    user_email = data['email']
    stock_symbol = data['symbol']
    cantidad = int(data['cantidad'])
    precio = float(data['precio'])

    usuario = Usuario.query.filter_by(email=user_email).first()  # Buscar al usuario por su correo electrónico
    if not usuario:
        return jsonify({'error': 'Usuario no encontrado'}), 404  # Devolver un error si el usuario no existe

    cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()  # Obtener la cartera del usuario
    if not cartera:
        return jsonify({'error': 'Cartera no encontrada'}), 404  # Devolver un error si la cartera no existe

    accion = Accion.query.filter_by(codigoticker=stock_symbol).first()  # Buscar la acción por su símbolo
    if not accion:
        return jsonify({'error': 'Acción no encontrada'}), 404  # Devolver un error si la acción no existe

    transacciones_compra = sum([trans.cantidad for trans in cartera.transacciones if trans.accion == accion and trans.tipo == 'compra'])  # Calcular el total de acciones compradas
    transacciones_venta = sum([trans.cantidad for trans in cartera.transacciones if trans.accion == accion and trans.tipo == 'venta'])  # Calcular el total de acciones vendidas
    acciones_poseidas = transacciones_compra - transacciones_venta  # Calcular el total de acciones poseídas

    if acciones_poseidas < cantidad:
        return jsonify({'error': 'Cantidad de acciones insuficiente para vender'}), 400  # Devolver un error si la cantidad de acciones a vender es mayor que las acciones poseídas

    total_venta = precio * cantidad  # Calcular el total de la venta
    cartera.saldo += total_venta  # Sumar el total de la venta al saldo de la cartera
    cartera.total_transacciones += 1  # Incrementar el contador de transacciones de la cartera

    nueva_transaccion = Transaccion(id_cartera=cartera.id_cartera, id_accion=accion.id_accion, tipo='venta', cantidad=cantidad, precio=precio)  # Crear una nueva transacción de venta
    db.session.add(nueva_transaccion)  # Agregar la transacción a la sesión de la base de datos
    db.session.commit()  # Confirmar la transacción en la base de datos

    return jsonify({'success': True, 'message': 'Venta realizada con éxito'}), 200  # Devolver una respuesta exitosa

# Funcion para obtener las transacciones de un usuario
@portfolio_bp.route('/get_user_transactions')
@login_required_conditional
def get_user_transactions():
    email = request.args.get('email')
    usuario = Usuario.query.filter_by(email=email).first()  # Buscar al usuario por su correo electrónico
    if not usuario:
        return jsonify({'error': 'Usuario no encontrado'}), 404  # Devolver un error si el usuario no existe

    cartera = Cartera.query.filter_by(id_usuario=usuario.id).first()  # Obtener la cartera del usuario
    if not cartera:
        return jsonify({'error': 'Cartera no encontrada'}), 404  # Devolver un error si la cartera no existe

    transacciones = Transaccion.query.filter_by(id_cartera=cartera.id_cartera).all()  # Obtener todas las transacciones de la cartera
    transacciones_lista = [{  # Crear una lista de diccionarios con información de las transacciones
        'id_transaccion': trans.id_transaccion,
        'tipo': trans.tipo,
        'cantidad': trans.cantidad,
        'precio': trans.precio,
        'fecha': trans.fecha.strftime("%Y-%m-%d %H:%M:%S"),
        'accion': trans.accion.nombre
    } for trans in transacciones]

    return jsonify(transacciones_lista), 200  # Devolver la lista de transacciones



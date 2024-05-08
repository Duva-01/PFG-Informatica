from .extensions import db  # Importar el objeto db de SQLAlchemy desde el módulo extensions
from flask_login import UserMixin, login_required, current_user  # Importar la clase UserMixin de flask_login
from werkzeug.security import generate_password_hash, check_password_hash  # Importar funciones para generar y comprobar contraseñas hash
from flask_admin.contrib.sqla import ModelView  # Importar ModelView de flask_admin para usarlo en la definición de la vista del modelo
from datetime import datetime
from .auth_decorators import login_required_conditional
from flask_admin import AdminIndexView, expose
from flask import redirect, url_for, request

class Usuario(UserMixin, db.Model):  # Definir la clase Usuario que hereda de UserMixin y db.Model
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)  # Definir columna id como clave primaria
    nombre = db.Column(db.String(255))  # Definir columna nombre como string de máximo 255 caracteres
    apellido = db.Column(db.String(255))  # Definir columna apellido como string de máximo 255 caracteres
    contraseña = db.Column(db.String(255))  # Definir columna contraseña como string de máximo 255 caracteres
    email = db.Column(db.String(255), unique=True)  # Definir columna email como string único de máximo 255 caracteres

    def __repr__(self):
        return f'Usuario({self.id}, {self.nombre}, {self.apellido}, {self.email})'

    def set_password(self, password):
        self.contraseña = generate_password_hash(password)  # Generar hash de la contraseña y guardarla

    def check_password(self, password):
        return check_password_hash(self.contraseña, password)  # Comprobar si la contraseña coincide con el hash almacenado

#----------------------------------------------------------------------------
    
# Definir la clase Accion para representar una acción en la base de datos
class Accion(db.Model):
    id_accion = db.Column(db.Integer, primary_key=True)  # Definir columna id_accion como clave primaria
    nombre = db.Column(db.String(255))  # Definir columna nombre como string de máximo 255 caracteres
    codigoticker = db.Column(db.String(10))  # Definir columna codigoticker como string de máximo 10 caracteres

    def __repr__(self):
        return f'Accion({self.id_accion}, {self.nombre}, {self.codigoticker})'


# Definir la clase AccionesFavoritas para representar las acciones favoritas de un usuario en la base de datos
class AccionesFavoritas(db.Model):
    __tablename__ = 'accionesfavoritas'  # Nombre de la tabla en la base de datos
    id_favorito = db.Column(db.Integer, primary_key=True)  # Definir columna id_favorito como clave primaria
    id_usuario = db.Column(db.Integer, db.ForeignKey('usuario.id'))  # Definir columna id_usuario como clave foránea referenciando la tabla Usuario
    id_accion = db.Column(db.Integer, db.ForeignKey('accion.id_accion'))  # Definir columna id_accion como clave foránea referenciando la tabla Accion
    usuario = db.relationship('Usuario', backref='acciones_favoritas', lazy='joined')  # Relación con la tabla Usuario
    accion = db.relationship('Accion', backref='acciones_favoritas', lazy='joined')  # Relación con la tabla Accion

    def __repr__(self):
        usuario_email = self.usuario.email if self.usuario else 'Desconocido'
        accion_nombre = self.accion.nombre if self.accion else 'Desconocida'
        return f'AccionesFavoritas({self.id_favorito}, Usuario: {usuario_email}, Acción: {accion_nombre})'

#----------------------------------------------------------------------------


#----------------------------------------------------------------------------
    
# Definir la clase Cartera para representar la cartera de un usuario en la base de datos
class Cartera(db.Model):
    id_cartera = db.Column(db.Integer, primary_key=True)  # Definir columna id_cartera como clave primaria
    id_usuario = db.Column(db.Integer, db.ForeignKey('usuario.id'))  # Definir columna id_usuario como clave foránea referenciando la tabla Usuario
    saldo = db.Column(db.Float, nullable=False, default=10000)  # Definir columna saldo como float no nulo con valor por defecto de 10000
    total_depositado = db.Column(db.Float, nullable=False, default=0)  # Definir columna total_depositado como float no nulo con valor por defecto de 0
    total_retirado = db.Column(db.Float, nullable=False, default=0)  # Definir columna total_retirado como float no nulo con valor por defecto de 0
    total_transacciones = db.Column(db.Integer, nullable=False, default=0)  # Definir columna total_transacciones como entero no nulo con valor por defecto de 0
    usuario = db.relationship('Usuario', backref='carteras')  # Relación con la tabla Usuario

    def __repr__(self):
        return f'Cartera({self.id_cartera}, {self.id_usuario}, {self.saldo}, {self.total_depositado}, {self.total_retirado}, {self.total_transacciones})'

#----------------------------------------------------------------------------
    
# Definir la clase Transaccion para representar una transacción en la base de datos
class Transaccion(db.Model):
    id_transaccion = db.Column(db.Integer, primary_key=True)  # Definir columna id_transaccion como clave primaria
    id_cartera = db.Column(db.Integer, db.ForeignKey('cartera.id_cartera'))  # Definir columna id_cartera como clave foránea referenciando la tabla Cartera
    id_accion = db.Column(db.Integer, db.ForeignKey('accion.id_accion'))  # Definir columna id_accion como clave foránea referenciando la tabla Accion
    tipo = db.Column(db.String(10), nullable=False)  # Definir columna tipo como string no nulo con máximo de 10 caracteres (compra o venta)
    cantidad = db.Column(db.Integer, nullable=False)  # Definir columna cantidad como entero no nulo
    precio = db.Column(db.Float, nullable=False)  # Definir columna precio como float no nulo
    fecha = db.Column(db.DateTime, nullable=False, default=db.func.current_timestamp())  # Definir columna fecha como fecha y hora no nula con valor por defecto de la fecha y hora actual
    cartera = db.relationship('Cartera', backref='transacciones')  # Relación con la tabla Cartera
    accion = db.relationship('Accion', backref='transacciones')  # Relación con la tabla Accion

    def __repr__(self):
        return f'Transaccion({self.id_transaccion}, {self.id_cartera}, {self.id_accion}, {self.tipo}, {self.cantidad}, {self.precio}, {self.fecha})'

#----------------------------------------------------------------------------

# Definir la clase ArticulosAprendizaje para representar un articulo en la base de datos
class ArticulosAprendizaje(db.Model):
    __tablename__ = 'articulosaprendizaje'  # Especifica el nombre de la tabla
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    seccion = db.Column(db.String(255), nullable=False)
    titulo = db.Column(db.String(255), nullable=False)
    imageUrl = db.Column(db.Text, nullable=False, name='imageurl')  # Especifica el nombre de la columna en minúsculas
    resumen = db.Column(db.Text, nullable=False)
    contenido = db.Column(db.Text, nullable=False)

    def __repr__(self):
        return f'ArticulosAprendizaje({self.id}, "{self.titulo}")'

    # Método para convertir el objeto a un diccionario
    def to_dict(self):
        return {
            'id': self.id,
            'seccion': self.seccion,
            'titulo': self.titulo,
            'imageUrl': self.imageUrl,
            'resumen': self.resumen,
            'contenido': self.contenido,
        }
    
#----------------------------------------------------------------------------

# Definir la clase ResetClaveToken para representar un el token del usuario en la base de datos
class ResetClaveToken(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuario.id'), nullable=False)
    token = db.Column(db.String(100), nullable=False, unique=True)
    fecha_expiracion = db.Column(db.DateTime, nullable=False)

    def __repr__(self):
        return f'<ResetClaveToken {self.token}>'
    
#-----------------------------------------------------------------------------

# Definir la clase Notificacion para representar una notificacion del usuario en la base de datos
class Notificacion(db.Model):
    __tablename__ = 'notificaciones'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuario.id'), nullable=False)
    mensaje = db.Column(db.Text, nullable=False)
    fecha = db.Column(db.DateTime, default=db.func.current_timestamp())

    usuario = db.relationship('Usuario', backref=db.backref('notificaciones', lazy=True))

    def __repr__(self):
        return f'<Notificacion {self.id} - Usuario: {self.usuario_id} - Fecha: {self.fecha} - Mensaje: {self.mensaje}>'


#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------

class MyModelView(ModelView):
    def is_accessible(self):
        return current_user.is_authenticated

    def inaccessible_callback(self, name, **kwargs):
        # Redirigir a la página de inicio de sesión si el usuario no está autenticado
        return redirect(url_for('web_auth.login', next=request.url))

class MyAdminIndexView(AdminIndexView):
    @expose('/')
    def index(self):
        if not current_user.is_authenticated:
            return redirect(url_for('web_auth.login'))
        return self.render('admin/index.html')
    
class AccionesFavoritasModelView(ModelView):
    column_list = ('id_favorito', 'usuario', 'accion')  
    column_labels = {
        'id_favorito': 'ID Favorito',
        'usuario': 'Usuario',
        'accion': 'Acción'
    }
    column_display_pk = True  
    column_sortable_list = ('id_favorito', 'usuario.nombre', 'accion.nombre')  
    column_searchable_list = ('usuario.email', 'accion.nombre')  
    column_filters = ('usuario.email', 'accion.nombre')

    def is_accessible(self):
        return current_user.is_authenticated

    def inaccessible_callback(self, name, **kwargs):
        # Redirigir a la página de inicio de sesión si el usuario no está autenticado
        return redirect(url_for('web_auth.login', next=request.url))
    
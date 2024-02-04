from .extensions import db
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from flask_admin.contrib.sqla import ModelView

class Usuario(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nombre = db.Column(db.String(255))
    apellido = db.Column(db.String(255))
    contraseña = db.Column(db.String(255))  
    email = db.Column(db.String(255), unique=True)

    def __repr__(self):
        return f'Usuario({self.id}, {self.nombre}, {self.apellido}, {self.email})'

    def set_password(self, password):
        self.contraseña = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.contraseña, password)

# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------
    
class Accion(db.Model):
    id_accion = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(255))
    codigoticker = db.Column(db.String(10))

    def __repr__(self):
        return f'Accion({self.id_accion}, {self.nombre}, {self.codigoticker})'


# --------------------------------------------------------------------------------
# -------------------------------------------------------------------------------- 
      
class AccionesFavoritas(db.Model):
    __tablename__ = 'accionesfavoritas'
    id_favorito = db.Column(db.Integer, primary_key=True)
    id_usuario = db.Column(db.Integer, db.ForeignKey('usuario.id'))
    id_accion = db.Column(db.Integer, db.ForeignKey('accion.id_accion'))
    usuario = db.relationship('Usuario', backref='acciones_favoritas', lazy='joined')
    accion = db.relationship('Accion', backref='acciones_favoritas', lazy='joined')

    def __repr__(self):

        usuario_email = self.usuario.email if self.usuario else 'Desconocido'
        accion_nombre = self.accion.nombre if self.accion else 'Desconocida'
        return f'AccionesFavoritas({self.id_favorito}, Usuario: {usuario_email}, Acción: {accion_nombre})'

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





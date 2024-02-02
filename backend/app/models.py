from .extensions import db
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash

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

from flask_testing import TestCase
from app import create_app, db
from app.models import Usuario, Accion, Cartera, Transaccion, AccionesFavoritas, Notificacion

class TestModelos(TestCase):
    # Crear una configuración de aplicación para pruebas
    def create_app(self):
        app = create_app()
        app.config['TESTING'] = True
        app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:example@grownomics-db/grownomics_db'
        return app

    # Configurar la base de datos para cada prueba
    def setUp(self):
        db.create_all()

    # Test para verificar la creación de un nuevo usuario
    def test_nuevo_usuario(self):
        # Crear una instancia del modelo Usuario
        usuario = Usuario(nombre="Juan", apellido="Pérez", email="juan@example.com")
        # Guardar la instancia en la base de datos (simulado aquí con un commit falso)
        db.session.add(usuario)
        db.session.commit()
        
        # Comprobar que el usuario ha sido creado con los atributos correctos
        assert usuario.nombre == "Juan"
        assert usuario.apellido == "Pérez"
        assert usuario.email == "juan@example.com"

    # Test para verificar la creación de una nueva acción
    def test_nueva_accion(self):
        # Crear una instancia del modelo Accion
        accion = Accion(nombre="Pepito Inc.", codigoticker="PEPIT")
        # Guardar la instancia en la base de datos
        db.session.add(accion)
        db.session.commit()
        
        # Comprobar que la acción ha sido creada con los atributos correctos
        assert accion.nombre == "Pepito Inc."
        assert accion.codigoticker == "PEPIT"

    # Test para verificar la creación de una relación de acción favorita
    def test_nueva_accion_favorita(self):
        usuario = Usuario(nombre="Ana", apellido="García", email="ana@example.com")
        accion = Accion(nombre="Tesla Inc.", codigoticker="TSLA")
        db.session.add(usuario)
        db.session.add(accion)
        db.session.commit()

        favorita = AccionesFavoritas(id_usuario=usuario.id, id_accion=accion.id_accion)
        db.session.add(favorita)
        db.session.commit()

        # Comprobar que la acción favorita ha sido creada con los atributos correctos
        assert favorita.id_usuario == usuario.id
        assert favorita.id_accion == accion.id_accion

    # Test para verificar la creación de una cartera
    def test_nueva_cartera(self):
        usuario = Usuario(nombre="Carlos", apellido="Sánchez", email="carlos@example.com")
        db.session.add(usuario)
        db.session.commit()

        cartera = Cartera(id_usuario=usuario.id, saldo=10000.0)
        db.session.add(cartera)
        db.session.commit()

        # Comprobar que la cartera ha sido creada con los atributos correctos
        assert cartera.id_usuario == usuario.id
        assert cartera.saldo == 10000.0

    # Test para verificar la creación de una transacción
    def test_nueva_transaccion(self):
        cartera = Cartera(saldo=10000.0)
        accion = Accion(nombre="Amazon", codigoticker="AMZN")
        db.session.add(cartera)
        db.session.add(accion)
        db.session.commit()

        transaccion = Transaccion(id_cartera=cartera.id_cartera, id_accion=accion.id_accion, tipo="compra", cantidad=5, precio=3000.0)
        db.session.add(transaccion)
        db.session.commit()

        # Comprobar que la transacción ha sido creada con los atributos correctos con assert
        assert transaccion.id_cartera == cartera.id_cartera
        assert transaccion.id_accion == accion.id_accion
        assert transaccion.tipo == "compra"
        assert transaccion.cantidad == 5
        assert transaccion.precio == 3000.0

    # Test para verificar la creación de una notificación
    def test_nueva_notificacion(self):
        usuario = Usuario(nombre="Laura", apellido="Díaz", email="laura@example.com")
        db.session.add(usuario)
        db.session.commit()

        notificacion = Notificacion(usuario_id=usuario.id, mensaje="Alerta: Cambio significativo en el valor de sus acciones.")
        db.session.add(notificacion)
        db.session.commit()

        # Comprobar que la notificación ha sido creada con los atributos correctos
        assert notificacion.usuario_id == usuario.id
        assert notificacion.mensaje == "Alerta: Cambio significativo en el valor de sus acciones."

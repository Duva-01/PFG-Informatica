from flask_testing import TestCase
from app import create_app, db

class TestViews(TestCase):
    def create_app(self):
        # Configuración de la app para testing
        app = create_app()
        app.config['TESTING'] = True
        app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:example@grownomics-db/grownomics_db'
        return app

    def setUp(self):
        db.create_all()

    #def tearDown(self):
        #db.session.remove()
        #db.drop_all()

    def test_home_page(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)

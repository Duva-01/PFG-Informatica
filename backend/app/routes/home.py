from flask import Blueprint, render_template

# Crear un Blueprint para las rutas de inicio
home_bp = Blueprint('home', __name__)

# Ruta para la página de inicio
@home_bp.route('/')
def home():
    return render_template('home.html')  # Renderiza la plantilla home.html

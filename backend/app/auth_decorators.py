from flask import request, redirect, url_for
from flask_login import current_user
from functools import wraps

def login_required_conditional(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if request.headers.get('X-App-Usage'):
            # Permite el acceso sin autenticación si la solicitud viene de la app
            return f(*args, **kwargs)
        else:
            # Requiere autenticación para acceso desde el navegador
            if not current_user.is_authenticated:
                return redirect(url_for('web_auth.login', next=request.url))
        return f(*args, **kwargs)
    return decorated_function

from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required
from ..models import Usuario
from ..extensions import db

web_auth = Blueprint('web_auth', __name__)

@web_auth.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user = Usuario.query.filter_by(email=email).first()
        if user and user.check_password(password):
            login_user(user)
            return redirect(url_for('admin.index')) 
        else:
            flash('Invalid username or password')
    return render_template('login.html')

@web_auth.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('web_auth.login'))

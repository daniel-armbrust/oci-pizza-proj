#
# app/user/views.py
#
from urllib.parse import urlparse

from flask import render_template, request, make_response, redirect, url_for
from flask_login import login_user, logout_user, login_required
from flask import flash as flask_flash
from flask import current_app as app
from flask_jwt_extended import create_access_token

from . import user_blueprint
from .user import User, MyUserMixin
from .forms import LoginForm, NewUserForm

@user_blueprint.route('/login/form', methods=['GET', 'POST'])
def login_view():
    """Login Form.

    """
    next_url = request.args.get('next', None)

    form = LoginForm()
   
    if request.method == 'POST':
        if form.validate_on_submit(): 
            email = request.form.get('email')
            password = request.form.get('password')

            next_url = request.form.get('next', None)

            user = User()            
            is_password_correct = user.check_password(email, password)           

            if is_password_correct:
                user_id = user.get_id(email)
                
                user_mixin = MyUserMixin(user_id)  
                login_user(user_mixin, remember=True)

                access_token = create_access_token(identity=user_id)                

                if (next_url is not None) and (next_url != 'None'):
                    flask_flash(u'Login efetuado com sucesso.', 'success')        
                    resp = make_response(redirect(urlparse(next_url)))
                else:
                    flask_flash(u'Login efetuado com sucesso. É hora de pedir PIZZA!', 'success')        
                    resp = make_response(redirect(url_for('main.home')))

                # JWT
                resp.set_cookie(key=app.__settings.jwt_cookie_name, 
                                value=access_token,
                                max_age=app.__settings.jwt_cookie_expire_ts, 
                                expires=app.__settings.jwt_cookie_expire_ts, 
                                domain=app.__settings.domain, path='/', 
                                secure=app.__settings.cookie_secure, 
                                httponly=True)

                return resp
            
            else:
                flask_flash(u'Invalid username or password!', 'error')        
 
    return render_template('user_login_form.html', form=form, next_url=next_url,
                           web_config=app.__settings.web_config,
                           api_config=app.__settings.api_config)


@user_blueprint.route('/logout', methods=['GET'])
@login_required
def logout_view():    
    logout_user()

    return redirect(url_for('main.home', next=None))


@user_blueprint.route('/new/form', methods=['GET', 'POST'])
def add_user_view():
    """New user form.

    """
    form = NewUserForm()   

    if request.method == 'POST':        
        if form.validate_on_submit():
            form_dict = request.form.to_dict()
            form_dict.pop('csrf_token')

            user = User()
            user_added = user.add(form_dict)

            if user_added:
                flask_flash(u'Cadastro efetuado com sucesso. É hora de pedir PIZZA!', 'success')        

                return redirect(url_for('main.home', next=None))                    
        
        flask_flash(u'Erro ao cadastrar o novo usuário.', 'error')       
            
    return render_template('user_add_form.html', form=form,
                           web_config=app.__settings.web_config,
                           api_config=app.__settings.api_config)


@user_blueprint.route('/password/recovery', methods=['GET'])
def password_recovery_view():
    """Página para recuperar a senha do usuário.

    """
    return render_template('user_passwdrecovery_form.html', 
                           web_config=app.__settings.web_config,
                           api_config=app.__settings.api_config)


@user_blueprint.route('/account', methods=['GET', 'POST'])
@login_required
def account():
    return render_template('user_account.html', 
                           web_config=app.__settings.web_config,
                           api_config=app.__settings.api_config)

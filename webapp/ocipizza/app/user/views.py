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

from app.modules.notifications import Notifications
from app.modules.utils import check_email


@user_blueprint.route('/login/form', methods=['GET', 'POST'])
def login_view():   
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
                flask_flash(u'Nome de usuário ou senha inválidos!', 'error')        
 
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
    """Formulário para cadastro de usuário.

    """
    form = NewUserForm()   

    if request.method == 'POST':        
        if form.validate_on_submit():
            form_dict = request.form.to_dict()
            form_dict.pop('csrf_token')

            user = User()

            user_exists = user.exists(
                email=form_dict['email'], 
                telephone=form_dict['telephone']
            )

            if user_exists:
                flask_flash(u'E-mail ou telefone já existem.', 'error')  

                return redirect(url_for('user.add_user_view', next=None))               
            else:
                # Notifica a função para completar o cadastro do novo usuário.
                ons = Notifications()
                ons.topic_ocid = app.__settings.ons_topic_user_register_ocid
                message_published = ons.publish_message(data=str(form_dict))
                
                # TODO: log
                if message_published:
                    flask_flash(u'Cadastro efetuado com sucesso! Aguarde o e-mail para confirmar o seu cadastro.', 'success')
                else:
                    flask_flash(u'Erro ao cadastrar o usuário. Tente novamente mais tarde.', 'error')

                return redirect(url_for('main.home', next=None))                        
        
        flask_flash(u'Erro ao cadastrar o novo usuário.', 'error')       
            
    return render_template('user_add_form.html', form=form,
                           web_config=app.__settings.web_config,
                           api_config=app.__settings.api_config)


@user_blueprint.route('/new/confirm', methods=['GET'])
def user_confirm_view():
    """Página para o usuário confirmar o seu cadastro.

    """
    email = request.args.get('e', type=str)
    token = request.args.get('t', type=str)
    
    is_email_valid = check_email(email)

    if is_email_valid and token:
        user = User()
        activated = user.activate(email=email, token=token)

        if activated:
            flask_flash(u'Conta ativada com sucesso.', 'success')            

            return redirect(url_for('user.login_view', next=None))  

    flask_flash(u'Link expirado ou dados inválidos.', 'error')

    return redirect(url_for('main.home', next=None))    


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

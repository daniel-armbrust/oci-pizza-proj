#
# app/user/forms.py
#

from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, validators

class LoginForm(FlaskForm):    
    email = StringField('Email', [
        validators.Email(message=(u'Invalid email address')),
        validators.DataRequired()
    ])

    password = PasswordField('Senha', [
        validators.Length(min=10, max=50, message=u'Invalid password'),
        validators.DataRequired()
    ])


class NewUserForm(FlaskForm):
    email = StringField('Email', [
        validators.Email(message=(u'Invalid email address')),
        validators.DataRequired()
    ])

    password = PasswordField('Senha', [
        validators.Length(min=10, max=30, message=u'Invalid password'),        
        validators.DataRequired()
    ])    

    name = StringField('Nome', [ 
        validators.Length(min=2, max=200, message=u'Invalid name'),
        validators.DataRequired()
    ])

    telephone = StringField('Telefone / WhatsApp', [ 
        validators.Length(min=10, max=15, message=u'Invalid telephone number'),
        validators.Regexp(regex='^[0-9\(\)\-\ \+]+$'),
        validators.DataRequired()
    ])

#
# modules/email.py
#

import os
import string
import secrets
from datetime import datetime
import urllib.parse

from oci.auth import signers as oci_signers
from oci.email_data_plane import EmailDPClient
from oci.email_data_plane.models import Sender, Recipients, SubmitEmailDetails, \
    EmailAddress

from .nosql import NoSQL

# Globals
NOSQL_EMAIL_VERIFICATION_TABLE_NAME = os.environ.get('NOSQL_EMAIL_VERIFICATION_TABLE_NAME') or 'email_verification'
EMAIL_COMPARTMENT_OCID = os.environ.get('EMAIL_COMPARTMENT_OCID')
TOKEN_LEN = 22
EXPIRATION_SECS = 600 # 10 minutos
URL_PREFIX = 'https://www.ocipizza.com.br'

class Email():
    @property
    def address(self):
        return self._address
    
    @address.setter
    def address(self, value: str):
        self._address = value
    
    @property
    def name(self):
        return self._name
    
    @name.setter
    def name(self, value: str):
        self._name = value

    def __init__(self):
        signer = oci_signers.get_resource_principals_signer()        
        self._email_client = EmailDPClient(config={}, signer=signer)
        
        self._token = self._get_token()
        self._expiration_ts = self._get_expiration_ts()
    
    def _get_token(self):
        """Retorna um token."""
        chars = string.ascii_letters + string.digits
        token = ''.join(secrets.choice(chars) for _ in range(TOKEN_LEN))

        return token

    def _get_expiration_ts(self):
        """Retorna um timestamp que indica uma data de expiração futura."""
        expiration_ts = int(datetime.now().timestamp())
        expiration_ts += EXPIRATION_SECS

        return expiration_ts
    
    def _get_html_email(self):
        """Retorna o link que o usuário deve usar para confirmar seu 
        cadastro."""
        url_params = urllib.parse.quote(f'e={self._address}&t={self._token}')

        html_email = f'''
            <!DOCTYPE html>
            <html lang="pt-BR">
            <head></head>
            <body>
               <a href="{URL_PREFIX}/user/confirm?{url_params}">
                   Confirme o seu e-mail.
               </a>
            </body>
            </html>
        '''

        return html_email

    def _add_email_verification_data(self):
        """Armazena os dados no banco NoSQL que o usuário utilizará para 
        confirmar seu cadastro por meio de um link."""
        data = {}

        data['email'] = self._address
        data['token'] = self._token
        data['expiration_ts'] = self._expiration_ts

        nosql = NoSQL()

        nosql.table = NOSQL_EMAIL_VERIFICATION_TABLE_NAME
        added = nosql.add(data)
        nosql.close()

        if added:
            return True
        else:
            return False
        
    def send(self):
        """Envia o e-mail para o usuário."""               
        added = self._add_email_verification_data()

        if not added:
            return False
        
        html_email = self._get_html_email()

        email_from = EmailAddress(
            email='no-reply@ocipizza.com.br', 
            name='no-reply@ocipizza.com.br'
        )

        sender = Sender(
            compartment_id=EMAIL_COMPARTMENT_OCID,
            sender_address=email_from
        )

        email_to = EmailAddress(
            email=self._address,
            name=self._name
        )

        recipients = Recipients(to=[email_to])
                
        email_details = SubmitEmailDetails(
            subject='OCI Pizza - Confirme o seu cadastro.',            
            body_html=html_email,
            sender=sender,
            recipients=recipients
        )

        resp = self._email_client.submit_email(
            submit_email_details=email_details
        )

        if resp.status == 200:
            return True
        else:
            return False
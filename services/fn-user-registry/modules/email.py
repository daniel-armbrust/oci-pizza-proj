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
NOSQL_EMAIL_VERIFICATION_TABLE = os.environ.get('NOSQL_EMAIL_VERIFICATION_TABLE') or 'email_verification'
EMAIL_COMPARTMENT_OCID = os.environ.get('EMAIL_COMPARTMENT_OCID')
TOKEN_LEN = 22
EXPIRATION_SECS = 600 # 10 minutos
URL_PREFIX = 'https://www.ocipizza.com.br'

class Email():
    @property
    def address(self):
        return self.__address
    
    @address.setter
    def address(self, value: str):
        self.__address = value
    
    @property
    def name(self):
        return self.__name
    
    @name.setter
    def name(self, value: str):
        self.__name = value

    def __init__(self):
        signer = oci_signers.get_resource_principals_signer()        
        self.__email_client = EmailDPClient(config={}, signer=signer)
        
        self.__token = self._get__token()
        self.__expiration_ts = self._get__expiration_ts()
    
    def _get__token(self):
        """Retorna um token."""
        chars = string.ascii_letters + string.digits
        token = ''.join(secrets.choice(chars) for _ in range(TOKEN_LEN))

        return token

    def _get__expiration_ts(self):
        """Retorna um timestamp que indica uma data de expiração futura."""
        expiration_ts = int(datetime.now().timestamp())
        expiration_ts += EXPIRATION_SECS

        return expiration_ts
    
    def _get_html_email(self):
        """Retorna o link que o usuário deve usar para confirmar seu 
        cadastro."""
        url_params = urllib.parse.quote(f'e={self.__address}&t={self.__token}')

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

        data['email'] = self.__address
        data['token'] = self.__token
        data['expiration_ts'] = self.__expiration_ts

        nosql = NoSQL()

        nosql.table = NOSQL_EMAIL_VERIFICATION_TABLE
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
            email=self.__address,
            name=self.__name
        )

        recipients = Recipients(to=[email_to])
                
        email_details = SubmitEmailDetails(
            subject='OCI Pizza - Confirme o seu cadastro.',            
            body_html=html_email,
            sender=sender,
            recipients=recipients
        )

        resp = self.__email_client.submit_email(
            submit_email_details=email_details
        )

        if resp.status == 200:
            return True
        else:
            return False
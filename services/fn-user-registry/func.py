#
# user-register-fn/func.py
#

import io
import json

from fdk import response

from modules.user import User
from modules.email import Email

def handler(ctx, data: io.BytesIO = None):
    """Esta função recebe os dados para o registro de um novo usuário. Após a 
    inserção dos dados no banco de dados, um e-mail será enviado ao usuário 
    para confirmar seu endereço de e-mail e ativar seu cadastro.

    Exemplo do payload que deve ser recebido para processamento:

       {"email": "darmbrust@gmail.com", "password": "",
        "name": "Daniel Armbrust", "telephone": "9999999999"}

    """   
    try:
        body = json.loads(data.getvalue())

        user_name = body['name']        
        email_address = body['email']        
        telephone = body['telephone']                
    except Exception as ex:       
        error = f'Error parsing json payload: {ex}'
        raise Exception(error)
    
    message = {}

    user = User()   
    user_exists = user.exists(email=email_address, telephone=telephone)  

    if not user_exists:
        added = user.add(data=body)
        user.close()

        if added:
            email = Email()
            email.address = email_address      
            email.name = user_name      
            email.send()

            message = {'status': 'success', 
                       'message': 'E-mail sent successfully.',
                       'data': {
                           'name': user_name,
                           'email': email_address
                        }}
        else:
            message = {'status': 'fail', 
                       'message': 'The email was not sent.',
                       'data': {
                           'name': user_name,
                           'email': email_address
                        }}
    else:
        message = {'status': 'fail', 
                   'message': 'User already exists.',
                   'data': {
                       'name': user_name,
                       'email': email_address
                    }}
        
    return response.Response(
        ctx, response_data=json.dumps(message),
        headers={'Content-Type': 'application/json'}
    )

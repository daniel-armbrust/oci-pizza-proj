#
# modules/user.py
#

import os
import re

from werkzeug.security import generate_password_hash

from .nosql import NoSQL

# Globals
NOSQL_USER_TABLE_NAME = os.environ.get('NOSQL_USER_TABLE_NAME') or 'user'

class User():       
    def __init__(self):
        self.__nosql = NoSQL()    
    
    def __get_id(self):
        """Retorna um ID disponível."""

        sql = f'''
            SELECT max(id) FROM {NOSQL_USER_TABLE_NAME}
        '''

        result = self.__nosql.query(sql)

        last_id = result[0]['Column_1']

        if last_id:
            last_id += 1
        else:
            last_id = 1
        
        return last_id
    
    def __extract_digits(self, input_str: str):
        """Mantém somente os caracteres numéricos do telefone."""
        # Expressão regular para corresponder dígitos.
        pattern = r'\d+'
        
        # Encontra todas as correspondências de dígitos na string de entrada.
        digits_list = re.findall(pattern, input_str)

        # Concatena os dígitos correspondentes em uma única string.
        digits = ''.join(digits_list)

        return digits

    def exists(self, email: str, telephone: str):
        """Verifica se o usuário existe através do email e telefone."""

        sql = f'''
            SELECT email, telephone FROM {NOSQL_USER_TABLE_NAME} WHERE
                email = "{email}" AND telephone = "{telephone}" LIMIT 1
        '''

        result = self.__nosql.query(sql)

        if result:
            if result[0]['email'] == email and result[0]['telephone'] == telephone:
                return True
        
        return False
    
    def add(self, data: dict):
        """Insere um novo usuário."""        

        # Retorna um número ID livre.
        user_id = self.__get_id()        
        data['id'] = user_id    

        # Converte o nome para letras maiúsculas.
        data['name'] = data['name'].upper()

        # Mantém somente os digitos numéricos do telefone.
        data['telephone'] = self.__extract_digits(data['telephone'])

        # Hashed password.
        data['password'] = generate_password_hash(data['password'])   

        self.__nosql.table = NOSQL_USER_TABLE_NAME
        was_added = self.__nosql.add(data)

        if was_added:
            return True
        else:
            return False    
    
    def close(self):
        self.__nosql.close()
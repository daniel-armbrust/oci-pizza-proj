#
# app/user/ocipizza_user.py
#
from flask_login import UserMixin, login_manager
from werkzeug.security import generate_password_hash, check_password_hash

from app.settings import Settings
from app.modules.nosql import NoSQL
from app.modules import utils

class MyUserMixin(UserMixin):
    def __init__(self, id):
        self.id = id

class User():
    def __init__(self):            
        self.__settings = Settings()
        self.__nosql = NoSQL()
        
    def get_id(self, email: str):
        sql = f'''
            SELECT id FROM {self.__settings.nosql_user_table_name} WHERE
                email = '{email}'
        '''

        data = self.__nosql.query(sql)

        if data:          
            return data[0]['id']
        else:
            return None
    
    def check_password(self, email: str, password: str): 
        sql = f'''
            SELECT email, password FROM {self.__settings.nosql_user_table_name} WHERE
                email = '{email}'
        '''

        data = self.__nosql.query(sql)        

        if data and (data[0]['email'] == email):
            stored_password_hash = data[0]['password']
                       
            if check_password_hash(stored_password_hash, password):               
                return True
            
        return False

    def check_email(self, email: str):
        sql = f'''
            SELECT email FROM {self.__settings.nosql_user_table_name} WHERE
                email = '{email}'
        '''
        data = self.__nosql.query(sql)

        if data and (data[0]['email'] == email):
            return True
        else:
            return False    

    def add(self, data: dict):
        email_exists = self.check_email(data['email'])

        if not email_exists:
            # Name uppercase    
            data['name'] = data['name'].upper()

            # Keep only number in telephone string.
            telephone_digits = utils.extract_digits(data['telephone'])
            data['telephone'] = telephone_digits   

            # Hash the Password
            data['password'] = generate_password_hash(data['password'])

            added = self.__nosql.save(
                table_name=self.__settings.nosql_user_table_name, 
                data=data)
            
            # TODO: log errors
            if added:
                return True
        
        return False
#
# modules/notifications.py
#

from oci import config as oci_config
from oci.auth import signers as oci_signers
from oci import exceptions as oci_exceptions
from oci import ons

from app.settings import Settings

class Notifications():
    @property
    def topic_ocid(self):
        return self.__topic_ocid
    
    @topic_ocid.setter
    def topic_ocid(self, value: str):
        self.__topic_ocid = value

    def __init__(self):
        self.__settings = Settings()

        if self.__settings.env == 'dev':
            config = oci_config.from_file(file_location=self.__settings.oci_config_file)   
            oci_config.validate_config(config)
            
            self.__ons = ons.NotificationDataPlaneClient(config=config)
        else:
            signer = oci_signers.get_resource_principals_signer()
            self.__ons = ons.NotificationDataPlaneClient(config={}, signer=signer)

    def publish_message(self, data: str):
        message_details = ons.models.MessageDetails(body=data)

        try: 
            resp = self.__ons.publish_message(
                topic_id=self.__topic_ocid,
                message_details=message_details
            )
        except (oci_exceptions.ServiceError, oci_exceptions.ConnectTimeout,):            
            return False

        if resp.status == 202:
            return True
        else:
            return False
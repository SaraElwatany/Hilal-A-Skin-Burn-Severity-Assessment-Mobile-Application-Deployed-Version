import secrets

SECRET_KEY = secrets.token_hex(16)
SQLALCHEMY_DATABASE_URI = 'mysql://root:MySQL_habiba123@localhost/ehr'
import os
from flask import Flask
from flask_socketio import SocketIO
from .base import db
# from .my_tokens import SECRET_KEY, SQLALCHEMY_DATABASE_URI as URI

socketio = SocketIO(cors_allowed_origins='*')

def create_app():

    from .routes import main
    
    print('Loading Routes..... , Please Wait')
    app = Flask(__name__)

    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('SQLALCHEMY_DATABASE_URI')

    db.init_app(app)
    socketio.init_app(app, async_mode=None)  # Initialize SocketIO with the app

    app.register_blueprint(main)
    with app.app_context():
            db.create_all()

    return app

__all__ = ['create_app', 'socketio']

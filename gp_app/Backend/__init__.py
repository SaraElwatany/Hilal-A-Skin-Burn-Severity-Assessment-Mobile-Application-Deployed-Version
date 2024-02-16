import os
from flask import Flask 
from flask_socketio import SocketIO, emit

from .base import db
from .routes import main
from .my_tokens import SECRET_KEY, SQLALCHEMY_DATABASE_URI as URI




def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = SECRET_KEY
    app.config['SQLALCHEMY_DATABASE_URI'] = URI
    # postgresql://ehr_user:ERx4cIQJTRXrZBJE2NVMTY0oDnIuJK41@dpg-cn4ka80cmk4c73emrvd0-a.oregon-postgres.render.com/ehr

    socketio = SocketIO(app, cors_allowed_origins='*')
    db.init_app(app)
    app.register_blueprint(main)
    return app

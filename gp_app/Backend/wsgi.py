from . import create_app, socketio
from .base import db

app = create_app()

# Create tables if they don't exist (you can adjust this for migrations instead)
with app.app_context():
    db.create_all()

if __name__ == "__main__":
    socketio.run(app)

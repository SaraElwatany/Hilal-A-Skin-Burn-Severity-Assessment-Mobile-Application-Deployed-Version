from flask_sqlalchemy import SQLAlchemy
from .base import db


class ChatMessage(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    sender_id = db.Column(db.Integer, nullable=False)
    receiver_id = db.Column(db.Integer, nullable=False)
    message = db.Column(db.String(2000), nullable=True)
    image =  db.Column(db.LargeBinary(), nullable=True)
    receiver = db.Column(db.Boolean, nullable=False, default=False)
    timestamp = db.Column(db.DateTime, server_default=db.func.now())
    burn_id = db.Column(db.Integer, nullable=False)
    # user_id = db.Column(db.Integer, nullable=False)
    voice_note_path = db.Column(db.String(255), nullable=True) 

    def to_dict(self):
        return {
            'id': self.id,
            'sender_id': self.sender_id,
            'receiver_id': self.receiver_id,
            'message': self.message,
            'image': self.image,
            'receiver': self.receiver,
            'timestamp': self.timestamp.isoformat(),
            'burn_id': self.burn_id,
            #'user_id': self.user_id,
            'voice_note_path': self.voice_note_path,
        }

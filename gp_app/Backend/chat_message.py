from flask_sqlalchemy import SQLAlchemy
from .base import db


class ChatMessage(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    sender_id = db.Column(db.Integer, nullable=False)
    receiver_id = db.Column(db.Integer, nullable=False)
    message = db.Column(db.String(500), nullable=False)
    image = db.Column(db.String(500), nullable=True)
    # audio_url = db.Column(db.String(500), nullable=True) 
    timestamp = db.Column(db.DateTime, server_default=db.func.now())

    def to_dict(self):
        return {
            'id': self.id,
            'sender_id': self.sender_id,
            'receiver_id': self.receiver_id,
            'message': self.message,
            'image': self.image,
            # 'audio_url': self.audio_url,  # Add this line
            'timestamp': self.timestamp.isoformat(),
        }

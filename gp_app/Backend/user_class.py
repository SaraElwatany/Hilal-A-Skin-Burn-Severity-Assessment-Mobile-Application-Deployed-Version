from flask_sqlalchemy import SQLAlchemy
from .base import db


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(255), nullable=False, default=None)
    password = db.Column(db.String(128), nullable=False, default=None)

    phone = db.Column(db.Integer, nullable=True, default=None)
    email = db.Column(db.String(255), nullable=True, default=None, unique=True)

    dob = db.Column(db.Date, nullable=False , default=None)
    gender = db.Column(db.String(1), nullable=False, default=None)
    height = db.Column(db.Integer, nullable=True, default=None)
    weight = db.Column(db.Integer, nullable=True, default=None)
  
    profession = db.Column(db.String(20), nullable=False, default='patient')
    speciality = db.Column(db.String(20), nullable=True, default='specialist')
    
    burns = db.relationship('Burn', backref='user', lazy=True)

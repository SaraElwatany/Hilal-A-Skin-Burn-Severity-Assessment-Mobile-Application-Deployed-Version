from flask_sqlalchemy import SQLAlchemy
from .base import db


class Burn(db.Model):
    burn_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    fk_burn_user_id = db.Column(db.Integer, db.ForeignKey('user.id') , autoincrement=True)
    burn_date = db.Column(db.Date, nullable=False , default=None)
    burn_class_model = db.Column(db.Integer, nullable= True)
    burn_img = db.Column(db.LargeBinary())
    dr_id = db.Column(db.Integer)
    burn_class_dr = db.Column(db.Integer, nullable= True)
    dr_reply = db.Column(db.String(1500), nullable = True, default=None)
    


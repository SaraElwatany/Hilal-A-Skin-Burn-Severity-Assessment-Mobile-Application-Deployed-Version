from flask_sqlalchemy import SQLAlchemy
from base import db


class Burn(db.Model):
    fk_burn_user_id = db.Column(db.Integer, autoincrement=True)
    burn_date = db.Column(db.Date, nullable=False , default=None)
    burn_class_model = db.Column(db.Integer, nullable= True)
    burn_img = db.Column(db.Blob())
    dr_id = db.Column(db.Integer)
    burn_class_model = db.Column(db.Integer, nullable= True)
    dr_reply = db.Column(db.String(1500), nullable = True, default=None)
    


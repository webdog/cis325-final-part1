from flask import Flask
from app.routes.predict import predict_bp


def create_app():
    app = Flask(__name__)

    # Register blueprints
    app.register_blueprint(predict_bp)

    return app
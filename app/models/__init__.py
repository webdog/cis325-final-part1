from mlflow.sklearn import load_model
import os

def load_model_from_path():
    base_dir = os.path.abspath(os.path.dirname(__file__))
    model_path = os.path.join(base_dir, 'compiled', 'best_model')
    return load_model(model_path)
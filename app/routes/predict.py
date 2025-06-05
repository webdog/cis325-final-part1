from flask import Blueprint, request, jsonify
from app.models import load_model_from_path
from pandas import DataFrame

predict_bp = Blueprint("predict", __name__, url_prefix="/predict")

@predict_bp.route("/", methods=["POST"], strict_slashes=False)
def predict():
    data = request.get_json()

    if not data["age_group"]:
        data["age_group"] = "Adult"

    try:
        df = DataFrame([{
            "duration": data["duration"],
            "euribor3m": data["euribor3m"],
            "age_group": data["age_group"]
        }])
    except KeyError as e:
        return jsonify(error=f"Missing key(s): {str(e)}"), 400

    model = load_model_from_path()

    try:
        predictions = model.predict(df)
        prediction_proba = model.predict_proba(df)

        predicted_label = "Y" if predictions[0] == 1 else "N"

        return jsonify({
            'prediction': predicted_label,
            'probabilities': {
                'N': round(float(prediction_proba[0][0]), 2),
                'Y': round(float(prediction_proba[0][1]), 2)
            }
        })
    except ValueError as e:
        return jsonify(error=str(e)), 500


@predict_bp.route("/practices", methods=["GET"], strict_slashes=False)
def get_age_groups():

    return jsonify(age_groups=["Older Adult", "Adult", "Senior", "Youth"]), 200
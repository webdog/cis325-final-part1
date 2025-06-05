from app import create_app

app = create_app()

if __name__ == "__main__":
    # picks up HOST and PORT from env or defaults
    host = app.config.get("HOST", "0.0.0.0")
    port = int(app.config.get("PORT", 5000))
    app.run(host=host, port=port)
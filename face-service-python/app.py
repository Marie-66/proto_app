from flask import Flask, jsonify, request
import face_recognition
import os

app = Flask(__name__)

KNOWN_FACES_DIR = "faces"

known_face_encodings = []
known_staff_ids = []


def load_known_faces():
    known_face_encodings.clear()
    known_staff_ids.clear()

    for filename in os.listdir(KNOWN_FACES_DIR):
        if filename.lower().endswith((".jpg", ".jpeg", ".png")):
            staff_id = os.path.splitext(filename)[0]
            image_path = os.path.join(KNOWN_FACES_DIR, filename)

            image = face_recognition.load_image_file(image_path)
            encodings = face_recognition.face_encodings(image)

            if len(encodings) == 0:
                print(f"No face found in {filename}")
                continue

            known_face_encodings.append(encodings[0])
            known_staff_ids.append(staff_id)

            print(f"Loaded face for {staff_id}")


load_known_faces()


@app.route('/test', methods=['GET'])
def test():
    return jsonify({
        "message": "Python face service running",
        "loaded_faces": known_staff_ids
    })


@app.route('/match', methods=['POST'])
def match_face():
    if 'image' not in request.files:
        return jsonify({
            "matched": False,
            "message": "No image uploaded"
        }), 400

    uploaded_image = request.files['image']

    unknown_image = face_recognition.load_image_file(uploaded_image)
    unknown_encodings = face_recognition.face_encodings(unknown_image)

    if len(unknown_encodings) == 0:
        return jsonify({
            "matched": False,
            "message": "No face found in uploaded image"
        }), 200

    unknown_encoding = unknown_encodings[0]

    matches = face_recognition.compare_faces(
        known_face_encodings,
        unknown_encoding,
        tolerance=0.5
    )

    if True in matches:
        match_index = matches.index(True)
        matched_staff_id = known_staff_ids[match_index]

        return jsonify({
            "matched": True,
            "staff_id": matched_staff_id
        }), 200

    return jsonify({
        "matched": False,
        "message": "No matching staff found"
    }), 200

if __name__ == '__main__':
    app.run(
        host='0.0.0.0',
        port=5001,
        debug=True
    )
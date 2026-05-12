# Event Attendance Monitoring System with Smart Facial Recognition

A BSIT capstone project developed using Flutter, Laravel, Python Face Recognition, and MySQL.

This system modernizes attendance monitoring for university events by replacing traditional paper-based attendance with smart facial recognition technology.

---

# Features

## Event Management
- Create events
- Edit events
- Delete events
- Open/Close event status

## Staff Management
- Register staff/faculty
- Department and office assignment
- Face registration support

## Smart Facial Recognition
- Real-time face scanning using mobile camera
- Face matching using Python face recognition
- Automatic attendance recording

## Attendance Monitoring
- Manual attendance entry
- Face scan attendance
- Attendance history logs
- Attendance status tracking

## Dashboard
- Total events
- Open events
- Registered faces
- Attendance logs

---

# Technologies Used

## Frontend
- Flutter
- Dart

## Backend
- Laravel 12
- PHP 8
- REST API

## Face Recognition Service
- Python 3.11
- Flask
- face_recognition
- dlib
- OpenCV

## Database
- MySQL
- phpMyAdmin

---

# System Architecture

```text
Flutter Mobile App
        ↓
Python Face Recognition Service
        ↓
Laravel REST API
        ↓
MySQL Database
```

---

# Project Structure

```text
proto_app/
│
├── lib/
│   ├── main.dart
│   └── api_service.dart
│
├── proto_backend/
│   ├── app/
│   ├── routes/
│   ├── database/
│   └── ...
│
├── face-service-python/
│   ├── app.py
│   ├── faces/
│   └── .venv/
│
└── pubspec.yaml
```

---

# Installation Guide

## 1. Clone Repository

```bash
git clone https://github.com/Marie-66/proto_app.git
```

---

## 2. Flutter Setup

```bash
flutter pub get
flutter run
```

---

## 3. Laravel Backend Setup

Go to backend folder:

```bash
cd proto_backend
```

Install dependencies:

```bash
composer install
```

Generate app key:

```bash
php artisan key:generate
```

Run migrations:

```bash
php artisan migrate
```

Start Laravel server:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

---

## 4. Python Face Recognition Setup

Go to Python service folder:

```bash
cd face-service-python
```

Create virtual environment:

```bash
python -m venv .venv
```

Activate virtual environment:

```bash
.venv\Scripts\activate
```

Install dependencies:

```bash
pip install flask
pip install cmake
pip install dlib
pip install face-recognition
pip install opencv-python
pip install numpy
```

Run Flask server:

```bash
python app.py
```

---

## 5. Android Device Connection

Run adb reverse:

```bash
adb reverse tcp:8000 tcp:8000
adb reverse tcp:5001 tcp:5001
```

---

# API Endpoints

## Laravel API

```text
GET    /api/events
POST   /api/attendance/check-in
GET    /api/staff/{staff_id}
```

## Python Face Recognition API

```text
GET    /test
POST   /match
```

---

# Face Registration

Place registered face images inside:

```text
face-service-python/faces/
```

Example:

```text
EMP-001.jpg
EMP-002.jpg
```

The filename should match the staff ID stored in the database.

---

# Sample Workflow

1. Create event
2. Open event
3. Register staff
4. Add face image
5. Scan face using Flutter app
6. Python service matches face
7. Laravel saves attendance
8. Attendance appears in database

---

# Developers

BSIT Capstone Project Group

University Event Management System with Smart Facial Recognition

---

# Future Improvements

- Duplicate attendance prevention
- Face enrollment inside mobile app
- PDF attendance reports
- Excel export
- Authentication system
- Admin web dashboard
- Cloud deployment
- AI confidence scoring

---

# License

This project is for educational and academic purposes only.

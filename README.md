# Smart Presence 📱

**A smart attendance management system designed to simplify and digitize classroom attendance.**

## 📌 Overview

Smart Presence is an attendance management project designed to make classroom attendance more convenient and organized.

The project uses a Python backend and PostgreSQL database to manage students, faculty, classes, subjects, teaching assignments, attendance sessions, and attendance records.

QR-code-based attendance is part of the current development. A mobile application and additional verification methods are planned for future development.

## ✨ Features

### Current Development

- FastAPI backend
- PostgreSQL database integration
- Student and faculty management
- Class and subject management
- Teaching assignment management
- Attendance session management
- QR-code-based attendance workflow

### Planned Features

- React Native mobile application using Expo
- Smartphone biometric authentication using supported device APIs
- Bluetooth Low Energy (BLE) proximity verification
- Attendance history and reports
- Improved attendance verification and session security

*Feature availability depends on implementation and testing progress.*

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Python | Backend programming |
| FastAPI | Backend API framework |
| PostgreSQL | Relational database |
| Psycopg | PostgreSQL connectivity |
| QR codes | Attendance workflow |
| React Native | Planned mobile application |
| Expo | Planned mobile development environment |
| Bluetooth Low Energy | Planned proximity verification |

## 📂 Project Structure

```text
smart_presence/
├── backend/
│   ├── __pycache__/       # Generated Python cache
│   ├── qr_codes/          # Generated QR-code images
│   └── main.py            # FastAPI application
├── database/
│   ├── sample_data.sql    # Sample database records
│   └── schema.sql         # Database schema
└── README.md
```

## ⚙️ Getting Started

### Prerequisites

Install the following software:

- Python 3
- PostgreSQL
- Git

### 1. Clone the Repository

After the repository is published on GitHub, run:

```bash
git clone https://github.com/YOUR-USERNAME/smart-presence.git
cd smart-presence
```

Replace `YOUR-USERNAME` with your GitHub username.

### 2. Create a Virtual Environment

On Windows:

```bash
python -m venv venv
venv\Scripts\activate
```

### 3. Install Dependencies

Install the packages listed in `requirements.txt`:

```bash
pip install -r requirements.txt
```

### 4. Configure Environment Variables

Create a local `.env` file using the variable names expected by the backend.

Typical settings include:

```dotenv
SECRET_KEY=your_random_secret_key
ALGORITHM=HS256
DB_HOST=localhost
DB_PORT=5432
DB_NAME=smart_presence
DB_USER=your_database_user
DB_PASSWORD=your_database_password
```

Use your own local values. Never publish real passwords, secret keys, or database credentials.

### 5. Set Up the Database

Create a PostgreSQL database named `smart_presence`.

From the project root, apply the database schema:

```bash
psql -U postgres -d smart_presence -f database/schema.sql
```

Enter your PostgreSQL password when prompted.

### 6. Load Sample Data (Optional)

To insert sample records into a development database, run:

```bash
psql -U postgres -d smart_presence -f database/sample_data.sql
```

Review the script before executing it. Use sample data only in a database prepared for that script to avoid duplicate records or conflicting IDs.

### 7. Run the Backend

If the FastAPI application entry point is `backend/main.py`, run the following from the project root:

```bash
uvicorn backend.main:app --reload
```

Open the API documentation at:

http://127.0.0.1:8000/docs

The exact command may vary depending on the application's configuration.

## 🔐 Security

- Keep environment variables and credentials private.
- Never commit a real `.env` file.
- Use strong, randomly generated application secrets.
- Do not publish personal student or faculty information.
- Use fictional data for development and demonstrations.
- Validate attendance sessions on the backend.
- Design QR tokens to prevent unauthorized reuse.
- Use smartphone biometric APIs rather than collecting raw fingerprint data.

## 🗺️ Development Roadmap

- [x] Initial project structure
- [x] PostgreSQL database setup
- [x] Backend development
- [x] QR-code workflow development and testing
- [ ] Complete backend API verification
- [ ] Develop the React Native mobile application
- [ ] Connect the mobile application to the backend
- [ ] Explore Bluetooth Low Energy proximity verification
- [ ] Add smartphone biometric authentication
- [ ] Implement attendance history and reports
- [ ] Test the complete system on Android devices

*Update the checklist as features are completed and verified.*

## 🎯 Project Goals

- Reduce manual attendance work.
- Maintain centralized attendance records.
- Improve convenience for students and faculty.
- Explore QR codes and device-based verification.
- Build a foundation for a mobile attendance system.

## 🤝 Contributing

Suggestions, bug reports, and improvements are welcome.

1. Fork the repository.
2. Create a branch for your changes.
3. Make and test your changes.
4. Submit a pull request describing your contribution.

## 📄 License

A license has not been selected yet. Add a license when you decide how others may use, modify, and distribute this project.

---

**Smart Presence — making attendance management smarter, one step at a time.**

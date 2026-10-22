from fastapi import FastAPI, HTTPException, Depends, Header
from fastapi.security import HTTPBearer
from database import conn
from jose import jwt, JWTError
import qrcode
from fastapi.responses import FileResponse
from psycopg import Error
from psycopg.errors import UniqueViolation
import datetime
import secrets
import bcrypt
from pydantic import BaseModel, Field
from typing import Annotated
from pathlib import Path
import os
from dotenv import load_dotenv

app = FastAPI()

QR_DIR = Path(__file__).parent / "qr_codes"
QR_DIR.mkdir(exist_ok=True)
load_dotenv()
SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")


bearer_verify = HTTPBearer()
if SECRET_KEY is None or ALGORITHM is None:
        raise RuntimeError("secret key or algorithm not found")

def jwt_auth(authorization=Depends(bearer_verify)):

    try:
        payload = jwt.decode(authorization.credentials, SECRET_KEY, ALGORITHM) # type: ignore
        return payload
    except JWTError:
        raise HTTPException(status_code=401, detail="Unauthorized")


class LoginRequest(BaseModel):
    role: Annotated[
        str, Field(..., description="Select Role", examples=["faculty/student"])
    ]
    login_id: Annotated[str, Field(..., description="Enter your login id")]
    password: Annotated[str, Field(..., description="Enter the password")]


@app.get("/")
def home():
    
    return {"message": "Welcome to home-page of smart_presence backend"}



@app.get("/students/count")
def count():
    cursor = conn.cursor()
    cursor.execute("SELECT COUNT(roll_no) FROM students;")
    result = cursor.fetchone()
    cursor.close()
    return {"count": result[0]}  # type: ignore


@app.post("/attendance/session/start")
def start_session(assignment_id: int, payload=Depends(jwt_auth)):
    cursor = conn.cursor()
    cursor.execute(
        "SELECT faculty_id FROM teaching_assignment WHERE assignment_id =%s",
        (assignment_id,),
    )
    faculty_id = cursor.fetchone()
    cursor.close()
    if faculty_id is None:
        raise HTTPException(status_code=404, detail="Assignment not found")

    if payload["role"] == "faculty" and payload["faculty_id"] == faculty_id[0]:
        current = datetime.datetime.now()
        token = secrets.token_urlsafe(10)
        cursor = conn.cursor()
        date = current.date()
        time = current.time()
        status = "OPEN"
        cursor.execute(
            "INSERT INTO attendance_session(assignment_id, session_token, session_date, started_at, status) VALUES (%s,%s,%s,%s,%s)",
            (assignment_id, token, date, time, status),
        )
        conn.commit()
        cursor.close()
        qr = qrcode.QRCode()
        qr.add_data(token)
        qr.make()
        img = qr.make_image()
        img.save(QR_DIR/f"qr_{token}.png")
        return {"message": "session created",
                'session_key': token
                }

    else:
        raise HTTPException(
            status_code=403, detail="not allowed to perform this action"
        )


@app.get("/attendance/session/qr/{token}")
def get_session_qr(token: str, payload = Depends(jwt_auth)):
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT assignment_id,session_id FROM attendance_session WHERE session_token = %s;",(token,))
        result = cursor.fetchone()
        if result is None:
            raise HTTPException(status_code=404,detail="session not found")
        cursor.execute(
            "SELECT faculty_id FROM teaching_assignment WHERE assignment_id =%s",
            (result[0],),
        )
        faculty_id = cursor.fetchone()
        if faculty_id is None:
                raise HTTPException(status_code=404,detail="faculty not found")
        if  payload["role"] == "faculty" and payload["faculty_id"] == faculty_id[0]:
            path = QR_DIR/f"qr_{token}.png"
            if not path.exists():
                raise HTTPException(status_code=404, detail="QR code not found")
            return FileResponse(path, media_type= "image/png")
        else:
            raise HTTPException(
                status_code=403, detail="not allowed to perform this action"
            ) 
    finally:
        cursor.close()


@app.post("/attendance/session/close")
def close_session(token:str, payload=Depends(jwt_auth)):
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT session_id, assignment_id,status FROM attendance_session WHERE session_token = %s;",(token,))
        result = cursor.fetchone()
        if result is None:
            raise HTTPException(status_code=404, detail="Session not found")
        if result[2]=="CLOSED":
            raise HTTPException(status_code=409, detail="Session is already closed")
        cursor.execute("SELECT faculty_id FROM teaching_assignment WHERE assignment_id = %s",(result[1],))
        result_faculty = cursor.fetchone()
        if payload["role"]== "faculty":
            if result_faculty is None:

                raise HTTPException(status_code=404, detail="Assignment not found")
            if result_faculty[0]==payload["faculty_id"] :# type: ignore
                cursor.execute("SELECT class_id, lab_batch FROM teaching_assignment WHERE assignment_id = %s",(result[1],))
                class_result = cursor.fetchone()
                if class_result is None:
    
                    raise HTTPException(status_code=404, detail="Assignment not found")
                current = datetime.datetime.now()
                time = current.time()
                
                if class_result[1] is None:
                    cursor.execute("INSERT INTO attendance (session_id,enrollment_no,status,marked_at) SELECT %s, students.enrollment_no, 'ABSENT',%s FROM students WHERE students.class_id = %s AND NOT EXISTS(SELECT 1 FROM attendance WHERE attendance.session_id = %s AND attendance.enrollment_no = students.enrollment_no);",(result[0],time,class_result[0],result[0],))
                    
                elif class_result[1] is not None:
                    cursor.execute("INSERT INTO attendance (session_id,enrollment_no,status,marked_at) SELECT %s, students.enrollment_no, 'ABSENT',%s FROM students WHERE students.class_id = %s AND students.lab_batch = %s AND NOT EXISTS(SELECT 1 FROM attendance WHERE attendance.session_id = %s AND attendance.enrollment_no = students.enrollment_no);",(result[0],time,class_result[0],class_result[1],result[0],))
                cursor.execute("UPDATE attendance_session SET status = 'CLOSED', closed_at =%s WHERE session_token = %s;",(time,token,))
                conn.commit()
                qr_path = QR_DIR / f"qr_{token}.png"
                if qr_path.exists():
                    qr_path.unlink()
                    
                return{'message': 'Session closed successfully'}
    
        


            else:
                raise HTTPException(
                        status_code=403, detail="not allowed to perform this action"
                    )
        else:
            raise HTTPException(
                status_code=403, detail="not allowed to perform this action"
            )
    except Error:
        conn.rollback()
        raise 
    finally:
        cursor.close()

@app.post("/auth/login")
def login(request: LoginRequest):
    if request.role == "faculty":
        cursor = conn.cursor()
        cursor.execute(
            "SELECT faculty_id, password_hash FROM faculty WHERE email = %s;",
            (request.login_id,),
        )
        
        result = cursor.fetchone()
        cursor.close()
        if result is None:
            return {"Invalid email or password"}
        else:

            check = bcrypt.checkpw(
                request.password.encode("utf-8"), result[1].encode("utf-8")
            )
            if check == False:
                return {"Invalid email or password"}
            payload = {"faculty_id": result[0], "role": "faculty"}
            token = jwt.encode(payload, SECRET_KEY, ALGORITHM)
            return {
                "message": "welcome to faculty login page",
                "faculty_id": result[0],
                "access_token": token,
            }
    elif request.role == "student":
        cursor = conn.cursor()
        cursor.execute(
            "SELECT enrollment_no, password_hash FROM students WHERE enrollment_no = %s;",
            (request.login_id,),
        )
        result = cursor.fetchone()
        cursor.close()
        if result is None:
            return {"Invalid login ID or password"}
        else:
            check = bcrypt.checkpw(
                request.password.encode("utf-8"), result[1].encode("utf-8")
            )
            if check == False:
                return {"Invalid login ID or password"}
            payload = {"enrollment_no": result[0], "role": "student"}
            token = jwt.encode(payload, SECRET_KEY, ALGORITHM)
            return {
                "message": "welcome to student login page",
                "enrollment_no": result[0],
                "access_token": token,
            }
        

    else:
        return {"invalid role"}


@app.get("/protected")
def protected(payload=Depends(jwt_auth)):
    return payload


@app.post("/student/attendance/mark")
def attendance_mark(token: str, payload=Depends(jwt_auth)):
    cursor = conn.cursor()
    try:
        if payload["role"]== "student":
            cursor.execute("SELECT session_id, assignment_id, status from attendance_session WHERE session_token = %s", (token,))
            result = cursor.fetchone()
            if result is None:
                raise HTTPException(status_code=404, detail="data not found")
            elif result[2] == 'CLOSED':
                raise HTTPException(status_code=403, detail="session is closed ")
            elif result[2] == 'OPEN':
                cursor.execute("SELECT class_id, lab_batch FROM teaching_assignment WHERE assignment_id = %s",(result[1],))
                class_result = cursor.fetchone()

                if class_result is None:
                    raise HTTPException(status_code=404, detail="Assignment not found")
                current = datetime.datetime.now()
                time = current.time()
                enrollment_no = payload["enrollment_no"]
                cursor.execute("SELECT class_id, lab_batch FROM students WHERE enrollment_no = %s", (enrollment_no,))
                result_class = cursor.fetchone()
                
                if result_class is None:
                    raise HTTPException(status_code=404, detail="Assignment not found")
                if class_result[1] is not None:
                    if class_result[0]==result_class[0] and class_result[1]==result_class[1]:
                        cursor.execute("INSERT INTO attendance(session_id,enrollment_no,status,marked_at) VALUES(%s,%s,%s,%s)",(result[0],enrollment_no,"PRESENT",time))
                        conn.commit()
                        return{'message':'Attendance marked'}
                    else:
                        raise HTTPException(
                            status_code=403, detail="not allowed to perform this action"
                        )
                elif class_result[1] is None:
                    if class_result[0]==result_class[0]:
                        cursor.execute("INSERT INTO attendance(session_id,enrollment_no,status,marked_at) VALUES(%s,%s,%s,%s)",(result[0],enrollment_no,"PRESENT",time))
                        conn.commit()
                        return{'message':'Attendance marked'}
                    else:
                        raise HTTPException(
                            status_code=403, detail="not allowed to perform this action"
                        )
            else:
                raise HTTPException(
                    status_code=403, detail="not allowed to perform this action"
                )
        else:
                raise HTTPException(
                    status_code=403, detail="not allowed to perform this action"
                )
    except UniqueViolation:
        conn.rollback()
        raise HTTPException(status_code=409,detail='Attendance already marked')
    finally:
        cursor.close()
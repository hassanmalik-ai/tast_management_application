
from fastapi import FastAPI
from starlette.responses import JSONResponse
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig, MessageType
from typing import List
 


conf = ConnectionConfig(
    MAIL_USERNAME = "hassan.softwarenineer@gmail.com",
    MAIL_PASSWORD = "pkct fkyj vgtx gkzp",
    MAIL_FROM = "hassan.softwarengineer@gmail.com",
    MAIL_PORT = 587,
    MAIL_SERVER = "smtp.gmail.com",
    MAIL_FROM_NAME="Task Management App",
    MAIL_STARTTLS = True,
    MAIL_SSL_TLS = False,
    USE_CREDENTIALS = True,
    VALIDATE_CERTS = True
)

async def send_email(email:List[str]):
    html = """<p>Hi, Thanks for register.Our team will connect with you soon!</p> """

    message = MessageSchema(
        subject="Registration Confirmation",
        recipients=email.dict().get("email"),
        body=html,
        subtype=MessageType.html)

    fm = FastMail(conf)
    await fm.send_message(message)
    return {"Message":"email has been send"}
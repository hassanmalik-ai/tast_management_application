
from fastapi import FastAPI
from starlette.responses import JSONResponse
from typing import List

# Email sending is optional — set MAIL_ENABLED=True and configure credentials to enable
MAIL_ENABLED = False

try:
    from fastapi_mail import FastMail, MessageSchema, ConnectionConfig, MessageType

    conf = ConnectionConfig(
        MAIL_USERNAME="hassan.softwarenineer@gmail.com",
        MAIL_PASSWORD="pkct fkyj vgtx gkzp",
        MAIL_FROM="hassan.softwarengineer@gmail.com",
        MAIL_PORT=587,
        MAIL_SERVER="smtp.gmail.com",
        MAIL_FROM_NAME="Task Management App",
        MAIL_STARTTLS=True,
        MAIL_SSL_TLS=False,
        USE_CREDENTIALS=True,
        VALIDATE_CERTS=True,
    )
    MAIL_ENABLED = True
except ImportError:
    MAIL_ENABLED = False


async def send_email(email: List[str]):
    """Send registration confirmation email. Silently skips if mail is not configured."""
    if not MAIL_ENABLED:
        print(f"[Mail] Skipping email send (mail not configured) to: {email}")
        return {"Message": "email sending skipped (not configured)"}

    html = """<p>Hi, Thanks for registering. Our team will connect with you soon!</p>"""

    message = MessageSchema(
        subject="Registration Confirmation",
        recipients=email,  # email is already a List[str]
        body=html,
        subtype=MessageType.html,
    )

    fm = FastMail(conf)
    await fm.send_message(message)
    return {"Message": "email has been sent"}
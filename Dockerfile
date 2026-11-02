# שימוש בבסיס פייתון רזה (Slim)
FROM python:3.11-slim

# הגדרת תיקיית עבודה בתוך הקונטיינר
WORKDIR /app

# מניעת יצירת קבצי pyc והגדרת פלט לא מאוחסן בבאפר (Unbuffered)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# התקנת תלויות מערכת נדרשות במידת הצורך (למשל עבור חבילות מסוימות)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# העתקת קבצי הדרישות והתקנת החבילות
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# העתקת קוד האפליקציה
COPY . .

# יצירת משתמש שאינו Root (Non-root user) משיקולי אבטחת מידע
RUN useradd -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# חשיפת הפורט של האפליקציה
EXPOSE 8000

# הפעלת השרת בהתאם לפרรมטר (Uvicorn עבור FastAPI או Gunicorn עבור Flask)
# עבור FastAPI עם Uvicorn:
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

# עבור Flask עם Gunicorn (יש להחליף את ה-CMD במידת הצורך):
# CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]

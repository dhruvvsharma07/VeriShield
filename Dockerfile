# Use a Python 3.11 base image that already has build tools
FROM python:3.11-slim

# Install system-level dependencies (The fix for libGL and dlib)
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set up user and directory
RUN useradd -m -u 1000 user
USER user
ENV PATH="/home/user/.local/bin:$PATH"
WORKDIR /app

# Copy requirements and install
COPY --chown=user requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY --chown=user . .

# Expose Streamlit port
EXPOSE 7860

# Run the app
CMD ["streamlit", "run", "mainapp.py", "--server.port=7860", "--server.address=0.0.0.0"]
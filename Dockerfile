FROM python:slim

WORKDIR /proj_home

COPY data/ ./
COPY src/ ./
COPY requirements_data.txt ./
RUN pip install --no-cache-dir -r requirements_data.txt

COPY . .

CMD [ "python", "./src/data/get_data.py" ]
FROM python:slim

WORKDIR /proj_home

COPY requirements_data.txt ./
RUN pip install --no-cache-dir -r requirements_data.txt

COPY . .

CMD [ "python", "./get_data.py" ]
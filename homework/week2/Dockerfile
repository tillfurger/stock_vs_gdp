FROM python:slim

WORKDIR /plot_home

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./plot.py" ]

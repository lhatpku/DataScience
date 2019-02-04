###############################################
# Dependencies
###############################################
import datetime as dt
import numpy as np
import pandas as pd

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func, and_, inspect

from flask import Flask, jsonify

###############################################
# Database Setup
###############################################
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

Base = automap_base()
Base.prepare(engine,reflect=True)

# References to the measurement and station tables
Station = Base.classes.station
Measurement = Base.classes.measurement

# Create the session link
session = Session(engine)

###############################################
# Flask
###############################################

# Flask Set up 
app = Flask(__name__)

# Home Route
@app.route("/")
def Home():

    return (
        
        f"Avalable Routes:<br/>"

        f"/api/v1.0/precipitation - List of Precipitation Observations from the database<br/>"

        f"/api/v1.0/stations - List of stations from the database<br/>"

        f"/api/v1.0/tobs - List of Temperature Observations for a year from the last data point<br/>"

        f"/api/v1.0/&ltstart&gt/&ltend&gt - Min, avg, max temp for a time range (start --> or start --> end, format = yyyy-mm-dd)<br/>"

    )

# Precipitation Data
###############################################
@app.route("/api/v1.0/precipitation")
def precipitation():

    # select all the data and precipitation 
    results = session.query(Measurement.date, Measurement.prcp).\
        order_by(Measurement.date).all()

    # convert results to dictionary and return json file
    prec_dict = {}

    for date, prcp in results:
        prec_dict[date] = prcp

    return jsonify(prec_dict)

# Station Data
###############################################
@app.route("/api/v1.0/stations")
def stations():
    # Station column names
    name_list = []
    inspector = inspect(engine)
    columns = inspector.get_columns('station')
    for column in columns:
        name_list.append(column["name"])
    name_list.remove('id')

    station_dict = {}
    for result in session.query(Station):
        result_dict = result.__dict__
        result_dict_clean = {key: result_dict[key] for key in name_list }
        station_dict['id_'+str(result_dict['id'])] = result_dict_clean
    
    return jsonify(station_dict)

# Temperature observations from a year from the last data point.
###############################################
@app.route("/api/v1.0/tobs")
def tobs():

    # Find one year before
    last_date, = engine.execute("""SELECT m.date
                    FROM Measurement m
                    GROUP BY 1
                    ORDER BY date desc;
                """).fetchall()[0]

    year,month_date = last_date.split('-', maxsplit=1)
    
    one_year_before = str(int(year) - 1) + '-' + month_date

    # select date and temperation for the time period
    results = session.query(Measurement.date, Measurement.tobs). \
        filter(Measurement.date >= one_year_before). \
        order_by(Measurement.date).all()

    # convert results to dictionary
    temp_dict = {}

    for date,temp in results:
        temp_dict[date] = temp

    return jsonify(temp_dict)

# Min, avg, max temp for a time range
###############################################
@app.route("/api/v1.0/<start>",defaults={"end": 0000})
@app.route("/api/v1.0/<start>/<end>")
def temp_stat1(start,end):

    if end == 0000:
        end, = engine.execute("""SELECT m.date
                FROM Measurement m
                GROUP BY 1
                ORDER BY date desc;
            """).fetchall()[0]

    temp_min,temp_avg,temp_max = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
        filter(and_(Measurement.date >= start, Measurement.date <= end)).all()[0]

    temp_dict = {}
    temp_dict["min_temp"] = temp_min
    temp_dict["avg_temp"] = temp_avg
    temp_dict["max_temp"] = temp_max

    return jsonify(temp_dict)

if __name__ == '__main__':
    app.run()
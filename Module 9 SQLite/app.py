import datetime as dt
import numpy as np
import pandas as pd
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
from flask import Flask, json, jsonify

#Setup the database
engine=create_engine("sqlite:///hawaii.sqlite")  #access db
Base=automap_base()  
Base.prepare(engine, reflect=True) #reflect into new model
Measurement=Base.classes.measurement #referenes to each table
Station=Base.classes.station
session=Session(engine)

#Define Flask application 
app = Flask(__name__)  #create Flask application
@app.route("/")  # define welcome route as the root
def welcome():
    return(
    '''
    Welcome to the Climate Analysis API!
    Available Routes:
    /api/v1.0/precipitation
    /api/v1.0/stations
    /api/v1.0/tobs
    /api/v1.0/temp/start/end
    ''')

@app.route("/api/v1.0/precipitation")   # create precipitation route
def precipitation():
    prev_year=dt.date(2017,8,23)-dt.timedelta(days=365)
    # query to get the date and precip for previous year
    precipitation=session.query(Measurement.date, Measurement.prcp).\
        filter(Measurement.date>=prev_year).all()
    precip={date: prcp for date,prcp in precipitation}  #create dict
    return jsonify(precip)

@app.route("/api/v1.0/stations") # create stations route
def stations():
    results=session.query(Station.station).all()
    stations = list(np.ravel(results))
    return jsonify(stations=stations)

@app.route("/api/v1.0/tobs") # temps for past year
def temp_monthly():
    prev_year=dt.date(2017,8,23)-dt.timedelta(days=365)
    results=session.query(Measurement.tobs).\
        filter(Measurement.station=='USC00519281').\
        filter(Measurement.date>=prev_year).all()
    temps=list(np.ravel(results))
    return jsonify(temps=temps)

@app.route("/api/v1.0/temp/<start>")
@app.route("/api/v1.0/temp/<start>/<end>")
def stats(start=None,end=None):
    sel=[func.min(Measurement.tobs),func.avg(Measurement.tobs),func.max(Measurement.tobs)]
    
    if not end:   # the * means multiple results are ret'd from query: min,avg,max
        results=session.query(*sel).\
            filter(Measurement.date>=start).all()
        temps=list(np.ravel(results))
        return jsonify(temps)
    
    results=session.query(*sel).\
        filter(Measurement.date>=start).\
        filter(Measurement.date<=end).all()
    temps=list(np.ravel(results))
    return jsonify(temps)

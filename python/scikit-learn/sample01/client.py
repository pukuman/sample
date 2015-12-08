# coding: UTF-8
from bottle import route, run, template, HTTPResponse


@route('/machineclient')
def machineclient():

    t =  template('index.html')
    r = HTTPResponse(sattus=200, body = t)
    r.set_header('Access-Control-Allow-Origin','*');
    return r


run(host='0.0.0.0', port=55889)

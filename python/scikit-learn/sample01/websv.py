from bottle import route, run, HTTPResponse

from sklearn import datasets
from sklearn import svm
from sklearn.externals import joblib

@route('/machinelearn/<data>')
def index(data):
    data_array = data.split('_')

    # $B5!3#3X=,7k2L$N%b%G%k$rFI$_9~$_(B
    clf = joblib.load('./clf/sample01.pkl')

    # $B<B9T(B
    result = clf.predict([data_array])
    r = HTTPResponse(sattus=200, body = '<h1>%d</h1>' % result)
    r.set_header('Access-Control-Allow-Origin','*');
    return r


run(host='0.0.0.0', port=55888)

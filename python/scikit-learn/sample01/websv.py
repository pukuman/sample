from bottle import route, run, HTTPResponse

from sklearn import datasets
from sklearn import svm
from sklearn.externals import joblib

@route('/machinelearn/<data>')
def index(data):
    data_array = data.split('_')

    # 機械学習結果のモデルを読み込み
    clf = joblib.load('./clf/sample01.pkl')

    # 実行
    result = clf.predict([data_array])
    r = HTTPResponse(sattus=200, body = '<h1>%d</h1>' % result)
    r.set_header('Access-Control-Allow-Origin','*');
    return r


run(host='0.0.0.0', port=55888)

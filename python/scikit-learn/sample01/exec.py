# 機械学習用のライブラルをロード
from sklearn import datasets
from sklearn import svm
from sklearn.externals import joblib

# 機械学習結果のモデルを読み込み
clf = joblib.load('./clf/sample01.pkl')

# サンプルデータのロード
digits = datasets.load_digits()

# 実行
#  サンプルデータの配列から100毎にデータを解析
for i in range(0,len(digits.data),100):
    # 機械学習結果実行 
    result = clf.predict([digits.data[i]])
    # 結果表示
    flag = "OK" if result == digits.target[i] else "NG!!!!"
    print "data[%4d]:machine learn => %2d ans => %2d (%s)" % (i,result,digits.target[i],flag)



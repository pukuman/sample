# 機械学習用のライブラルをロード
from sklearn import datasets
from sklearn import svm
from sklearn.externals import joblib

# サンプルデータのロード
digits = datasets.load_digits()

# 機械学習方式として、サポートベクターマシン(SVC)を指定
clf = svm.SVC(gamma=0.001, C=100.)

# サンプルデータを渡して、機械学習実行
#   digits.data   = 入力データ(数値の2次元配列)
#   digits.target = 正解データ(数値の1次元配列)
clf.fit(digits.data,digits.target)

# 機械学習の結果作成されたモデルを保存(シリアライズ)
joblib.dump(clf, './clf/sample01.pkl')



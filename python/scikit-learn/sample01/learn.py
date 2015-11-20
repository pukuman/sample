# $B5!3#3X=,MQ$N%i%$%V%i%k$r%m!<%I(B
from sklearn import datasets
from sklearn import svm
from sklearn.externals import joblib

# $B%5%s%W%k%G!<%?$N%m!<%I(B
digits = datasets.load_digits()

# $B5!3#3X=,J}<0$H$7$F!"%5%]!<%H%Y%/%?!<%^%7%s(B(SVC)$B$r;XDj(B
clf = svm.SVC(gamma=0.001, C=100.)

# $B%5%s%W%k%G!<%?$rEO$7$F!"5!3#3X=,<B9T(B
#   digits.data   = $BF~NO%G!<%?(B($B?tCM$N(B2$B<!85G[Ns(B)
#   digits.target = $B@52r%G!<%?(B($B?tCM$N(B1$B<!85G[Ns(B)
clf.fit(digits.data,digits.target)

# $B5!3#3X=,$N7k2L:n@.$5$l$?%b%G%k$rJ]B8(B($B%7%j%"%i%$%:(B)
joblib.dump(clf, './clf/sample01.pkl')



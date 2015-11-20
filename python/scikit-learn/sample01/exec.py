# $B5!3#3X=,MQ$N%i%$%V%i%k$r%m!<%I(B
from sklearn import datasets
from sklearn import svm
from sklearn.externals import joblib

# $B5!3#3X=,7k2L$N%b%G%k$rFI$_9~$_(B
clf = joblib.load('./clf/sample01.pkl')

# $B%5%s%W%k%G!<%?$N%m!<%I(B
digits = datasets.load_digits()

# $B<B9T(B
#  $B%5%s%W%k%G!<%?$NG[Ns$+$i(B100$BKh$K%G!<%?$r2r@O(B
for i in range(0,len(digits.data),100):
    # $B5!3#3X=,7k2L<B9T(B 
    result = clf.predict([digits.data[i]])
    # $B7k2LI=<((B
    flag = "OK" if result == digits.target[i] else "NG!!!!"
    print "data[%4d]:machine learn => %2d ans => %2d (%s)" % (i,result,digits.target[i],flag)



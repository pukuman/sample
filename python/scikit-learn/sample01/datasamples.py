# coding: UTF-8

from sklearn import datasets
from sklearn import svm

digits = datasets.load_digits()
clf = svm.SVC(gamma=0.001, C=100.)

for i in range(500,len(digits.data)):
    if (i % 100) != 0:
        continue
    clf.fit(digits.data[0:i],digits.target[0:i])
    ans = clf.predict(digits.data)
    oks = 0
    ngs = 0
    for (t,a) in zip(digits.target,ans):
        
        if t == a:
            oks = oks + 1
        else :
            ngs = ngs + 1

    print "sample datas=%4d, oks=%4d, ngs=%4d, hit rate=%4.2f %%" % (i,oks,ngs,oks*100.0/len(digits.data))

   


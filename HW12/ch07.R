
#Ū�ɮסA�ݤ@�U�e����
#�{������7.1
dta <- read.table('data/cesd.txt',header=TRUE)
str(dta)
head(dta)

#���D�ض�����
#��7.1
require(corrplot)
corrplot(cor(dta), method="ellipse", type="lower", 
 col=gray.colors(200,start = 1, end = 0),tl.col="black") 

#�Q�� moment�M��ݬݰ��A�P�p��
#�{������7.2
require(moments)
skkur <- cbind(skewness(dta), kurtosis(dta))
dimnames(skkur)[[2]] <- c('���A','�p��')
round(skkur,3)


#lavaan �O R ���x�W SEM �� package
require(lavaan)

#CESD ���|�]���ҫ�
#�g�k�O �]�� =~ ���q����
CESD.M1 <- '
�~�{���P=~�d��+����+�I��+�h��+�дo+����+�e�e����
����g��=~�x�Z+�O�O+���M��+�ίv+�訥+�L�O+�G�f���n
�H�ڧx�Z=~���͵�+�����w
���V���P=~�}�n+�ֽ�+�ּ�+�Ʊ�'

#�] CFA�A�n�����ҫ� CESD.M1 �P��ƦW�� dta
fit <- cfa(CESD.M1, data=dta,std.lv=TRUE)

#��X���G
#�{������7.3, 7.4
summary(fit, fit.measures=TRUE)

#�w�q���q���P���q���D��
scale1 <- c(1,1:7)
scale2 <- c(2,8:14)
scale3 <- c(3,15:16)
scale4 <- c(4,17:20)

#�w�q�p��p��c���H�סB�D�ثH�׻P�����ܲ�����q
my_reli <- function(w){
 x <- w[-1]
 y <- w[1]
 L <- fit@Model@GLIST$lambda[x,y]
 P <- diag(fit@Model@GLIST$psi)[y]
 E <- diag(fit@Model@GLIST$theta)[x]
 reli <- sum(L)^2*P/(sum(L)^2*P+sum(E))
 itemreli <- L*L*P/(L*L*P+E)
 AVE <- mean(itemreli)
 show(my_reli <- list(reli=reli,itemreli=itemreli,AVE=AVE))
}

my_reli(scale1)

scale <- list(scale1,scale2,scale3,scale4)
lapply(scale,my_reli)


#ø�s���|��
require(semPlot)
semPaths(fit,style='lisrel','std',nCharNodes=8,nCharEdges=3)

## ����CESD �|�]���ҫ��A�o�{�A�X�׻ݧﵽ�A���Q�έק����
## �ץ��ҫ��C
## �ѩ�Ҽ{����e���ҡ]cross-validation�^�A���Ƥ�����Ӽ�
## ���A�@�Ӯ��Ӱ��ծռ˥��]calibration sample�^�A�@�Ӯ��Ӱ�
## ��e���Ҽ˥��C

#Ū��
dat <-read.table('data/cesd.txt',header=T)


#�H��������աB���O�O dat0(�ծռ˥�)�P dat1(��e���Ҽ˥�) 
#set.seed �O�H���ؤl�A�i�H�ۥѳ]�w�ƭ�
#�T�w�H���ؤl�i�H���C�����լۦP�A���R�ۦP���ո��
#�p�G�S�γo�ӫ��O�A�C������ɡA�H�����ճ��|���P
set.seed(20140826)
id0 <- sample(dim(dat)[1], dim(dat)[1]/2)
dat0 <- dat[id0,]
dat1 <- dat[-id0,]


#��l�ҫ�
require(lavaan)
CESD.M1 <- '
�~�{���P=~�d��+����+�I��+�h��+�дo+����+�e�e����
����g��=~�x�Z+�O�O+���M��+�ίv+�訥+�L�O+�G�f���n
�H�ڧx�Z=~���͵�+�����w
���V���P=~�}�n+�ֽ�+�ּ�+�Ʊ�'

#��ܭק���СC
#�{������7.5
fit0 <- cfa(CESD.M1, data=dat0, std.lv=TRUE)
summary(fit0, fit.measures=TRUE)
modindices(fit0)

#�C�X�e�Q��
modi <-modindices(fit0)
modi[order(-modi$mi),][1:10,]


#�ק�ҫ��A�[�J�u�e�e����~~�G�f���n�v�A�Y��̴��q�~�t���@��
CESD.M1 <- '
�~�{����=~�d��+����+�I��+�h��+�дo+����+�e�e����
������D=~�x�Z+�O�O+���M��+�ίv+�訥+�L�O+�G�f���n
�H�ڧx�Z=~���͵�+�����w
���V����=~�}�n+�ֽ�+�ּ�+�Ʊ�
�e�e����~~�G�f���n'

#�t�A�ݬݡC
fit0 <- cfa(CESD.M1, data=dat0, std.lv=TRUE)
summary(fit0, fit.measures=TRUE)

#�b�ծռ˥��U�A�~��ݬݭ�l�ҫ����Ǧa��i��ݭn��
#�������ҫ��P��ưt�A
modindices(fit0)


#�ק�ҫ��A�[�J�u�e�e����~~�訥�v�A�Y��̴��q�~�t���@��
CESD.M1 <- '
�~�{����=~�d��+����+�I��+�h��+�дo+����+�e�e����
������D=~�x�Z+�O�O+���M��+�ίv+�訥+�L�O+�G�f���n
�H�ڧx�Z=~���͵�+�����w+����
���V����=~�}�n+�ֽ�+�ּ�+�Ʊ�
�e�e����~~�G�f���n
�e�e����~~�訥'
fit0 <- cfa(CESD.M1, data=dat0, std.lv=TRUE)
summary(fit0, fit.measures=TRUE)


#�קﵲ���A�N�ҫ��Φb�椬���Ҽ˥��C
fit <- cfa(CESD.M1, data=dat1, std.lv=TRUE)
summary(fit, fit.measures=TRUE)

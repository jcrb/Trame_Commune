# source: Arthur charpentier (http://freakonometrics.hypotheses.org/1224)
# Placer sur un même graphique barplot et lines

graphique = function(nom="ageconducteur",
                   niveau=c(17,21,24,29,34,44,64,84,110),
                   continu=TRUE,type=1){
    if(continu==TRUE){X=cut(basenb[,nom],niveau)}
    if(continu==FALSE){X=as.factor(basenb[,nom])}
    E=basenb$exposition
    Y=basenb$nbre
    FREQ=levels(X)
    moyenne=variance=n=rep(NA,length(FREQ))
    for(k in 1:length(FREQ)){
        moyenne[k] =weighted.mean(Y[X==FREQ[k]]/E[X==FREQ[k]],E[X==FREQ[k]])
        variance[k]=weighted.mean((Y[X==FREQ[k]]/E[X==FREQ[k]]- moyenne[k])^2,E[X==FREQ[k]])
        n[k] = sum(E[X==FREQ[k]])
        }
    w=barplot(n,names.arg=FREQ,col="light green",axes=FALSE, xlim=c(0,1.2*length(FREQ)+.5))
    mid=w[,1]
    axis(2)
    par(new=TRUE)
    IC1=moyenne+1.96/sqrt(n)*sqrt(variance)
    IC2=moyenne-1.96/sqrt(n)*sqrt(variance)
    moyenneglobale=sum(Y)/sum(E)
    
    if(type==1){
        plot(mid,moyenne,ylim=range(c(IC1,IC2)),type="b",
            col="red",axes=FALSE,xlab="",ylab="",
            xlim=c(0,1.2*length(FREQ)+.5))
        segments(mid,IC1,mid,IC2,col="red")
        segments(mid-.1,IC1,mid+.1,IC1,col="red")
        segments(mid-.1,IC2,mid+.1,IC2,col="red")
        points(mid,moyenne,pch=19,col="red")
        axis(4)
        abline(h=moyenneglobale,lty=2,col="red")}
    
    if(type==2){
        plot(mid,log(moyenne/moyenneglobale),ylim=
            range(c(log(IC1/moyenneglobale),log(IC2/moyenneglobale))),
            type="b",col="red",axes=FALSE,xlab="",ylab="",
            xlim=c(0,1.2*length(FREQ)+.5))
        segments(mid,log(IC1/moyenneglobale),mid, log(IC2/moyenneglobale),col="blue")
        segments(mid-.1,log(IC1/moyenneglobale),mid+.1, log(IC1/moyenneglobale),col="blue")
        segments(mid-.1,log(IC2/moyenneglobale),mid+.1, log(IC2/moyenneglobale),col="blue")
        points(mid,log(moyenne/moyenneglobale),pch=19,col="red")
        axis(4)
        abline(h=0,lty=2,col="red")}

    mtext("Exposition", 2, line=2, cex=1.2,col="light green")
    if(type==1){mtext("Fréquence annualisée", 4, line=-2, cex=1.2,col="red")}
    if(type==2){mtext("Fréquence annualisée (log multiplicateur)", 4, line=-2, cex=1.2,col="red")}
    }
top1 = read.csv("top1.csv")
methods <- c(
            "top1.csv", 
            "top2.csv",  
            "top3.csv",
            "top1a.csv", 
            "top1f.csv",
            "top1m.csv", 
            "mlts4.0.csv", 
            "mltw4.csv" 
            )
mnames <- c(
            "1Frame", 
            "2Frame",  
            "3Frame",
            "1Addr", 
            "1File",
            "1Mod", 
            "Lerch", 
            "LerchC" 
            )
data = NULL
data = lapply(setNames(methods, make.names(mnames)), 
         read.csv)
allcolors <- gray.colors(7, start=0.0, end=1.0)
colors <- rep(allcolors[1:3], each=3)
fcolors <- rep(allcolors[5:7], times=3)
linetype <- rep(c(1,2), each=10)
plotchar <- rep(c(22, 21, 24, 23, 25), 10)

shrink = 3
mex = shrink/1.255
linesx = 2.0

plota<-function(data, metric, y, l, ylim=c(0.2,1.0), lpos="bottomleft",
                oracle=NULL){
    par(mar=c(1.75,2.0,0.75,0)+0.0)
    plot(top1$n, top1$b3f, type='n', ylim=ylim, xlim=c(0,16000),
        ylab="", xlab="", axes=FALSE)
    axis(2, mgp=c(1.25, 0.25, 0), lwd=(1/shrink)) 
    axis(1, mgp=c(1.5, 0.5, 0), lwd=(1/shrink))
    title(ylab=y, line=1.0)
    title(xlab="Crashes Seen", line=1.25)
    lnames=mnames
    nmethods=length(data)
    for (i in 1:nmethods) {
        method <- data[[i]]
        lines(method[["n"]], method[[metric]], type='o', cex=linesx,
        lty=linetype[i], col=colors[i], pch=plotchar[i], bg=fcolors[i])
    }
    if (!is.null(oracle)) {
        i = nmethods+1
        method <- data[[1]]
        lnames=c(lnames, oracle)
        lines(method[["n"]], method[["obuckets"]], type='o', cex=linesx,
        lty=linetype[i], col=colors[i], pch=plotchar[i], bg=fcolors[i])
    }
    if (l) {
        legend(lpos, legend=lnames, col=colors, pch=plotchar, lty=linetype,
            title="Method", cex=mex*0.9, pt.cex=linesx, bty="n", ncol=3, pt.bg=fcolors,
            xjust=0)
    }
}


mypar <- function(mfrow) {
par(
    mfrow=mfrow,
    cex=(1/shrink),
    cex.axis=mex,
    cex.lab=mex,
    cex.main=mex,
    cex.sub=mex,
    mex=mex,
    lwd=(1/shrink),
    oma=c(0,0,0,0),
    xpd=NA,
    tcl=0.5,
    xaxs="i",
    yaxs="i",
    bty="n"
    )
}
page_width=7.15
width=page_width
height=(page_width/3)
svg(filename="b3.svg", width=page_width, height=height, 
    family="Latin Modern Roman", pointsize=10)
mypar(c(1,3))
plota(data, "b3p", "BCubed Precision", l=TRUE)
plota(data, "b3r", "BCubed Recall", l=FALSE)
plota(data, "b3f", "BCubed F1-Score", l=FALSE)
dev.off()
svg(filename="pur.svg", width=page_width, height=(width/3), 
    family="Latin Modern Roman", pointsize=10)
mypar(c(1,3))
plota(data, "purity", "Purity", l=TRUE)
plota(data, "invpur", "Inverse Purity", l=FALSE)
plota(data, "purf", "Purity F1-Score", l=FALSE)
dev.off()

col_width=3.5
width=col_width
svg(filename="nbuckets.svg", width=col_width, height=height, 
    family="Latin Modern Roman", pointsize=10)
mypar(c(1,1))
plota(data, "buckets", "Total Number of Buckets Created", l=TRUE, ylim=c(0,14400), 
    lpos="topleft", oracle="Oracle")
dev.off()

vals <- c("2.0", "3.0", "3.5",
          "4.0", "4.5",
          "5.0", "6.0", "8.0", "10.0")

methods <- lapply(vals, function(i){paste0("mlts",i,".csv")})
mnames <- lapply(vals, function(i){paste0("T=",i)})
data = NULL
data = lapply(setNames(methods, make.names(mnames)), 
         read.csv)
            
svg(filename="b3t.svg", width=page_width, height=height, 
    family="Latin Modern Roman", pointsize=10)
mypar(c(1,3))
plota(data, "b3p", "BCubed Precision", l=FALSE)
plota(data, "b3r", "BCubed Recall", l=TRUE, lpos="topleft")
plota(data, "b3f", "BCubed F1-Score", l=FALSE)
dev.off()
svg(filename="purt.svg", width=page_width, height=height, 
    family="Latin Modern Roman", pointsize=10)
mypar(c(1,3))
plota(data, "purity", "Purity", l=FALSE)
plota(data, "invpur", "Inverse Purity", l=TRUE, lpos="topleft")
plota(data, "purf", "Purity F1-Score", l=FALSE)
dev.off()
svg(filename="nbucketst.svg", width=col_width, height=height, 
    family="Latin Modern Roman", pointsize=10)
mypar(c(1,1))
plota(data, "buckets", "Total Number of Buckets Created", l=TRUE, ylim=c(0,14400), 
    lpos="topleft", oracle="Oracle")
dev.off()


vals <- c("1.0", "2.0", "2.25", "2.5", "2.75", "3.0", "3.25", "3.5", "3.75",
          "4.0", "4.5", "5.0", "5.5", "6.0", "7.0", "8.0", "10.0")

methods <- lapply(vals, function(i){paste0("mlts",i,".csv")})
mnames <- lapply(vals, function(i){paste0("T=",i)})
data = NULL
data = lapply(setNames(methods, make.names(mnames)), 
         read.csv)

p = lapply(1:length(data), function(ti){tail(data[[ti]][["b3p"]],n=1)})
r = lapply(1:length(data), function(ti){tail(data[[ti]][["b3r"]],n=1)})
f = lapply(1:length(data), function(ti){tail(data[[ti]][["b3f"]],n=1)})
t = lapply(1:length(data), function(ti){paste0(" ", mnames[ti], " F=.",
                                               sprintf("%02i ", round(100*f[[ti]])))
                                        })
svg(filename="prc.svg", width=col_width, height=col_width*0.99, 
    family="Latin Modern Roman", pointsize=10)
mypar(c(1,1))
par(mar=c(1.75,2.0,0.75,0)+0.0)
plot(p, r, xlim=c(0,1.01), ylim=c(0,1), asp=1,
        ylab="", xlab="", axes=FALSE)
axis(2, mgp=c(1.5, 0.5, 0), lwd=(1/shrink), pos=0) 
axis(1, mgp=c(1.5, 0.5, 0), lwd=(1/shrink), pos=0)
px = c(0, p, tail(p,n=1), 0)
rx = c(head(r,n=1),r, 0, 0)
polygon(px, rx, border=NA, col="#0000003f")
text(p[1:1], r[1:1], labels=t[1:1], adj=c(0,0.5), cex=mex, srt=30)
text(p[-(1:1)], r[-(1:1)], labels=t[-(1:1)], adj=c(1,0.5), cex=mex, srt=30)
title(ylab="Recall", line=1.0)
title(xlab="Precision", line=1.25)
dev.off()
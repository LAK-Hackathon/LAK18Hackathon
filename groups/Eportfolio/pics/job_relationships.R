# End of day 1 idea's
# Bigram on job titles and then removing sparscity

library("tm")

texts<-sample$JobTitle
texts<-iconv(texts, 'utf-8', 'ascii', sub=' ')
docs <- VCorpus(VectorSource(texts))

# &nbsp; to space
removeB <- function(x) gsub("&nbsp;", " ", x)
docs <-tm_map(docs, content_transformer(removeB))


# URL remover
removeURL <- content_transformer(function(x) gsub("(f|ht)tp(s?)://\\S+", "", x, perl=T))
docs <- tm_map(docs,removeURL)
writeLines(as.character(docs[[1]]))

# Convert a couple of characters to space
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs,toSpace, "@")
docs <- tm_map(docs,toSpace, "/")


# Dd some more conversions
docs <- tm_map(docs,content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)

BigramTokenizer <-function(x) unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = TRUE)
bdtm <- DocumentTermMatrix(docs, control = list(tokenize = BigramTokenizer, weighting = weightTf))
freqr <- colSums(as.matrix(bdtm))
ordr <- order(freqr,decreasing=TRUE)
freqr[head(ordr,n=30)]
tassoc<-findAssocs(bdtm,"sales executive",0.1)
tassoc


library(qdap)
library(qdapTools)
library(ggplot2)
library(ggthemes)

temp<-freqr[head(ordr,n=30)]
mydir<-"/Users/alan/Desktop/Hackathon/LAK18Hackathon/groups/Eportfolio/pics"
count<-0
for (i in names(temp)){
  count<-count+1
  cat(i,"\n")
  
  name<-paste(mydir,"/",i,"_rank_",count,".png",sep="")
  png(name)
  tassoc<-findAssocs(bdtm,i,0.1)
  assoc_df<-list_vect2df(tassoc)[, 2:3]
  
  print(ggplot(assoc_df, aes(y = assoc_df[, 1])) + geom_point(aes(x = assoc_df[, 2]), 
                                                        data = assoc_df, size = 3)  + 
    labs(x = "Degree of Association", y= "Word") + theme_economist_white() + ggtitle(paste(i,"\nRank is ",count,sep=""))
  )
  dev.off()
}


# Getting started Code and basic instructions
# Hackathon: Eportfolio
# 
# Alan Mark Berg
# Version 0.1
# a.m.berg AT uva.nl
#
# PART [2]

# Bag of words
# Motivation. Try the simplist possible solution first.
# Possible solution solution for bootstrapping a crowd sourced recommendation system 
# for authentic tasks in eportfolio's

# Load all the data
load(url("https://github.com/LAK-Hackathon/LAK18Hackathon/blob/master/groups/Eportfolio/Data/sample.Rdata?raw=True"))

# Get x samples 
x<-10
rows<- sample(1:20000, x, replace=T)
texts<-sample$JobBody[rows]
texts<-iconv(texts, 'utf-8', 'ascii', sub=' ')
texts[1]


# We took a random sample of x texts. We could sample based on triggers such as:
# Top Salary
# Job title
# Education level
# Location
# ETC
# Exercise 3 (if I have time to write)

# Look at Bag of words via the tm package
library("tm")
citation("tm")
?VCorpus
#A volatile corpus is fully kept in memory and thus all changes only affect the corresponding R object
docs <- VCorpus(VectorSource(texts))
rm(texts)

# Look at the help
?getTransformations
# Discover the text transformations
getTransformations()

# There is always lots of cleaning up. This is not perfect
# Add reglex expressions later
# Find ways of removing HTML, XML etc.
# Good enough for a tutorial
#

# First Job Description
writeLines(as.character(docs[[1]]))
?gsub
# http://www.jdatalab.com/data_science_and_data_mining/2017/03/20/regular-expression-R.html

# &nbsp; to space
removeB <- function(x) gsub("&nbsp;", " ", x)
docs <-tm_map(docs, content_transformer(removeB))
writeLines(as.character(docs[[1]]))

# URL remover
removeURL <- content_transformer(function(x) gsub("(f|ht)tp(s?)://\\S+", "", x, perl=T))
docs <- tm_map(docs,removeURL)
writeLines(as.character(docs[[1]]))

# Convert a couple of characters to space
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs,toSpace, "@")
docs <- tm_map(docs,toSpace, "/")
writeLines(as.character(docs[[1]]))

# Dd some more conversions
docs <- tm_map(docs,content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
writeLines(as.character(docs[[1]]))

# We could stem. Best for statistical explorations
# https://en.wikipedia.org/wiki/Stemming
#
#install.packages("SnowballC")
#library("SnowballC")
#docs <- tm_map(docs,stemDocument)
#writeLines(as.character(docs[[1]]))

# Document Term Matrix
# https://en.wikipedia.org/wiki/Document-term_matrix
dtm <-DocumentTermMatrix(docs, control=list(wordLengths=c(4, 20), bounds = list(global = c(2,100))))
dtm

## Removing stop words we missed
# @TODO Can always  code into a function
freqr <- colSums(as.matrix(dtm))
ordr <- order(freqr,decreasing=TRUE)
freqr[head(ordr,n=20)]
# Aha we spot some new stop words
docs<-tm_map(docs, removeWords, c("will","within"))
dtm <-DocumentTermMatrix(docs, control=list(wordLengths=c(4, 20), bounds = list(global = c(2,100))))
freqr <- colSums(as.matrix(dtm))
ordr <- order(freqr,decreasing=TRUE)
freqr[head(ordr,n=20)]
barplot(freqr[head(ordr,n=20)], col = "blue", las = 2, main="Frequently used words")

# Now what which unigrams are associated with the word manager for our sample set
assoc<-findAssocs(dtm,"manager",0.3)
assoc


# Or td-idf weighting
# https://en.wikipedia.org/wiki/Tf???idf
# https://www.rdocumentation.org/packages/tm/versions/0.7-3/topics/TermDocumentMatrix
?weightTfIdf
tddtm <-DocumentTermMatrix(docs, control=list(wordLengths=c(4, 20), weighting = weightTfIdf))
tddtm
wfreqr <- colSums(as.matrix(tddtm))
wordr <- order(wfreqr,decreasing=TRUE)
wfreqr[head(wordr,n=20)]
tassoc<-findAssocs(tddtm,"manager",0.3)
tassoc


# OK lets Graphically print the associations
#install.packages("qdap")
#install.packages("qdapTools")
library(qdap)
library(qdapTools)
library(ggplot2)
library(ggthemes)

assoc_df<-list_vect2df(assoc)[, 2:3]

ggplot(assoc_df, aes(y = assoc_df[, 1])) + geom_point(aes(x = assoc_df[, 2]), 
             data = assoc_df, size = 3) + ggtitle("Associated with 'Manager'") + 
  labs(x = "Degree of Association", y= "Word") + theme_economist_white() 


# We can process for Bigrams
BigramTokenizer <-function(x) unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
bdtm <- DocumentTermMatrix(docs, control = list(tokenize = BigramTokenizer))
freqr <- colSums(as.matrix(bdtm))
ordr <- order(freqr,decreasing=TRUE)
freqr[head(ordr,n=20)]

# Or trigrams
TriTokenizer <-function(x) unlist(lapply(ngrams(words(x), 3), paste, collapse = " "), use.names = FALSE)
tdtm <- DocumentTermMatrix(docs, control = list(tokenize = TriTokenizer))
freqr <- colSums(as.matrix(tdtm))
ordr <- order(freqr,decreasing=TRUE)
freqr[head(ordr,n=20)]

# https://www.rdocumentation.org/packages/tm/versions/0.7-3/topics/TermDocumentMatrix
# https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation


#install.packages("topicmodels")
library("topicmodels")

# Removing Spase terms
dtm
inspect(removeSparseTerms(dtm, 0.5))

#
#install.packages("RWeka")
library(RWeka)
length <- 2 # how many words either side of word of interest
length1 <- 1 + length * 2
ngramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min =length, max = length1 ))
dtm_co <- TermDocumentMatrix(docs, control = list(tokenize = ngramTokenizer))
inspect(dtm_co)


# Topic modeling
?LDA
lda_5 <- LDA(dtm,5)
get_terms(lda_5, 10)

lda_5s <- LDA(removeSparseTerms(dtm, 0.5),5)
get_terms(lda_5s, 10)


blda_5 <- LDA(bdtm,5)
get_terms(blda_5, 10)

tlda_5 <- LDA(tdtm,5)
get_terms(tlda_5, 10)




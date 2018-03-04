# Named Entity Extraction for enrichment.
# Based on 
# https://rpubs.com/lmullen/nlp-chapter
#
# Alan Mark Berg
# Please note that entity extraction is costly.

# Load libraries
library(NLP)
library(openNLP)
library(magrittr)


# Load data if you have not done so
#load(url("https://github.com/LAK-Hackathon/LAK18Hackathon/blob/master/groups/Eportfolio/Data/sample.Rdata?raw=True"))

total_jobs<-100
rows<- sample(1:20000, total_jobs, replace=T)
job<-paste(sample$JobBody[rows], collapse = ' ')
job<-iconv(job, 'utf-8', 'ascii', sub=' ')
job<-as.String(job)

# Put your cleanup function here

word_ann <- Maxent_Word_Token_Annotator()
sent_ann <- Maxent_Sent_Token_Annotator()

job_annotations <- annotate(job, list(sent_ann, word_ann))
head(job_annotations)
job_doc <- AnnotatedPlainTextDocument(job, job_annotations)
sents(job_doc) %>% head()


# Install the model for en (72 MB)
install.packages("openNLPmodels.en",
                 repos = "http://datacube.wu.ac.at/",
                 type = "source")

?Maxent_Entity_Annotator
person_ann <- Maxent_Entity_Annotator(kind = "person")
location_ann <- Maxent_Entity_Annotator(kind = "location")
organization_ann <- Maxent_Entity_Annotator(kind = "organization")

pipeline <- list(sent_ann,
                 word_ann,
                 person_ann,
                 location_ann,
                 organization_ann)
job_annotations <- annotate(job, pipeline)
job_doc <- AnnotatedPlainTextDocument(job, job_annotations)

entities <- function(doc, kind) {
  s <- doc$content
  a <- annotations(doc)[[1]]
  if(hasArg(kind)) {
    k <- sapply(a$features, `[[`, "kind")
    s[a[k == kind]]
  } else {
    s[a[a$type == "entity"]]
  }
}

entities(job_doc, kind = "person")
entities(job_doc, kind = "location")
entities(job_doc, kind = "organization")


# 
# Consider user based collaborative filtering
# https://github.com/mhahsler/recommenderlab
# http://www.salemmarafi.com/code/collaborative-filtering-r/

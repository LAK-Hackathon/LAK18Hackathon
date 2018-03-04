# Getting started Code and basic instructions
# Hackathon: Eportfolio
# 
# Alan Mark Berg
# Version 0.1
# a.m.berg AT uva.nl
#
# PART [1]

#
# A good introduction 
# Master text-taming techniques and build effective text-processing applications with R
# ISBN 978-1-78355-181-1
# 

# Install Rstudio:  https://www.rstudio.com/products/rstudio/download/
# If necessary R:  www.r-project.org (download link)

# Load data from Github
load(url("https://github.com/LAK-Hackathon/LAK18Hackathon/blob/master/groups/Eportfolio/Data/sample.Rdata?raw=True"))

#Consider saving locally
#save(sample,file="sample.Rdata")
#load("sample.Rdata")

# View data
str(sample)

#OK we need to change some default types, for example SalaryTo is a real number
sample$SalaryFrom<-as.numeric(sample$SalaryFrom)
sample$SalaryTo<-as.numeric(sample$SalaryTo)

# Example of how to experiment with conversion
test<-sample$DateActive
test<-as.Date(test)
test[1]
rm(test)
# We can probably do better by playing with f <- "%Y-%m-%d",
# However, good enough for now

sample$DateActive<-as.Date(sample$DateActive)
sample$DateExpires<-as.Date(sample$DateExpires)

# Let's look at a random job description
# Search for an authentic task
# Oh dear I overloaded the name sample. Don't be confused sample is a function
?sample # Call help on the sample function
??sample # Search on the Internet

row<- sample(1:20000, 1, replace=T)
job<-sample$JobBody[row]

# UTF8 remover - Not perfect
job<-iconv(job, 'utf-8', 'ascii', sub=' ')
paste("Row is [",row,"]",job)


# Let's look at the sentence level
# You never know we might want to train a model
library(tm)
library(openNLP)
job<-as.String(job)
sentence.boundaries <- annotate(job,Maxent_Sent_Token_Annotator(language = "en", probs = FALSE, model = NULL))
job[sentence.boundaries]

#http://www.butte.edu/departments/cas/tipsheets/grammar/parts_of_speech.html




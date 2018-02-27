# Getting started Code and basic instructions
# Hackathon: Eportfolio
# 
# Alan Mark Berg
# Version 0.1
# a.m.berg AT uva.nl
#
# PART [1]


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

# Example of how to experiment with conversio
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
paste("Row is [",row,"]",sample$JobBody[row])

# Cut and paste into a Google doc and review for authentic tasks



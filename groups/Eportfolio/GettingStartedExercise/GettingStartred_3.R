# A start of point to try Parts of Speach
# Initial motivations
# https://bnosac.github.io/udpipe/docs/doc5.html
# http://aclweb.org/anthology/K17-3009
#
# Deliberately keepimg to the tutorial as this makes it easier to adpat later.
# By applying the basic examples we are already starting to see how lecturers can use
# graphical feedback to feed their understanding of authentic tasks.
# However, it would be nice to automatically select sentences or fragments for authentic tasks.
#
# Alan Mark Berg 
# Version 0.1

# Uf you do not already have the sample data
# load(url("https://github.com/LAK-Hackathon/LAK18Hackathon/blob/master/groups/Eportfolio/Data/sample.Rdata?raw=True"))

install.packages("udpipe")
#vignette("udpipe-tryitout", package = "udpipe")
vignette("udpipe-annotation", package = "udpipe")
#vignette("udpipe-train", package = "udpipe")
#vignette("udpipe-usecase-postagging-lemmatisation", package = "udpipe")

library(udpipe)
# Consider saving the objects generated lovally in Rdata format via save(object1, objectn, filelocation)
dl <- udpipe_download_model(language = "english")
str(dl)
dl$file_model
udmodel <- udpipe_load_model(file = dl$file_model)


# Choose jobs at random
# In reality you can sample by a combination of
# Education level, job title, location, change in words over time, etc.
total_jobs<-100
rows<- sample(1:20000, total_jobs, replace=T)
job<-paste(sample$JobBody[rows], collapse = '')
job

x <- udpipe_annotate(udmodel, x = job)
x <- as.data.frame(x)
str(x)
# http://universaldependencies.org/u/pos/index.html
table(x$upos)

require(lattice)

# Keyword extraction
## Using RAKE
stats <- keywords_rake(x = x, term = "lemma", group = "doc_id", 
                       relevant = x$upos %in% c("NOUN", "ADJ"))
stats$key <- factor(stats$keyword, levels = rev(stats$keyword))
barchart(key ~ rake, data = head(subset(stats, freq > 1), 20), col = "cadetblue", 
         main = "Keywords identified by RAKE", 
         xlab = "Rake")

# Collocation
x$word <- tolower(x$token)
stats <- keywords_collocation(x = x, term = "word", group = "doc_id")
stats$key <- factor(stats$keyword, levels = rev(stats$keyword))
barchart(key ~ pmi, data = head(subset(stats, freq > 1), 20), col = "cadetblue", 
         main = "Keywords identified by PMI Collocation", 
         xlab = "PMI (Pointwise Mutual Information)")

## Using a sequence of POS tags (noun phrases / verb phrases)
x$phrase_tag <- as_phrasemachine(x$upos, type = "upos")
stats <- keywords_phrases(x = x$phrase_tag, term = tolower(x$token), 
                          pattern = "(A|N)*N(P+D*(A|N)*N)*", 
                          is_regex = TRUE, detailed = FALSE)
stats <- subset(stats, ngram > 1 & freq > 1)
stats$key <- factor(stats$keyword, levels = rev(stats$keyword))
barchart(key ~ freq, data = head(stats, 20), col = "cadetblue", 
         main = "Keywords - simple noun phrases", xlab = "Frequency")


# cooccurrence
#
cooc <- cooccurrence(x = subset(x, upos %in% c("NOUN", "ADJ")), 
                     term = "lemma", 
                     group = c("doc_id", "paragraph_id", "sentence_id"))
head(cooc)
#install.packages("ggraph")
library(igraph)
library(ggraph)
library(ggplot2)
wordnetwork <- head(cooc, 30)
wordnetwork <- graph_from_data_frame(wordnetwork)
ggraph(wordnetwork, layout = "fr") +
  geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "pink") +
  geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
  theme_graph(base_family = "Arial Narrow") +
  theme(legend.position = "none") +
  labs(title = "Cooccurrences within sentence", subtitle = "Nouns & Adjective")


cooc <- cooccurrence(x$lemma, relevant = x$upos %in% c("NOUN", "ADJ"), skipgram = 1)
head(cooc)

wordnetwork <- head(cooc, 15)
wordnetwork <- graph_from_data_frame(wordnetwork)
ggraph(wordnetwork, layout = "fr") +
  geom_edge_link(aes(width = cooc, edge_alpha = cooc)) +
  geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
  theme_graph(base_family = "Arial Narrow") +
  labs(title = "Words following one another", subtitle = "Nouns & Adjective")


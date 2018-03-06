# Some Examples of Classifier Transparency
These utilise data from the [UCI Student Performance Dataset](https://archive.ics.uci.edu/ml/datasets/student+performance), from which two binary classification datasets were created for the student gaining >= 10 marks in the first and final term (two CSV files, Student\_Prepared\_FirstTerm.csv and Student\_Prepared\_FinalTerm.csv).

__NB:__ to use these examples you will need to run a jupyter notebook server, which can be done locally, and install various packages. Sorry, I've not time to document dependencies here, except to note that you will need recent versions of nbconvert and ipywidgets.

The PDF files in [Classifier Transparency] are static downloads.

[Feature Importances Student Classifier](Feature%20Importances%20Student%20Classifier.ipynb) - a simple notebook to illustrate for the dataset in question the "feature importances" which figure in the ATML/PMML aspect of the group's output.

[Decision Tree Structure Student](Decision%20Tree%20Structure%20Student.ipynb) - choose one of three personas to see which of their attributes determine the relative likelihood of scoring 10 or more in the first or final term for either Portuguese or Maths. A classifier score of 0.5 or more indicates the student is expected to score 10 or more.

[Student Experiential Levers](Student%20Experiential%20Levers.ipynb) - has the same setup as Decision Tree Structure Student but provides some widgets for all the attributes with non-zero feature importance to allow the user to experiment with seeing how different attribute combinations (variations on the initial persona) would influence the classifier score.
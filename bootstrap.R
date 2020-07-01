packagerepos = getOption("repos")
packagerepos["CRAN"] = "https://cloud.r-project.org/"
options(repos = packagerepos)
if (!require("pacman"))
    install.packages("pacman")
library("pacman")
p_load("bookdown")

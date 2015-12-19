## ---- results='asis', echo=FALSE-----------------------------------------
cat(gsub("\\n   ", "", packageDescription("modules", fields = "Description")))

## ---- eval=FALSE---------------------------------------------------------
#  devtools::install_github("wahani/modules")

## ------------------------------------------------------------------------
library(modules)
m <- module({
  boringFunction <- function() cat("boring output")
})

m$boringFunction()

## ----error=TRUE----------------------------------------------------------
hey <- "hey"
m <- module({
  isolatedFunction <- function() hey
})
m$isolatedFunction()

## ------------------------------------------------------------------------
m <- module({
  functionWithDep <- function(x) stats::median(x)
})
m$functionWithDep(1:10)

## ------------------------------------------------------------------------
m <- module({
 
  import(stats, median) # make median from package stats available
  
  functionWithDep <- function(x) median(x)

})
m$functionWithDep(1:10)

## ------------------------------------------------------------------------
m <- module({
  
  import(stats)
  
  functionWithDep <- function(x) median(x)

})
m$functionWithDep(1:10)

## ------------------------------------------------------------------------
m <- module({
  
  export("fun")
  
  .privateFunction <- identity
  privateFunction <- identity
  fun <- identity
  
})

names(m)

## ----error=TRUE----------------------------------------------------------
library(parallel)
dependency <- identity
fun <- function(x) dependency(x) 

cl <- makeCluster(2)
clusterMap(cl, fun, 1:2)
stopCluster(cl)

## ------------------------------------------------------------------------
m <- module({
  dependency <- identity
  fun <- function(x) dependency(x) 
})

cl <- makeCluster(2)
clusterMap(cl, m$fun, 1:2)
stopCluster(cl)

## ------------------------------------------------------------------------
code <- "
import(methods)
import(aoos)
# This is an example:
list : generic(x) %g% standardGeneric('generic')
generic(x ~ ANY) %m% as.list(x)
"

fileName <- tempfile()
writeLines(code, fileName)

## ------------------------------------------------------------------------
someModule <- use(fileName, attach = TRUE)
search()
generic(1:2)

## ------------------------------------------------------------------------
m <- module({
  import("methods")
  import("aoos")
  gen(x) %g% cat("default method")
  gen(x ~ numeric) %m% cat("method for x ~ numerc")
})
m$gen("Hej")
m$gen(1)

## ------------------------------------------------------------------------
m <- module({
  import("methods")
  import("aoos")
  gen(x) %g% cat("default method")
  gen(x ~ numeric) %m% cat("method for x ~ numerc")
  NewType <- function(x) retList("NewType")
  setOldClass("NewType", where = environment())
  gen(x ~ NewType) %m% x
})

cl <- makeCluster(1)
clusterMap(cl, m$gen, list(m$NewType(NULL)))
stopCluster(cl)


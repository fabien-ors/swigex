suppressWarnings(suppressMessages(library(swigex)))

pa = ParentBase()
invisible(showHello(pa))

co = ChildOne()
invisible(showHello(co))

# TODO : Cannot inherits from ParentBase in R
#ct = ParentBase()
#class(ct) <- c("ChildTwo", "ParentBase")
#getHello.ChildTwo <- function(obj)
#{
#  return("ChildTwo - Hello")
#}
#
#showHello(ct)

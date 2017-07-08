

# Aspect ratios
figasp12 <- 0.5
figasp34 <- 0.75
figasp11 <- 1
figasp43 <- 1.33
figasp21 <- 2

# vectors of asp
asp <- c(figasp12, figasp34,figasp11, figasp43, figasp21)
nasp <- c(12, 34, 11, 43, 21)
vasp <- c("figasp12", "figasp34","figasp11", "figasp43", "figasp21")

# widths
doclinewidth <- (21 - 1.5 - 1.5) * 0.3937 # == doc line width in inches
fullwidth <-  doclinewidth
two3width <- 2 / 3 * doclinewidth
halfwidth  <-  1 / 2 * doclinewidth
one3width <- 1 / 3 * doclinewidth
one4width <- 1 / 4 * doclinewidth

# width vectors
w <- c(one4width, one3width, halfwidth, two3width, fullwidth)
nw <- c(14, 13, 12, 23, 11)
vw <- c("one4width", "one3width", "halfwidth", "two3width", "fullwidth" )

# pattern names
npat <- outer(nw, nasp, FUN = function(x,y) {paste0("fig.",x,".", y)} )


fmlaright <- function(widths, asps)
        outer(as.character(widths) , as.character(asps),
                   FUN = function(x, y) {
                           paste0(" = list(fig.width = ",
                                  x,
                                  ", fig.asp = ",
                                  y,
                                  ")")
                   }

)


fmla <- paste0(npat,
               fmlaright(w,asp)#, ",\n"
               )

fmlacomma <- paste(fmla, collapse = ", ")

rcode <- paste0("knitr::opts_template$set(", fmlacomma, ")" )

eval(parse(text = rcode))



# # mla <- matrix(fmla,5,5, byrow = TRUE)
# # mla
#
# j <-  5
# cat(mla[,j])

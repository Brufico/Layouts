
# copy of Hadley's common.R in

# défini dans le code d'appel
##### doclinewidth

# stockage des variables privées (BFC)

init_plot_hook_opts <- function() {
        fields <-  list("whatsthat" = "The list of values") #initialize
        set_f <- function(label, value) {
                newfields <- fields # make copy
                # message(str(newfields)) # debug
                newfields[[label]] <- value # modify copy
                fields <<- newfields # store in fields
        }
        get_f <- function(label) {
                if (!missing(label)) {
                        fields[[label]]
                } else {names(fields)}
        }
        list(set=set_f, get=get_f)
}


plot_hook_opts <- init_plot_hook_opts()

plot_hook_opts$set("doclinewidth", doclinewidth)






library(ggplot2)
# library(dplyr)
# library(tidyr)
options(digits = 3, dplyr.print_min = 6, dplyr.print_max = 6) # R options

# suppress startup message # (??? mean ??? BFC)
#library(maps) # désactivé BFC

knitr::opts_chunk$set(
        # comment = "#>",
        comment = NA,
        collapse = TRUE, ##??
        # fig.path = paste0("_figures/", chapter, "/"),
        fig.show = "hold",
        dpi = 300,
        cache = TRUE
        #, cache.path = paste0("_cache/", chapter, "/")
)

is_latex <- function() {
        identical(knitr::opts_knit$get("rmarkdown.pandoc.to"), "latex") #undocumented option
}

columns <- function(n, aspect_ratio = 1, max_width = if (n == 1) 0.65 else 1) {
        if (is_latex()) {
                out_width <- paste0(round(max_width / n, 3), "\\linewidth")
                knitr::knit_hooks$set(plot = plot_hook_bookdown)
        } else {
                out_width <- paste0(round(max_width * 100 / n, 1), "%")
        }
        # changed: width = width of one plot. doclinewidth was assumed 6
        width <- plot_hook_opts$get("doclinewidth") / n * max_width
        plot_hook_opts$set("width", width)
        plot_hook_opts$set("ncritical", doclinewidth %/% width) # max number of plots in one line

        knitr::opts_chunk$set(
                fig.width = width,
                fig.height = width * aspect_ratio,
                fig.align = if (max_width < 1) "center" else "default",
                fig.show = if (n == 1) "asis" else "hold",
                fig.retina = NULL,
                out.width = out_width,
                out.extra = if (!is_latex())
                        paste0("style='max-width: ", round(width, 2), "in'")
        )
}

# Draw parts of plots -----------------------------------------------------

draw_legends <- function(...) {
        plots <- list(...)
        gtables <- lapply(plots, function(x) ggplot_gtable(ggplot_build(x)))
        guides <- lapply(gtables, gtable::gtable_filter, "guide-box")

        one <- Reduce(function(x, y) cbind(x, y, size = "first"), guides)

        grid::grid.newpage()
        grid::grid.draw(one)
}


# Customised plot layout --------------------------------------------------
#
# Added figures counter
plot_hook_opts$set("row_figdone", 0)# = nombre de figures déjà imprimées sur la même ligne

plot_hook_bookdown <- function(x, options) {
        message("plot_hook_bookdown")
        Sys.sleep(1)
        paste0(
                begin_figure(x, options),
                include_graphics(x, options),
                end_figure(x, options)
        )
        # message(hook_figdone) # nouveau (debug, mais ne fonctionne pas)
}


# print begin sequence
begin_figure_print<- function(x, options) {
        paste0(
                "\\begin{figure}[H]\n",
                if (options$fig.align == "center") "  \\centering\n"
        )
}


begin_figure <- function(x, options) {
        message("begin_figure")
        message(x)
        message(options)
        Sys.sleep(3)
        if (!knitr_first_plot(options))
        {options$done <- 0 # nombre total de plots traités ??
         plot_hook_opts$set("row_figdone", 0) # nombre de figures déjà imprimées sur la même ligne
         return("")
        }
        begin_figure_print(x, options) # print begin sequence
}


end_figure_print <- function(x, options) { # print end sequence
        "\\end{figure}\n"
}

end_figure <- function(x, options) {
        message("end_figure")
        message(x)
        message(options)
        Sys.sleep(3)
        if (!knitr_last_plot(options))
                return("")

        paste0(
                if (!is.null(options$fig.cap)) {
                        paste0(
                                '  \\caption{', options$fig.cap, '}\n',
                                '  \\label{fig:', options$label, '}\n'
                        )
                },
                end_figure_print(x, options)
        )
}


include_graphics <- function(x, options) {
        # added
        plot_hook_opts$set("row_figdone", plot_hook_opts$get("row_figdone") + 1)
        if (plot_hook_opts$get("row_figdone") > plot_hook_opts$get("ncritical")) { # si largeur dépassée
                end_figure_print(x, options)
                begin_figure_print(x, options)
                plot_hook_opts$set("row_figdone",1)
        }

        opts <- c(
                sprintf('width=%s', options$out.width),
                sprintf('height=%s', options$out.height),
                options$out.extra
        )
        if (length(opts) > 0) {
                opts_str <- paste0("[", paste(opts, collapse = ", "), "]")
        } else {
                opts_str <- ""
        }

        paste0("  \\includegraphics",
               opts_str,
               "{", knitr:::sans_ext(x), "}",
               if (options$fig.cur != options$fig.num) "%",
               "\n"
        )
}

knitr_first_plot <- function(options) {
        message("knitr_first_plot")
        Sys.sleep(1)
        options$fig.show != "hold" || options$fig.cur == 1L
}
knitr_last_plot <- function(x) { # modif ? x ==> options ? #function(x)
        message("knitr_last_plot")
        message(x)
        message(options)
        Sys.sleep(3)
        options$fig.show != "hold" || options$fig.cur == x$fig.num
}


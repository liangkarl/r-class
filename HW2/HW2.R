#!/usr/bin/env Rscript

draw_hist = function(color) {
        hist(y, col = color)
}

draw_plot = function(color) {
        top = "Scatter plot"
        plot(data, col = color)
        title(main = top)
}

draw_box = function(color) {
        top = "Boxplot"
        boxplot(data, col = color, ylab = "Values")
        title(main = top)
}

draw_scatter = function(color) {
        top = "Scatter plot and regression"
        mod = lm(y ~ x1)
        plot(y ~ x1, col = color)
        title(main = top)
        abline(mod, col = color - 5)
}

# .csv file is here
pos = "./Week1.csv"
now = getwd()

data = read.csv(file=pos)
data = data[,2:4]
attach(data)
names(data)

dir.create("hist")
setwd("hist")
png(file="example%02d.png")
for (i in 1:12) {
        draw_hist(i)
}
dev.off()
system("convert -delay 80 *.png hist.gif")
file.remove(list.files(pattern=".png"))

setwd("..")
dir.create("plot")
setwd("plot")
png(file="example%02d.png")
for (i in 6:17) {
        draw_plot(i)
}
dev.off()
system("convert -delay 80 *.png plot.gif")
file.remove(list.files(pattern=".png"))

setwd("..")
dir.create("box")
setwd("box")
png(file="example%02d.png")
for (i in 12:23) {
        draw_box(i)
}
dev.off()
system("convert -delay 80 *.png box.gif")
file.remove(list.files(pattern=".png"))

setwd("..")
dir.create("scatter")
setwd("scatter")
png(file="example%02d.png")
for (i in 9:20) {
        draw_scatter(i)
}
dev.off()
system("convert -delay 80 *.png scatter.gif")
file.remove(list.files(pattern=".png"))
setwd("..")

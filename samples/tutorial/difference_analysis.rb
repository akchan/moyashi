# A sample analysis script
#
# This script shows intensity differences on each m/z
# with p value of Welch's t-test.
# 
# Requirements:
# 
#   * This script needs R programming language. If you don't have it, install it
#     first from https://www.r-project.org .
#
#


class IntensityDifferenceAnalysis < Moyashi::Analysis::Base
  define_name 'Intensity defference analysis'


  define_description <<-EOF
Evaluation of the intensity difference between given two groups.
Wilcoxon's rank sum test is used for statistical analysis.

This analysis requires R programming language. If you don't have it, 
install it first from web site (https://www.r-project.org).

Specity two csv files exported with default exporter.

The pdf of result will be write to HOME directory.
EOF


  define_params do |p|
    p.file :group1, presence: true
    p.file :group2, presence: true
  end


  define_analysis do |params|
    file1 = params.group1.tempfile.path
    file2 = params.group2.tempfile.path

    r_script = <<EOF
#/usr/bin/env R --vanilla

args  = commandArgs(trailingOnly=T)

csv_a = read.csv(args[1], skip=1, check.names=F)
csv_b = read.csv(args[2], skip=1, check.names=F)


func = function(x) {
  a = csv_a[,x+1]
  b = csv_b[,x+1]

  w = wilcox.test(a, b)

  return(w$"p.value")
}


l = ncol(csv_a) - 1

x      = names(csv_a)[2:(l+1)]
result = sapply(1:l, func)

pdf("#{Dir.home}/#{Time.now.strftime("%Y%m%d%H%M%S.pdf")}", width=8, height=5)

plot(x, result, type="l", log="y", xlab="m/z", yaxt="n", ylab="p value")
aty    = axTicks(2)
labels = sapply(aty, function(x) {as.expression(bquote(10^.(round(log10(x)))))})
axis(2, at=append(aty, 0.05), labels=append(labels, 0.05))


par(new=T)
abline(h=0.05, lty=3)

dev.off()
EOF

    result = system("R --vanilla --args #{file1} #{file2} <<EOF\n#{r_script}")


    if result
      "Analysis was invoked."
    else
      "An error occured. Check the log for more details."
    end
  end
end






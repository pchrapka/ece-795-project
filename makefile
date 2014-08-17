DEP += output
output:
	@mkdir output

pdf: $(DEP)
	# Using latexmk to compile the pdf, pretty neat
	latexmk -output-directory=./output -pdf project.tex
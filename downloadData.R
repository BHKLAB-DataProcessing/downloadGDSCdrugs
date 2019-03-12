library(PharmacoGxPrivate)
library(RCurl)
options(stringsAsFactors=FALSE)


downloadGDSCdrugs <- function(path.data="/pfs/out",  path.drug = path.data){
	if(!file.exists(path.drug)){
		dir.create(path.drug)
	}
	## download drug sensitivity
	message("Download drug sensitivity measurements")
	myfn <- file.path(path.drug, "gdsc_drug_sensitivity.csv")
	if (!file.exists(myfn)) {
		dir.create(file.path(path.drug, "dwl"), showWarnings=FALSE, recursive=TRUE)
		dwl.status <- download.file(url="ftp://ftp.sanger.ac.uk/pub/project/cancerrxgene/releases/release-5.0/gdsc_manova_input_w5.csv", destfile=file.path(path.drug, "dwl", "gdsc_manova_input_w5.csv"), quiet=TRUE)
		if(dwl.status != 0) { stop("Download failed, please rerun the pipeline!") }
		file.copy(from=file.path(path.drug, "dwl", "gdsc_manova_input_w5.csv"), to=myfn)
	}

	## download drug concentration
	message("Download screening drug concentrations")
	myfn <- file.path(path.drug, "gdsc_drug_concentration.csv")
	if (!file.exists(myfn)) {
		dir.create(file.path(path.drug, "dwl"), showWarnings=FALSE, recursive=TRUE)
		dwl.status <- download.file(url="ftp://ftp.sanger.ac.uk/pub/project/cancerrxgene/releases/release-5.0/gdsc_compounds_conc_w5.csv", destfile=file.path(path.drug, "dwl", "gdsc_compounds_conc_w5.csv"), quiet=TRUE)
		if(dwl.status != 0) { stop("Download failed, please rerun the pipeline!") }
		file.copy(from=file.path(path.drug, "dwl", "gdsc_compounds_conc_w5.csv"), to=myfn)
	}
	
	## download drug information
	message("Download drug information")
	myfn <- file.path(path.drug, "gdsc_drug_information.csv")
	if (!file.exists(myfn)) {
		dir.create(file.path(path.drug, "dwl"), showWarnings=FALSE, recursive=TRUE)
	  # dwl.status <- download.file(url="http://www.cancerrxgene.org/action/ExportJsonTable/CSV", destfile=file.path(path.drug, "dwl", "export-Automatically_generated_table_data.csv"), quiet=TRUE)
	  # if(dwl.status != 0) { stop("Download failed, please rerun the pipeline!") }  
	  tables <- read.csv("https://www.cancerrxgene.org/translation/drug_list?list=all&export=csv")
	  # drugs <- tables[1][[1]]
	  write.csv(drugs, row.names=FALSE, file=file.path(path.drug, "dwl", "export.csv"))
	  file.copy(from=file.path(path.drug, "dwl", "export.csv"), to=myfn)
	}
	myfn <- file.path(path.drug, "nature_supplementary_information.xls")
	if (!file.exists(myfn)) {
		dir.create(file.path(path.drug, "dwl"), showWarnings=FALSE, recursive=TRUE)
		dwl.status <- download.file(url="http://www.nature.com/nature/journal/v483/n7391/extref/nature11005-s2.zip", destfile=file.path(path.drug, "dwl", "nature11005-s2.zip"), quiet=TRUE)
		ff <- as.character(unzip(zipfile=file.path(path.drug, "dwl", "nature11005-s2.zip"), list=TRUE)[1, 1])
		unzip(zipfile=file.path(path.drug, "dwl", "nature11005-s2.zip"), exdir=file.path(path.drug, "dwl"))
		file.copy(from=file.path(path.drug, "dwl", ff), to=myfn)
	}
	
}

downloadGDSCdrugs()

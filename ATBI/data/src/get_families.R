require(taxize)
setwd("~/Dropbox/Projects/090_ATBI/data/")

d = read.csv("~/Dropbox/Projects/090_ATBI/data/bhi_all_specimens.csv", header=T, sep = ";")
dim(d)

head(d)
d$WHIT_Taxon.Name
all_genera = unlist(lapply(strsplit(d$WHIT_Taxon.Name, split = " ", fixed = TRUE), function(x) x[1]))

unique_taxa = sort(unique(d$WHIT_Taxon.Name))
genera = unlist(lapply(strsplit(unique_taxa, split = " ", fixed = TRUE), function(x) x[1]))
unique_genera = sort(unique(genera))
#famout = tax_name(sci = unique_genera, get = c("family", "order", "kingdom"), db = 'ncbi')
famout = read.csv("products/family_out.csv")
error = which(!is.na(famout$kingdom) & famout$kingdom=="Fungi")
d[grep(unique_genera[error[1]], d$WHIT_Taxon.Name),]
# note: fungi records are correct

tmp = grep("thall", d$WHIT_Coll_Object_Remarks)
sort(unique(d$WHIT_Taxon.Name[tmp]))
unique_genera[error]

# to check:
#"Clonophoromyces nipponicus"
#"Stichomyces cf. conosomatis"
#"Stichomyces conosomatis"
#famout[famout$query=="Clonophoromyces",]
#famout[famout$query=="Stichomyces",]
# note - probably both fungi



# TODO: fix by hand
error = which(is.na(famout$kingdom))
d[grep(unique_genera[error[2]], d$WHIT_Taxon.Name),]
famout[error[2],]

#write.csv(famout, "products/family_out.csv", row.names=FALSE)
famout = read.csv("products/family_out.csv")

# link to data
d$kingdom = famout$kingdom[match(all_genera, famout$query)]
d$order = famout$order[match(all_genera, famout$query)]
d$family = famout$family[match(all_genera, famout$query)]
d$genus = all_genera


# check
dim(d[!is.na(d$family) & d$family=="Formicidae",])
ps = which(!is.na(d$family) & d$family=="Formicidae")

df=data.frame(island = d$Events..locality[ps], year = as.numeric(substr(d$Events..WHIT_date1Export, 1, 4))[ps])
table(df)

df=data.frame(island = d$Events..locality, year = as.numeric(substr(d$Events..WHIT_date1Export, 1, 4)))
table(df)



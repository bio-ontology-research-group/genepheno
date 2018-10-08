# genepheno
this repository contains text mined gene-phenotype data and scripts used to mine the text data.

merged.human.mouse.TM.extracts+NPMI.txt.zip
This file contains text mined gene-phenotype associations.
Data format:
MGI-gene-ID###Enrez-mosue-gene-ID_#_Entrez-Human-ID###Phenotype_ID\tNPMI-score

OntologybasedExpansion.pl
This script expands the text mined gene-phenotype data based on the equivalent as well as class relations of the phenotypes in phenomenet.

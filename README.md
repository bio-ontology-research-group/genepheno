# genepheno
This repository contains text mined gene-phenotype data and scripts used to mine the text data.

The Workflow consists of following steps:

STEP1. Annotate Full text PMC articles by employing Whatizit with gene/protein and phenotype names 

STEP2. Extract distict gene/protein -- phenotype pairs from the annotated text

Whatizit pipeline is not publicly available, so we cannot provide any script for these two steps. However, we provide all the gene-phenotype pairs extracted by using this pipeline:

merged.human.mouse.TM.extracts.expanded+NPMI_partX.txt
This file contains text mined gene-phenotype associations which are extracted based on the Whatizit text mining pipeline.
Data format:
MGI-gene-ID###Entrez-mosue-gene-ID_#_Entrez-Human-ID###Phenotype_ID\tNPMI-score

The data is provided in 4 parts due to the size limitation by github. When you download, please merge these files into a single file and named it as merged.human.mouse.TM.extracts.expanded+NPMI.txt. This is a necessary preparation for running the scripts below.

STEP3. Expand the extracted pairs based on the equivalent as well as class relations of the phenotypes in phenomenet (covering phenotypes from HP and MP).

OntologybasedExpansion.pl
use this script for performing the ontology based expansion.

Necessary input files are :
merged.human.mouse.TM.extracts.txt
This file contains gene-phenotype extracts obtained in STEP2.

HP_MP_equivalentClasses.txt
This file contains which Human Phenotype ontology (HP) class corresponds to which Mammalian Phenotype ontology (MP) class.
This information is used to propagate the extracts to their quivalent classes.

mod.phenomenet.HP.SuperClasses.txt and mod.phenomenet.MP.SuperClasses.txt
These files contain the information on class - superclass relations extracted from the HP and MP ontologies. This information is used to propagate the extracts to their superclasses.

To run the script:
1. open a terminal and change the path to the project that you downloaded
2. Keep the necessary input files in the same folder
3. perl OntologybasedExpansion.pl >merged.human.mouse.TM.extracts.expanded.txt

output will be saved in a file named "merged.human.mouse.TM.extracts.expanded.txt"

STEP4. Calculate NPMI value of the text mined associations.

NPMI.pl

STEP5. For each given gene, rank the phenotypes associated with this gene based on NPMI value and experiment the generated set of pairs for its success in predicting the genes with known their phenotypes from MGI and HPO
  
STEP6. Pick the set of gene-phenotype pairs with the optimal rank and apply it to predict gene-disease associations based on the phenotypic similarity of genes and diseases.

Scripts for semantic similarity analysis can be found from here:
https://github.com/bio-ontology-research-group/similarityonMGI

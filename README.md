# genepheno
This repository contains text mined gene-phenotype data and scripts used to analyse the extracts.

The Workflow consists of following steps:

**STEP1.** Annotate Full text PMC articles by employing Whatizit with gene/protein and phenotype names 

See https://github.com/bio-ontology-research-group/whatizit on how to annotate articles with Whatizit.

**STEP2.** Extract distict gene/protein -- phenotype pairs and their frequencies from the annotated text
*(1).* Extract sentences containing gene-phenotype co-occurrences:

Required input is:

a file containing a bunch of annotated PMC Open Access full text articles in gz format (e.g. InputFile.gz) (obtained in STEP1)


How to run the Gene-phenoCo-occExtraction.pl script:

1.  open a terminal and change the path to the project

2.  perl Gene-phenoCo-occExtraction.pl InputFile.gz >TM.extracts.txt

Output will be saved in a file named "TM.extracts.txt"

Output format: PMCID\tPMID\tGeneID\tGeneName\tphenotypeID\tphenotypeName\tsentence_containing_co-occurrence

Help:

perl Gene-phenoCo-occExtraction.pl -h OR perl Gene-phenoCo-occExtraction.pl -help

*(2).* Find co-occurrence frequencies of the extracted pairs

Required input is:

a file containing gene-phenotype extracts (e.g. TM.extracts.txt)

Input Format:PMCID\tPMID\tGeneID\tGeneName\tphenotypeID\tphenotypeName\tsentence_containing_co-occurrence

How to run the UniqPairs.pl script:

1.  open a terminal and change the path to the project

2.  perl UniqPairs.pl TM.extracts.txt >TM.extracts+Freq.txt

Output will be saved in a file named "TM.extracts+Freq.txt"

Output Format:GeneID#PhenotypeID\tGeneName#PhenotypeName\tNof_co-ocurrences\tnof_articles_containingC-occurr\tPMCIDList

Help:

perl uniqPairs.pl -h OR perl uniqPairs.pl -help

We provide all the gene-phenotype pairs and their co-occurence frequencies extracted from PMC Full text articles by using Whatizit (through STEP1&2):

merged.human.mouse.TM.extracts_partX.txt

This file contains text mined gene-phenotype associations which are extracted based on the Whatizit text mining pipeline. (X is the part number, this file consists of two parts)

Data format:

MGI-gene-ID\tEntrez-mosue-gene-ID_#_Entrez-Human-ID\tPhenotype_ID\tno_of_co-occurrence\tno_of_articles

The data is provided in 2 parts due to the size limitation by github. When you download, please merge these files into a single file and named it as merged.human.mouse.TM.extracts.txt. This is a necessary preparation for running the perl script in STEP3.

Follow these steps to merge the two files:

1.open a terminal and change the path to the project that you downloaded

2.cat merged.human.mouse.TM.extracts_part1.txt merged.human.mouse.TM.extracts_part2.txt > merged.human.mouse.TM.extracts.txt



**STEP3.** Expand the extracted pairs based on the equivalent as well as class relations of the phenotypes in phenomenet (covering phenotypes from HP and MP).

OntologybasedExpansion.pl

use this script for performing the ontology based expansion.

Required input files are :

merged.human.mouse.TM.extracts.txt 

This file contains gene-phenotype extracts obtained in STEP2. Please see above. 

HP_MP_equivalentClasses.txt

This file contains which Human Phenotype ontology (HP) class corresponds to which Mammalian Phenotype ontology (MP) class.
This information is used to propagate the extracts to their quivalent classes.

mod.phenomenet.HP.SuperClasses.txt and mod.phenomenet.MP.SuperClasses.txt

These files contain the information on class - superclass relations extracted from the HP and MP ontologies. This information is used to propagate the extracts to their superclasses.

how to run the OntologybasedExpansion.pl script:

1. open a terminal and change the path to the project that you downloaded

2. perl OntologybasedExpansion.pl >merged.human.mouse.TM.extracts.expanded.txt

Output:

It will be saved in a file named "merged.human.mouse.TM.extracts.expanded.txt"

Help:

perl OntologybasedExpansion.pl -h  OR  perl OntologybasedExpansion.pl -help 



**STEP4.** Calculate NPMI value of the text mined associations.

NPMI.pl

use this script for performing the NPMI calculation.

Required input file is:

merged.human.mouse.TM.extracts.expanded.txt 

This file contains gene-phenotype extracts expanded based on class-equivalent class and class-superclass relations in PhenomeNet. Please see STEP3 above on how to generate it. 

How to run the NPMI.pl script:

 1.  open a terminal and change the path to the project\n
 2.  perl NPMI.pl >merged.human.mouse.TM.extracts.expanded+NPMI.txt\n


Output:

It will be saved in the file named "merged.human.mouse.TM.extracts.expanded+NPMI.txt"

Output data format:

MGI-gene-ID###Entrez-mosue-gene-ID_#_Entrez-Human-ID###Phenotype_ID\tNPMI-score

Help:

perl NPMI.pl -h  OR  perl NPMI.pl -help 



**STEP5.** Find an optimal threshold for selecting the gene-phenotype pairs

We applied an ontology based semantic similarity analysis to obtain the optinal thresold for selecting the gene-phenotype extracts. For each given gene, we rank the phenotypes associated with this gene based on NPMI value and experiment the generated set of pairs for its success in predicting the genes with known their phenotypes from MGI and HPO. 

createRankedSets.pl

Use this script to generate ranked lists. These lists will cover the gene-phenotype extracts upto the provided rank threshold.  

Required input file is:

merged.human.mouse.TM.extracts.expanded+NPMI.txt

This file contains gene-phenotype extracts with their NPMI values. See STEP4 for how to generate it.

How to run the createRankedSets.pl script:

 1.  open a terminal and change the path to the project
 
 2.  perl createRankedSets.pl N >merged.human.mouse.TM.extracts.expanded+NPMI.rankN.txt
 
N is a number between 1 and maximum no of phenotypes extracted for the genes having the largest set of phenotypes

Output:

It will be saved in a file named "merged.human.mouse.TM.extracts.expanded+NPMI.rankN.txt"

Help:

perl createRankedSets.pl -h  OR  perl createRankedSets.pl -help 


How to select the optimal rank:

You can follow the steps (GENE-GENE similarity) in https://github.com/bio-ontology-research-group/similarityonMGI

**STEP6.** You can pick the set of gene-phenotype pairs with the optimal rank (obtained in STEP 5) and apply it to predict gene-disease associations based on the phenotypic similarity of genes and diseases. This step illustrates an application for our gene-phenotype extraction method.

You can follow the steps (GENE-DISEASE prediction) in https://github.com/bio-ontology-research-group/similarityonMGI


Technical Issues:

contact senay.kafkas@kaust.edu.sa

use strict;

my (%parents, @parent_arr, $p, $key, @arr, $line, @tmp, %genes, $i, $j, $gene, $pheno, $rank, %ranked, @ext, %real, %orig);


if( $ARGV[0] eq '-h' || $ARGV[0] eq '-help')
{
help();
exit;
}


sub help { print "\nRequired input file is: \n\n (1) merged.human.mouse.TM.extracts.expanded+NPMI.txt \n This file contains gene-phenotype extracts with their NPMI values\n\n
How to run the createRankedSets.pl script:\n\n
 1.  open a terminal and change the path to the project\n
 2.  perl createRankedSets.pl N >merged.human.mouse.TM.extracts.expanded+NPMI.rankN.txt\n
N is a number between 1 and maximum no of phenotypes extracted for the genes having the largest set of phenotypes\n
Output will be saved in a file named \"merged.human.mouse.TM.extracts.expanded+NPMI.rankN.txt\"\n\n";
}

$rank=$ARGV[0];

open IN, "merged.human.mouse.TM.extracts.expanded+NPMI.txt" or die "cannot open merged.human.mouse.TM.extracts.expanded+NPMI.txt";
#MGI:97171###17748_#_4489##4490##4493##4494##4495##4496##4499##4501###HP_0100001	0.09

#MGI:2446326###282619_#_374897###HP_0000119	0.03


while ($line=<IN>)
{chomp $line;
if (($line !~/_#_###/) and ($line=~/MGI/)) #has entrez human ID
{
@arr=split("\t", $line);  # arr[0]-> IDs  arr[1]->NPMI
@tmp=split("###", $arr[0]); #tmp[0]->MGI, $tmp[1] -> mouse+human $tmp[2]->phenotype IDs 
if ($line=~/_#_/) {@ext=split("_#_", $tmp[1]);
        
                     if ($ext[1] ne "") {$genes{$ext[1]}{$tmp[2]}=$arr[1]; if (!exists $real{$ext[1]."###".$tmp[2]}) {$real{$ext[1]."###".$tmp[2]}=$line;} else {$real{$ext[1]."###".$tmp[2]}=$real{$ext[1]."###".$tmp[2]}."MMMM".$line;}}
                  }
}
if (($line!~/_#_/) and ($line!~/MGI/))
####1178###MP_0001861	0.14

 { @arr=split("\t", $line); @tmp=split("###", $arr[0]); $genes{$tmp[1]}{$tmp[2]}=$arr[1]; if (!exists $real{$tmp[1]."###".$tmp[2]}) {$real{$tmp[1]."###".$tmp[2]}=$line;} else {$real{$tmp[1]."###".$tmp[2]}=$real{$tmp[1]."###".$tmp[2]}."MMMM".$line;}}

}

close IN;

foreach $gene (sort keys %genes) { $i=1;
    foreach $pheno (sort { $genes{$gene}{$b} <=> $genes{$gene}{$a} } keys %{ $genes{$gene} }) {
      if ($i<=$rank) 
       {

       $ranked{$gene."###".$pheno}=$genes{$gene}{$pheno}; $i++;}
    }
}



foreach $key (keys %ranked)
{
@tmp=split("MMMM", $real{$key});
if (scalar @tmp >1)
{
foreach $i(@tmp)
   { @arr=split("\t", $i); if ($arr[1] eq $ranked{$key})  {print $i."\n"; }
  }

}
else
{print $real{$key}."\n";}

}






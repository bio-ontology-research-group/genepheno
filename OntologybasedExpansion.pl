use strict;


my ($line,@arr,@arr1,@arr2,$key,$sympthom,$gene, %hp_eq, %mp_eq, %final, $cnt);
my %pair1;
my %parents;
%pair1=();
%parents=();

$cnt=0;

open IN, "HP_MP_equivalentClasses.txt" or die "cannot open HP_MP_equivalentClasses.txt";
while ($line=<IN>)
{
chop $line; $line=~s/HP:/HP_/g; $line=~s/MP:/MP_/g;

#HP:0008070 equivalent to MP:0000416
@arr=split(" equivalent to ", $line);

if ($line=~/HP_/) {$hp_eq{$arr[0]}=$arr[1];}
else {$mp_eq{$arr[0]}=$arr[1]; }

}
close IN;



open IN, "merged.human.mouse.TM.extracts.txt" or die "cannot open merged.human.mouse.TM.extracts.txt";
#MGI:103223	22346_#_7428	HP_0002668	129	77
while ($line=<IN>)
{
chop $line;
$line=~s/&amp;/&/g;
$line=~s/&quot;/\"/g;
$line=~s/&apos;/\'/g;
$line=~s/&lt;/</g;
$line=~s/&gt;/>/g;


@arr=split('\t', $line);

my $gene_mgi = $arr[0];
my $gene_entrez = $arr[1];
my $pheno=$arr[2];
my $occurence=$arr[3];
#my $noArticle=$arr[4];

my $gene_sympthom=$gene_mgi."###".$gene_entrez."###".$pheno;
#print $gene_sympthom."\t". $occurence."\n";
$pair1{$gene_sympthom}=$occurence;

}
close IN;

#for $key (keys(%pair1))
#{
#print $key."\t".$pair1{$key}."\n";
#}


open IN, "mod.phenomenet.HP.SuperClasses.txt" or die "cannot open mod.phenomenet.HP.SuperClasses.txt";
#HP:0001293      HP:0000707##HP:0000234##HP:0045010##
while ($line=<IN>)
{
chop $line; $line=~s/HP:/HP_/g; $line=~s/MP:/MP_/g;

@arr=split('\t', $line);

my $subclass = $arr[0];
my $parent=$arr[1];
$parents{$subclass}=$parent;
    
}
close IN;


open IN, "mod.phenomenet.MP.SuperClasses.txt" or die "cannot open mod.phenomenet.MP.SuperClasses.txt";
#HP:0003850      MP:0009250##HP:0011844##HP:0011842##MP:0005508##
while ($line=<IN>)
{
chop $line; $line=~s/HP:/HP_/g; $line=~s/MP:/MP_/g;

@arr=split('\t', $line);

my $subclass = $arr[0];
my $parent=$arr[1];
$parents{$subclass}=$parent;
}
close IN;


#for $key (keys(%parents))
#{
#print $key."\t".$parents{$key}."\n\n";
# }
#


my($n,$tmp,@arr3, $count, $count1, @halo, $gene_mgi, $gene_entrez);
foreach $key (keys %pair1)
{ $count=0; $count1=0;
	@arr=split('###', $key);
	$gene_mgi=$arr[0];
        $gene_entrez=$arr[1];
	$sympthom=$arr[2]; 
        #@halo=split('#', $pair1{$key});
	
      if (exists $parents{$sympthom})
	{
	 	@arr2=split('##',$parents{$sympthom});#parents
                ###@arr2=uniq(@arr2);
		foreach $n (@arr2){
			 $tmp=$gene_mgi."###".$gene_entrez."###".$n;	
	 	#if  ( ($n eq "MP_0006082") and ($gene_mgi eq "MGI:1261423")) {print "child=".$key." parent=".$n." and ".$gene_mgi."\n";
			if (exists $pair1{$tmp})
			{	
				#print $tmp."=".$pair1{$tmp}."\n";
                                #print $key."=".$pair1{$key}."\n";	
                                $pair1{$tmp} = $pair1{$key}+$pair1{$tmp};
				
			}
			
                       else {$pair1{$tmp}=$pair1{$key};}
                                  }

	}#if it has parents
  
} #foreach key in pair1



#foreach $key (keys %pair1)
#{
#@arr3=split('#', $pair1{$key});
#print $key."\t".$arr3[0]."\t".$arr3[1]."\n";
#}

my %tmp_hash=%pair1;

#EQUIVALENT CLASS
foreach $key (keys %pair1)
{ 	@arr=split('###', $key);
	$gene_mgi=$arr[0];
        $gene_entrez=$arr[1];
	$sympthom=$arr[2];
        
#if it is HP and has equivalent class in MP
if (exists $hp_eq{$sympthom})
  {
$tmp=$gene_mgi."###".$gene_entrez."###".$hp_eq{$sympthom};				
 if ((exists $pair1{$key}) and (exists $pair1{$tmp}))
      {$pair1{$key}= $tmp_hash{$key}+$tmp_hash{$tmp};
       $pair1{$tmp}= $tmp_hash{$key}+$tmp_hash{$tmp};
      }
 if ((exists $pair1{$key}) and (!exists $pair1{$tmp}))
    {$pair1{$tmp}= $pair1{$key};}
}

} #foreach key in pair1


foreach $key (keys %pair1)
{ 	@arr=split('###', $key);
	$gene_mgi=$arr[0];
        $gene_entrez=$arr[1];
	$sympthom=$arr[2];
##if it is MP and has equivalent class in MP
if (exists $mp_eq{$sympthom})
   {
$tmp=$gene_mgi."###".$gene_entrez."###".$mp_eq{$sympthom};				
 
if ((exists $pair1{$key}) and (!exists $pair1{$tmp}))
    {$pair1{$tmp}= $pair1{$key};}
}

} #foreach key in pair1



foreach $key (keys %pair1)
{
@arr3=split('#', $pair1{$key});
print $key."\t".$arr3[0]."\t".$arr3[1]."\n";
}



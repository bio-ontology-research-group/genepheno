
use strict;


my ($line, @arr,@arr1, @tmp, $i, $key, $key2,$k);


my %pair1=();
my %pair2=();
my %pair3=();
my %pair4=();
my $total=0;
my $count=0;

if( $ARGV[0] eq '-h' || $ARGV[0] eq '-help')
{
help();
exit;
}


sub help { print "\nRequired input file is: \n\n (1) merged.human.mouse.TM.extracts.expanded.txt \n This file contains gene-phenotype extracts expanded based on class-equivalent class and class-superclass relations in PhenomeNet\n\n 
How to run the NPMI.pl script:\n\n
 1.  open a terminal and change the path to the project\n
 2.  perl NPMI.pl >merged.human.mouse.TM.extracts.expanded+NPMI.txt\n
Output will be saved in a file named \"merged.human.mouse.TM.extracts.expanded+NPMI.txt\"\n\n";
}


open (IN, "merged.human.mouse.TM.extracts.expanded.txt") || die "cannot open merged.human.mouse.TM.extracts.expanded.txt";
while ($line=<IN>)
{ #MGI:2137668###80892_#_79776###HP_0000319        1       1
#MGI:95482###14085_#_2184###HP_0003231   116     75

chop $line; $count=0;
@arr=split('\t', $line);

my $gene_sympthom = $arr[0];
#my $gene_sympthom_name = $arr[1];
my $occurencePerArticle=$arr[2];
#my $pmcid=$arr[4];
my $occurence = $arr[1];
@arr1=split('###',$gene_sympthom);
my $gene=$arr1[0]."###".$arr1[1];
my $sympthom=$arr1[2];

if (! exists $pair1{$gene})
{
	$pair1{$gene}=$occurence;
}
else
{
	$count=$pair1{$gene}+$occurence;
        $pair1{$gene}=$count;

}


$count=0;

if (! exists $pair2{$sympthom})
{
        $pair2{$sympthom}=$occurence;
}
else
{
        $count=$pair2{$sympthom}+$occurence;
        $pair2{$sympthom}=$count;
        

}

$pair3{$gene_sympthom}=$occurence;

$total=$total+$occurence;

#$pair4{$gene_sympthom}=$gene_sympthom_name."@".$occurencePerArticle."@".$pmcid;
$pair4{$gene_sympthom}=$occurencePerArticle;


}
close IN;

foreach $key (keys(%pair3))
{	
 if ($pair3{$key} ne "")
  {
	#@arr1=split('@',$pair4{$key});
	@arr=split('###',$key);
	my $gene_occ=$pair1{$arr[0]."###".$arr[1]};
	my $sympthom_occ=$pair2{$arr[2]};
	#print (log($new_hpairs{$key}/($tax_occur{$tmp[0]}*$new_dis_occur{$tmp[1]}/$tot)))/-log($new_hpairs{$key}/$tot);
        my $result=(log($pair3{$key}/($gene_occ*$sympthom_occ/$total)))/-log($pair3{$key}/$total);
	my $result2= sprintf("%.2f",$result);
	print $key."\t".$result2."\n";
#gene_sypthom gene_occur #nof_articles NPMI-score
 }

}


sub uniq
{
my @data=@_;
my @unique = do { my %seen; grep { !$seen{$_}++ } @data };

return @unique;
}



#sub finduniq
#{
#my @terms=@_;
#my $k;
#my @newterms=();

#foreach $k (@terms)
#{
# if (  (!(grep {$_ eq $k} @newterms)) ) {push (@newterms, $k);}  
#}

#return @newterms;


#}

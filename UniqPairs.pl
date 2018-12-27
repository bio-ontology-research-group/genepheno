use strict;
#binmode STDIN, ":utf8";
#binmode STDOUT, ":utf8";

my ($line, @arr, @tmp, $i, $key, $key2,$k);
our  %pairMap;
our %pair1;
our %pair2;
our %pair3;
our %pair4;

%pair1=();
%pair2=();
%pair3=();
%pair4=();


if( $ARGV[0] eq '-h' || $ARGV[0] eq '-help')
{
help();
exit;
}


sub help { print "\nRequired input is a file containing gene-phenotype extracts \n
Input Format:PMCID\tPMID\tGeneID\tGeneName\tphenotypeID\tphenotypeName\tsentence_containing_co-occurrence \n\n 
How to run the UniqPair.pl script:\n\n
 1.  open a terminal and change the path to the project\n
 2.  perl UniqPairs.pl TM.extracts.txt >TM.extracts+Freq.txt\n
Output will be saved in a file named \"TM.extracts+Freq.txt\"\n
Output Format:GeneID#PhenotypeID\tGeneName#PhenotypeName\tNof_co-ocurrences\tnof_articles_containingC-ocurr\tPMCIDList
\n\n";
}




open (IN, $ARGV[0]) || die "cannot open the input file $ARGV[0]";
while ($line=<IN>)
{
chop $line;
$line=~s/&amp;/&/g;
$line=~s/&quot;/\"/g;
$line=~s/&apos;/\'/g;
$line=~s/&lt;/</g;
$line=~s/&gt;/>/g;


@arr=split('\t', $line);

my $gene = $arr[2];
my $geneName =$arr[3];
my $sympthom = $arr[4];
my $sympthomName=$arr[5];


$pair1{$gene."#".$sympthom}++;
$pair3{$geneName."#".$sympthomName}++;

my $pmcid =$arr[0];
my $pmid=$arr[1];

 if (!exists $pair2{$gene."#".$sympthom})
{
	$pair2{$gene."#".$sympthom}=$geneName."#".$sympthomName;
}

if (! exists $pair4{$gene."#".$sympthom})
{	if ($pmid)
	{$pair4{$gene."#".$sympthom}=$pmcid.'_'.$pmid;}
	else {$pair4{$gene."#".$sympthom}=$pmcid;}
}
else {
	if($pmid)
	{$pair4{$gene."#".$sympthom}=$pair4{$gene."#".$sympthom}."##".$pmcid.'_'.$pmid;}
	else
	{$pair4{$gene."#".$sympthom}=$pair4{$gene."#".$sympthom}."##".$pmcid; }
}


}
close IN;


for $key (keys(%pair2))
{@tmp=split('##', $pair4{$key});
@tmp=uniq(@tmp);

print $key."\t".$pair2{$key}."\t".$pair1{$key}."\t".scalar(@tmp)."\t".join('##',@tmp)."\n";

}


sub uniq
{
my @data=@_;
my @unique = do { my %seen; grep { !$seen{$_}++ } @data };

return @unique;
}



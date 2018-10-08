
use strict;
#binmode STDIN, ":utf8";
#binmode STDOUT, ":utf8";

my ($line, @arr,@arr1, @tmp, $i, $key, $key2,$k);


my %pair1=();
my %pair2=();
my %pair3=();
my $total=0;
my $count=0;

$ARGV[0]="merged.human.mouse.TM.extracts.expanded.txt";

open (IN, $ARGV[0]) || die "cannot open the input file";
while ($line=<IN>)
{ #MGI:2137668###80892_#_79776###HP_0000319        1       1
#MGI:95482###14085_#_2184###HP_0003231   116     75

chop $line; $count=0;
@arr=split('\t', $line);

my $gene_sympthom = $arr[0];
my $nof_pmc=$arr[2];
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


}
close IN;

foreach $key (keys(%pair3))
{	
 if ($pair3{$key} ne "")
  {
	
	@arr=split('###',$key);
	my $gene_occ=$pair1{$arr[0]."###".$arr[1]};
	my $sympthom_occ=$pair2{$arr[2]};
        my $result=(log($pair3{$key}/($gene_occ*$sympthom_occ/$total)))/-log($pair3{$key}/$total);
	my $result2= sprintf("%.2f",$result);
	print $key."\t".$result2."\n";

 }

}


sub uniq
{
my @data=@_;
my @unique = do { my %seen; grep { !$seen{$_}++ } @data };

return @unique;
}


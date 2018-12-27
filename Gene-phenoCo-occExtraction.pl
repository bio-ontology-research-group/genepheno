#Use this script to extract gene-phenotype co-occurrences from the PMC Open Access full text articles
#Developed by Senay Kafkas
#Jan, 2018

use strict;
our $doc; my $line; my $cnt;
my $file; my $key;

our %freq;


if( $ARGV[0] eq '-h' || $ARGV[0] eq '-help')
{
help();
exit;
}


sub help { print "\nRequired input is a file containing a bunch of annotated PMC Open Access full text articles in gz format (e.g. InputFile.gz) \n\n 
How to run the Gene-phenoCo-occExtraction.pl script:\n\n
 1.  open a terminal and change the path to the project\n
 2.  perl Gene-phenoCo-occExtraction.pl InputFile.gz >TM.extracts.txt\n
Output will be saved in a file named \"TM.extracts.txt\"\n\n";
}




print "PMCID \t PMID \t uniprotID \t geneName \t symptomID \t symptom \t sentence \n";


open(IN, "gunzip -c $ARGV[0] |") || die "can't open input file $ARGV[0]\n";

while ($line=<IN>)
{ 

   if ($line =~ /<!DOCTYPE /)
   { 
     $cnt++;
     if ($doc ne "")
     {process(); $doc="";}
    
     }
 
  else { $doc=$doc.$line; }
   
}
 
process();
close IN;



##############   subs  #######################

sub process {
my ($s); 
my (@Sentences)= &proc_sentences();

if ($#Sentences ne -1)
{ foreach $s(@Sentences)
  {


my $sent=shift;
my @hp=();
my @uniprot=();
my @pairs=();
my @txt=();
my $g; my $key;
my $d; my $key1;
my %h_uniprot=();
my %h_sympthom=();
my @tmp;

while ($s =~ /<z:hp ids=\"(.*?)\" cat=\"(.*?)\">((.|\n)*?)<\/z:hp>/g)
{ $h_sympthom{$1}=$3;

 }

while ($s =~ /<z:mp ids=\"(.*?)\" cat=\"(.*?)\">((.|\n)*?)<\/z:mp>/g)
{ $h_sympthom{$1}=$3; 

}


while ($s=~ /<z:uniprot fb=\"(\d+)\" ids=\"(.*?)\">((.|\n)*?)<\/z:uniprot>/g) {$h_uniprot{$2}=$3;

 }
 

@uniprot=keys(%h_uniprot);
@hp=keys(%h_sympthom);

foreach $key (keys %h_uniprot)
{ foreach $key1 (keys %h_sympthom)
   { print &proc_pmcid()."\t".&proc_pmid()."\t". $key. "\t". $h_uniprot{$key}."\t".$key1. "\t". $h_sympthom{$key1}."\t".$s. "\n";
	 }


}



 }#foreach sentence

}

}#sub



sub proc_pmcid {
  if ($doc =~ /<article-id pub-id-type=\"pmcid\">(\S+)<\/article-id>/) { 

 return $1;
  }

  else {return "";}
}


sub proc_pmid {
  if ($doc =~ /<article-id pub-id-type=\"pmid\">(.*?)<\/article-id>/) {

 return $1;
  }

  else {return "";}
}



sub proc_sentences {
my $sent;
my @last;

while ($doc =~ /<plain>(.*?)<\/plain>/g) 
{$sent=$1;
   if ( (($sent=~/<z:hp /) or ($sent=~/<z:mp /)) and ($sent=~/<z:uniprot /)) { push (@last, $sent);} 
}

return (@last);
}








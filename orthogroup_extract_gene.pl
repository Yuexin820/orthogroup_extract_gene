use strict;

my ($geneFamily,$genes) = @ARGV;

my %geneFams;
open FILE,"$geneFamily" or die $!;
while (<FILE>)
{
	chomp;
	$geneFams{$_} = "y";
}
close FILE;

my @species;
open FILE,"$genes" or die $!;
while (my $line = <FILE>)
{
	chomp($line);
	my @line_words = split /\t/,$line;
	if($line_words[0] eq "Orthogroup")
	{
		for(my $i=1;$i<@line_words;$i++)
		{
			open my $fh,">Ortho_"."$line_words[$i]" or die $!;
			$species[$i] = $fh;
		}
		next;
	}
	elsif($geneFams{$line_words[0]} eq 'y')
	{
		for(my $i=1;$i<@line_words;$i++)
		{
			my @ids = split /,/,$line_words[$i];
			map{
				s/ //g;
				if(/\w/){print {$species[$i]} "$_\n"}
			}@ids;
		}
	}
}
close FILE;

map{close $_}@species;

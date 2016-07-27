use strict;
use warnings;

print "Which seed would you like to look up?\n";
print "You may also choose random or 0 to quit.\n";

# if $path == 0, we are displaying only the first five depths. this ensures you get what you are looking for but you can't see everything
# if $path == 1, we are lookng at contents of entire seed. no mystery at all
my $path = 0;

for (;;)
{
	print "Seed: ";
	my $input = <>;
	chomp($input);

	# if they input a string assume they want a random seed to be looked up
	$input = int(rand(80000)) if ( $input =~ m/[^0-9]/ );
	# break if the number is negative
	last if ($input eq "");

	open INPUT, "< brogueSeedCatalog.txt" or die "Can't open input file: $!" if ($path == 0);
	
	open INPUT, "< seedCatalog.txt" or die "Can't open input file: $!" if ($path == 1);

	# keep track of the seed number
	my $seed = 0;
	my $found = 0;
	my $output = "\n";

	# reads in all lines of file one at a time
	while (my $line = <INPUT>) {

		# find the line where "Seed" is written and update information
		$found = 1 if ($line =~ /Seed.*$input/i);
		
		# once we have found the seed add all lines to output
		$output .= $line if ($found == 1);
		
		# until we find a blank line. then we are done
		last if ($path == 0 && $found == 1 && length($line) < 3);
		last if ($path == 1 && $found == 1 && $line =~ /In the monster/i)
	}
	
	print $output;
}

reset;

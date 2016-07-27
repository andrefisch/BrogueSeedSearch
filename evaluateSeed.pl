use strict;
use warnings;

my ($searchNo) = shift;
print "Now rating the seeds. This may take a minute...\n";

open INPUT, "< seedCatalog.txt" or die "Can't open input file: $!";

open OUTPUT1, "> scores$searchNo.brs" or die "Can't open output file: $!";

if ($searchNo =~ /[1-9]/)
{
    # score only the seeds in the most recent seed catalog
    $searchNo--;
    print "Only rating the seeds in shortCatalog$searchNo.brs\n";
    open INPUT, "< shortCatalog$searchNo.brs" or die "Can't open input file: $!";	
}

##############
# TO DO LIST #
##############
=begin

- figure out a way to take depth into account
- are enchants worth too many points?

- SCORING SYSTEM
    - SCROLLS
        - average of 14 enchants with one seed as few as 6 and a few as many as 21
        - seeds should start with 14 * 10 = -140 to reflect this then add 10 for each enchant
    - POTIONS
        - lowest number of strength/life potions is 11 with max being 21
        - seeds should start with an additional 15 * 5 = -60 to reflect this
        - negative potions will be -1, except darkness and hallucination which will be -2
        - other positive potions will be +1
    - WANDS
        - empow +3, plenty +5, all others +1
    - otherwise items should be added based on their native enchant level
        - positive runics will be +5
        - negative runics will be -5
    - CAPTIVES 
        - monkey/goblin +1
        - mystic/conjurer/pixie +2
        - ogre/blademaster/imp/centaur/golem/salamander +3
        - priestess/battlemage +4
        - naga/troll +5
        - horror/dragon +7


- combine both programs then parse input with regex

=cut

#############
# VARIABLES #
#############

# seed info
my $seed = 0;
# how many lines in this file
my $count = 0;
# define match now so we dont have to keep defining it in the loop
my $match = 0;
# what depth are we on
my $depth = 0;
# hold the current seed in a string then output it to the shortCatalog if a match is found
my $seedString = "";
# where seed info will go
my %quick;

# score for the seed
my $score;
my $enchantStart = -140;
my $potionStart  =  -60;

# reads in all lines of file one at a time
while (my $line = <INPUT>) 
{
    # find the line where "Seed" is written and update information
    if ($line =~ /Seed/i)
    {
        $match = ($' =~ /\d+/i);
        # which seed is this?
        $seed = $&;
        # i shouldnt need to subtract the value of the seed number
        # but it shouldnt be affecting the score
        $score = $enchantStart + $potionStart - $seed;
        $count = 0;
    }

    # keep track of what depth we are in
    $depth += 1 if ($line =~ /Depth/i);

    chomp $line;
    # keep track of how many items there are
    if ($line =~ /^(Depth|Peering)/i or (length $line eq 1))
    {

    }
    else
    {
        $count += 1;
    }

    if ($line =~ /scroll/i)
    {
        if ($line =~ /enchant/i)
        {
            $score += 10;
        }
        elsif ($line =~ /(ident|mapp|protect)/i)
        {
            $score += 3;
        }
        elsif ($line =~ /monsters/i)
        {
            $score -= 3;
        }
        else
        {
            $score += 1;
        }
    }
    elsif ($line =~ /potion/i)
    {
        if ($line =~ /(strength|life|detect)/i)
        {
            $score += 5;
        }
        elsif ($line =~ /(levitation|telepathy|speed|immunity|invis)/i)
        {
            $score += 1;
        }
        elsif ($line =~ /(hallu|darkn)/i)
        {
            $score -= 3;
        }
        else
        {
            $score -= 1;
        }
    }
    elsif ($line =~ /wand/i)
    {
        if ($line =~ /plenty/i)
        {
            $score += 5;
        }
        elsif ($line =~ /(empow|domination)/i)
        {
            $score += 3;
        }
        else
        {
            $score += 1;
        }
    }
    elsif ($line =~ /(staff|charm|ring)/i)
    {
        $line =~ /(\d+)/i;
        # might need to check syntax of this one
        $score += $1;
    }
    elsif ($line =~ /(dagger|spear|sword|whip|axe|mace|pike)/i)
    {
        $line =~ /^([+-]\d+)/i;
        $score += $1;

        if ($line =~ /\+\d.*of.* \<\d+\>/i)
        {
            $score += 5; 
        }
        elsif ($line =~ /\-\d.*of.* \<\d+\>/i)
        {
            $score -= 5;
        }
    }
    elsif ($line =~ /(leather|scale|chain|banded|splint|plate)/i)
    {
        $score += $1 if ($line =~ /^([+-]\d+)/i);
        

        if ($line =~ /\+\d.*of.*\]\<\d+\>/i)
        {
            $score += 5;
        }
        elsif ($line =~ /\-\d.*of.*\]\<\d+\>/i)
        {
            $score -= 5;
        }
    }
    elsif ($line =~ /captive/i)
    {
        if ($line =~ /(explosive|infested)/i)
        {
            $score -= 1;
        }
        elsif ($line =~ /(vampiric|grappling|agile|toxic)/i)
        {
            $score += 1;
        }

        if ($line =~ /(mystic|conjurer|pixie)/i)
        {
            $score += 2;
        }
        elsif ($line =~ /(goblin|monkey)/i)
        {
            $score += 1;
        }
        elsif ($line =~ /(ogre|blademaster|imp|centaur|golem|salamander)/i)
        {
            $score += 3;
        }
        elsif ($line =~ /(priestess|battlemage)/i)
        {
            $score += 4;
        }
        elsif ($line =~ /(naga|troll)/i)
        {
            $score += 5;
        }
        elsif ($line =~ /(horror|dragon)/i)
        {
            $score += 7;
        }
    }
    elsif ($line =~ /crystal/i)
    {
        $score += 3;
    }
    elsif ($line =~ /(mango|food)/i)
    {
        $score += 1;
    }

    # write this information to the hash
    if ($count > 0)
    {
        $quick{$seed} = $score;
        # $quick{$seed} = $score / $count;
    }

    # print "Line being evaluated is: $line";
    # print "Current score is: $score\n";
}

# record the info in the correct file

# sort the dictionary by count and then print each line to file
$count = 0;
my $wrap = 5;
my $binding = "||";
# sort the list by occurences and print nicely
foreach $seed (sort { $quick{$a} <=> $quick{$b} or $a <=> $b } keys %quick) 
{
    $count++;
    if ($count % $wrap == 0)
    {
        printf OUTPUT1 "%-5s %-4s %s\n", $seed, $binding, $quick{$seed} if ($quick{$seed} > 0 );
    }
    else
    {
        printf OUTPUT1 "%-5s %-4s %s\t\t", $seed, $binding, $quick{$seed} if ($quick{$seed} > 0 );
    }
}

printf OUTPUT1 "\n\n";

reset; 

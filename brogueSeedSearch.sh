count=0;
touch bestSeeds$count.brs;
perl catalogSearch.pl $count;
tail bestSeeds$count.brs;

echo "##################################################################################"
echo "#                                     Options:                                   #";
echo "# s: search for an item with a regular expression up to specified depth          #";
echo "# p: roll back to last search                                                    #";
echo "# l: look up the first 5 depths of specified seed                                #";
echo "# r: reset the searches you have done, start over                                #";
echo "# k: record a seed in the interesting seed log                                   #";
echo "# i: look at list of interesting seeds                                           #";
echo "# x: clean exit program: all files created while running the program are erased  #";
echo "# q: dirty exit program: all files created while running are left where they are #";
echo "##################################################################################";
echo "#                                SPECIAL SERACHES:                               #";
echo "# runic armor: will search for any runic armor in the dungeon                    #";
echo "# runic weapon: will search for any runic weapon in the dungeon                  #";
echo "# stealth build: +stealth or clairvoyance ring; blinking, entrancement,          #";
echo "#     conjuration, poison staves; and +war hammers;                              #";
echo "# ally build: captive, crystal orb; wands of empowerment, domination, plenty;    #";
echo "#     haste, healing, and entrancement staves;                                   #";
echo "# wizard build: firebolt, lightning, poison, obstruction staves;                 #";
echo "#     +wisdom and light rings;                                                   #";
echo "# maneuver build: blinking, tunneling, obstruction, conjuration staves;          #";
echo "#     +regeneration and clairvoyance rings;                                      #";
echo "##################################################################################";
echo "";

while true; do
    echo "Search again? go back to Previous search? Look up a seed? Reset search? ";
    echo "Keep seed interesting beed for later? print list of Interesting seeds? ";
    read -p "or play a game of Brogue with the seed of your choice? eXit? " choice

    case $choice in
        [Ss]* )
            # Search for a seed by a certain criteria
			count=$((count+1));
			touch bestSeeds$count.brs;
			perl catalogSearch.pl $count;
			tail bestSeeds$count.brs;;
        [Pp]* )
            # Go up one search level
            rm bestSeeds$count.brs;
			count=$((count-1));
			tail bestSeeds$count.brs;;
        [Ee]* )
            # Score the seed
            echo "";
			count=$((count+1));
            touch scores$count.brs;
            perl evaluateSeed.pl $count;
            tail scores$count.brs;
			count=$((count-1));;
		[Ll]* ) 
            # Look up contents of a specific seed
            perl lookupSeed.pl;;
		[Rr]* )
            # Reset the seed search
			count=0;
			rm *.brs;
			touch bestSeeds$count.brs;
			perl catalogSearch.pl $count;
			tail bestSeeds$count.brs;;
        [Bb]* )
            # Start brogue with the seed of your choice
            read -p "Which seed would you like to play? " seed
            ~/Games/brogue-1.7.4/brogue -s $seed & >/dev/null;
            echo;;
        [Kk]* )
            # Name the list after the current user and start saving seeds
            touch `id -un`.brl;
            tail bestSeeds$count.brs;
            read -p "Which seed would you like to save? " seed;
            read -p "What makes this seed interesting? " reason;
            echo "$seed: $reason `id -un`.brl" >> `id -un`.brl;
            echo "";;
        [Ii]* )
            # Print the interesting seeds for each interesting seed file
            echo "";
            # FOR CLARITY, MAY WANT TO CHANGE THIS TO A FOR EACH LOOP
            cat *.brl;
            echo "";;
		[Xx]* )
            # Exit/Quit...Duh.
			rm *.brs;
			exit;;
		[Qq]* )
			exit;;
        * ) 
            echo "Search again? go back to Previous search? Look up a seed? Reset search? ";
            echo "Keep seed interesting beed for later? print list of Interesting seeds? ";
            echo "or play a game of Brogue with the seed of your choice? eXit? ";;
    esac
done

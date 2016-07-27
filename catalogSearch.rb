search_no = ARGV[0]
puts "Search number is: #{search_no}"

# necessary for using gets
ARGV.clear
print "Input a criteria to search for: (ex: captive): "
input = gets.chomp

print "Input a maximum depth to search for: (ex: 5):  "
depth_search = gets.chomp

read_file = File.open("seedCatalog.txt")
output1 = File.open("bestSeeds#{search_no}.brs")
output2 = File.new("shortCatalog#{search_no}.txt", "w")

if search_no =~ /[1-9]/
    # we are using the last list of seeds to search so decrement search number
    search_no += 1
    puts "Now looking in shortCatalog#{search_no}.brs"
    input = "shortCatalog#{search_no}.brs"
end


####################
# SPECIAL SEARCHES #
####################

# runic armor
if input =~ /runic armou?r/i
    input = '\+\d.*of.*\]\<\d+\>'
# runic weapon
elsif input =~ /runic weapon/i
    input = '\+\d.*of.* \<\d+\>'
# stealth build
elsif input =~ /stealth build/i
    input = '(\+.*Stealth|Blinking|\+.*Clairv|Entrance|Conjur|Poison|\+.*Hammer)'
# ally build
elsif input =~ /ally build/i
    input = '(capti|empow|domina|wand of ple|wand of inv|staff of prote|staff of ha|staff of hea|entrace)'
# wizard build
elsif input =~ /wizard build/i
    input = '(firebolt|lightn|poison|obstr|\+.*light|\+.*wisdom)'
# maneuverability build
elsif input =~ /maneuver(ability)? build/i
    input = '(blink|tunnel|obstr|conjura|\+.*regen|\+.*clairv)'

##########################
# MORE SPECIFIC SEARCHES #
##########################
# gaseous potions for repiration and fire control builds
elsif input =~ /gas(eous)? potions?/i
    input = '(potion of caustic|potion of paralysis|potion of confusion)'
end
##############################################################
# IF THE SEARCH CONTAINS THE WORD VAULT CHANGE IT TO MACHINE # 
##############################################################
if input =~ /vault/i
    input.gsub!(/vault/, 'machine')
end

#############
# VARIABLES #
#############

# seed info
seed = 0
# how many regex matches are in each seed
count = 0
# hold the current seed in a string then output it to the shortCatalog if a match is found
seed_string = ""
# have we finished searching? 0 = no 1 = yes
done = 0
# if the last line was blank save that information so we know when to stop
last_blank = 0
# where seed info will go
quick = Hash.new

# score for the seed
score = 0

print "Searching for #{input} in all depths "
puts "up to depth #{depth_search}" if (depth_search.length > 0)

# we only search if the input is not a blank string
if input.length > 0
    # make sure the depth we are searching to makes sense
    depth_search = 26 if depth_search == "" || depth_search.to_i > 26 || depth_search.to_i <= 0

    # read in the file and loop through it
    i_lines = read_file.read.split("\n")
    i_lines.each do |line|

        # puts line
        # find the line where "Seed" is written and update info
        if line =~ /seed: (\d+)/i
            done = 0
            count = 0
            seed = $1
            seed_string = ""
            puts "Now looking at Seed #{seed}"
        end

        #store current seed to this string
        seed_string += line

        # if this line has the keyword and we are not done searching increment count
        count += 1 if done == 0 && line =~ /#{input}/i

        # write this information to the array
        quick["#{seed}"] = count if count > 0 && input != ""

        # stop counting instances of input at appropriate depth
        done = 1 if line =~ /Depth.*depth_search/i

        # record entire seed if we find at least one instance of keyword
        if line.length <= 2 && last_blank == 1 && count > 0
            File.write(output2, line)
        end

        # reset information from last line
        last_blank = 0;
        # if this line is blank set last_blank to 1
        last_blank = 1 if line.length <= 2

    end
end

# record the info in the correct file
File.write(output1, "\nCriteria: '#{input} ") if input != ""
File.write(output1, "\n")

# sort the dictionary by count then print each line to file
count = 0
wrap = 5
binding = "||"
# sort the dictionary by occurences
quick.sort.map do |seed,value|
	count += 1
	if (count % wrap == 0)
		printf OUTPUT1 "%-5s %-4s %s\n", seed, binding, quick[seed] if quick[seed] > 0;
	else
		printf OUTPUT1 "%-5s %-4s %s\t\t", seed, binding, quick[seed] if quick[seed] > 0;
    end
end

File.write(output1, "\n\n")

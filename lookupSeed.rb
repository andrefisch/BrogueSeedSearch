puts "Which seed would you like to look up?"
puts "You may also choose random or 0 to quit."

num_seeds = 80000

# keep taking input until a blank string is given
while true
    print "Seed: "
    input = gets.chomp

    # if they input a string assume they want a random seed to be looked up
    input = rand(num_seeds) if input =~ /[^0-9]/ || input.to_i >= num_seeds
    # break if the input is blank
    break if input == ""

    # keep track of some info
    seed = 0
    found = 0
    output = ""

    # read in the file and loop through it
    f = File.open("brogueSeedCatalog.txt")
    f_lines = f.read.split("\n")
    f_lines.each do |line|

        # find the line where "Seed" is written and update information
        found = 1 if line =~ /Seed.*#{input}/i

        # once we have found the see add all lines to output
        puts line if found == 1

        # go until we find a blank line then stop
        break if found == 1 && line.length < 3

    end

end

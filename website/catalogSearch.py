import re

searchNo = '0'
print ("Search number is: " + searchNo)

search = input("Input a criteria to search for: (ex: captive): ")
depthSearch = input("Input a maximum depth to search for: (ex: 5):  ")

INPUT = open("seedCatalog.txt", "r")
OUTPUT1 = open("bestSeeds" + searchNo + ".brs", "w+")
OUTPUT2 = open("shortCatalog" + searchNo + ".brs", "w+")

if (int(searchNo) > 0):
    searchNo = int(searchNo) - 1
    print ("Now looking in shortCatalog" + searchNo + ".brs")
    INPUT = open("shortCatalog" + searchNo + ".brs", "r")


#############
# VARIABLES #
#############

# seed info
seed = 0
# how many regex matches are in each seed
count = 0
# define match now so we dont have to keep defining it in the loop
match = 0
# hold the current seed in a string then output it to the shortCatalog if a match is found
seedString = ""
# have we finished searching? 0 = no 1 = yes
done = 0
# if the last line was blank save that information so we know when to stop
lastBlank = 0
# where seed info will go
quick = {}

print ("Searching for " + search + " in all depths ")
if (len(depthSearch) > 0):
    print ("up to depth $depthSearch") 

if (len(search) > 0):
    r = re.compile(search)
    if (depthSearch == ""):
        depthSearch = 26
    depthSearch += 1
    # read in the file
    for line in INPUT:
        # find the line where "Seed" is written and update information
        if ("seed" in line):
            done = 0
            count = 0
            # get the seed number
            n = re.compile('\d+')
            m = n.search(line)
            if (m):
                seed = m.group()
            seedString = ""

        # store the current see to this string
        seedString += line

        # if this line has the keyword and we are not done searching increment count
        m = r.search(line)
        # print ("are we done? " + done + m)
        if (done == 0 and m):
            count += 1

        # write this information to the array
        if ((count > 0) and search != ""):
            quick[seed] = count

        # stop counting instances of SEARCH at appropriate depth
        d = re.compile('Depth.*' + str(depthSearch))
        m = d.search(line)
        if (m):
            done = 1

        # record entire seed if we find at least one instance of keyword
        if (len(line) == 1 and lastBlank == 1 and count > 0):
            OUTPUT2.write(seedString)
        # reset information from last line
        lastBlank = 0
        # if this line is blank set $lastBlank to 1
        if (len (line) == 1):
            lastBlank = 1 

# record the info to the correct file
if (search != ""):
    OUTPUT1.write(search + "\n")

# sort the dictionary by count and then print each line to file
sort = sorted(quick.items(), key=lambda x: (x[1],x[0]), reverse=True)
for i in range (0, len(sort)):
    OUTPUT1.write(str(sort[i][0]) + " " + str(sort[i][1]) + "\n")

print (sort)

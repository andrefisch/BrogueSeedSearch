from flask import Flask, render_template, request

app = Flask(__name__)

# Import the dictionary file for school conversion
seedData = {}
i = 0
with open("./static/text/bestSeeds0.brs") as f:
    for line in f:
        if (i == 0):
            seedData['Criteria'] = line.strip('\n').title()
            i += 1
        else:
            (seed, count) = line.strip('\n').split(" ")
            seedData[seed] = count
            i += 1

@app.route('/', methods=['GET', 'POST'])
def home():
    header = seedData.pop('Criteria')
    sort = sorted(seedData.items(), key=lambda x: (x[1],x[0]), reverse=True)
    if (request.method == 'POST'):
        criteria = request.form['criteria']
        depth = request.form['depth']
        return render_template('display.html', criteria=criteria, depth=depth)
    else:
        return render_template("home.html", header=header, sort=sort)

@app.route('/about/')
def about():
    return render_template("about.html")

if __name__ == "__main__":
    app.run(debug = True)

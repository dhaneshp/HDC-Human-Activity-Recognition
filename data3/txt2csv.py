import csv

activityID = []

with open('activityLabel.csv', 'rb') as f:
    reader = csv.reader(f)
    # read file row by row
    for row in reader:
        activityID.append(row[0])
    del activityID[-1]

for j in range(0,len(activityID)):
    txt_file = activityID[j]+'.txt'
    print(txt_file)
    csv_file = activityID[j]+'.csv'
    #txt_file = r"activityLabel.txt"
    #csv_file = r"activityLabel.csv"
    in_txt = csv.reader(open(txt_file, "rb"), delimiter = ',')
    out_csv = csv.writer(open(csv_file, 'wb'))
    out_csv.writerows(in_txt)

# use 'with' if the program isn't going to immediately terminate
# so you don't leave files open
# the 'b' is necessary on Windows
# it prevents \x1a, Ctrl-z, from ending the stream prematurely
# and also stops Python converting to / from different line terminators
# On other platforms, it has no effect

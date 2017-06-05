import csv
import math

activityID = []

with open('activityLabel.csv', 'rb') as f:
    reader = csv.reader(f)
    # read file row by row
    for row in reader:
        activityID.append(row[0])
    del activityID[-1]

for j in range(0,len(activityID)):
    writefilename = activityID[j]+'_features.csv'
    readfilename = activityID[j]+'.csv'
    with open(writefilename, 'wb') as testfile:
        csv_writer = csv.writer(testfile)
        # open file
        with open(readfilename, 'rb') as f:
            reader = csv.reader(f)
            # read file row by row
            for row in reader:
                try:
                    torsox = float(row[39])
                    torsoy = float(row[40])
                    torsoz = float(row[41])
                    neckx = float(row[25])
                    necky = float(row[26])
                    neckz = float(row[27])
                    denom = math.sqrt(math.pow((neckx - torsox),2) + math.pow((necky - torsoy),2) + math.pow((neckz - torsoz),2))
                    tmp = []
                    i = 11
                    while(i <= 151):
                        tmp.append((float(row[i]) - torsox)/denom)
                        tmp.append((float(row[i+1]) - torsoy)/denom)
                        tmp.append((float(row[i+2]) - torsoz)/denom)
                        i = i + 14 
                    i = 155
                    while(i <= 167):
                        tmp.append((float(row[i]) - torsox)/denom)
                        tmp.append((float(row[i+1]) - torsoy)/denom)
                        tmp.append((float(row[i+2]) - torsoz)/denom)
                        i = i + 4
                    del tmp[6:9]
                    csv_writer.writerow(tmp)
                except:
                    print("Reached file end: ",readfilename)

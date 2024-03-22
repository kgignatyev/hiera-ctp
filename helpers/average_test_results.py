# read lines from file
with open('test_times.txt', 'r') as file:
    lines = file.readlines()
    # iterate through lines
    numLines = len(lines)
    lineN = 0
    mapOfTestTimes = {}
    while lineN < numLines:
        # read the test name
        lineContent = lines[lineN]
        if lineContent.startswith('****'):
            lineN += 1
        else:
            testName = lines[lineN].strip().split('_')[0]
            lineN += 1
            times = lines[lineN].strip().split(' ')
            # print(testName, ' '.join(times))
            realTime = float(times[0])*1000
            testTimes = mapOfTestTimes.get(testName, [])
            testTimes.append(realTime)
            mapOfTestTimes[testName] = testTimes
            lineN += 1

    print("Implementation,time")
    # calculate average
    for testName, times in mapOfTestTimes.items():
        average = sum(times) / len(times)
        print(testName, ",", average)

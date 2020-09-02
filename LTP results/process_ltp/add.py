mylines = ["passed"]
passed_tests_list = []
all_tests_list = []
count_passed = 0
count_failed = 0
skipped_tests = 0

with open ('runsc_out.txt', 'r') as myfile:
    for myline in myfile:

        if myline.startswith("tag"):
            #print(myline)
            tag = myline.split("=")[1].split(" ")[0]
            all_tests_list.append(tag)
            #print(tag)


        if "PASS" in myline and "TPASS" not in myline and "TINFO" not in myline:
            test = myline.split(":")[0].strip('.c')
            #print(test)
            if test not in passed_tests_list:
                passed_tests_list.append(test)

        if "TPASS" in myline:
            #print(myline)
            test = myline.split(" ")[0]
            #print(test)
            if test not in passed_tests_list:
                 passed_tests_list.append(test)

        if myline.startswith("passed"):
            #print(myline)
            num1 = myline.split(" ")[3]
            #print (num)
            count_passed+= int(num1)
        if myline.startswith("failed"):
            #print(myline)
            num2 = myline.split(" ")[3]
            #print (num)
            count_failed+= int(num2)


skip_tests = set(all_tests_list) - set(passed_tests_list)
f = open("skip_test_new.txt", "w")

for word in skip_tests:
    f.write(word+"\n")

f.close()
#print("Test list: ", set(all_tests_list) - set(passed_tests_list))
print("Length: ", len(all_tests_list))

print("Length: ", len(passed_tests_list))
print("Passed: ", count_passed)
print("Failed: ", count_failed)
print("Total tests", count_failed+count_passed)
#for element in mylines:
 #   print(element)
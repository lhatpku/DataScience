import os
import csv

election_csv = os.path.join("Resources","election_data.csv")

# --------------------- Data Input to Dictionary -----------------
with open(election_csv,newline='') as election_file:
    election_reader = csv.reader(election_file, delimiter=',')
    election_header = next(election_reader,None)
    election_item_length = len(election_header)
    # Initialize the budget_data dataset, assuming not knowing how many columns in the datafile
    election_data = [[] for col in range(election_item_length)]
    # Read through each row. attend data into budget_data
    for row in election_reader:
        for col in range(election_item_length):
            election_data[col].append(row[col])

election_data_dict = dict(zip(election_header,election_data))

# ---------------------- Data Analysis ----------------------------
total_votes = len(election_data_dict["Voter ID"])
candidate_name = set(election_data_dict["Candidate"])
candidate_votes_count = []
candidate_votes_percent = []
for candidate in candidate_name:
    candidate_votes_index = [1 if (vote == candidate) else 0 for vote in election_data_dict["Candidate"]]
    candidate_votes_count.append(sum(candidate_votes_index))
    candidate_votes_percent.append(round(sum(candidate_votes_index)/len(candidate_votes_index)*100,3))

candidate_votes_summary = list(zip(candidate_name,candidate_votes_percent,candidate_votes_count))
candidate_votes_summary.sort(reverse = True, key = lambda summary_list : summary_list[2])
# ---------------------- Data Output -----------------------------
print ("Election Results")
print ("------------------------------------------")
print (f"Total Votes: {total_votes}")
print ("------------------------------------------")
for i in range(len(candidate_name)):
    print(f"{candidate_votes_summary[i][0]}: {candidate_votes_summary[i][1]}% ({candidate_votes_summary[i][2]})")
print ("------------------------------------------")
print (f"Winner: {candidate_votes_summary[0][0]}")
print ("------------------------------------------")

## ----------------------- Terminal Outputs --------------------------
# Election Results
# ------------------------------------------
# Total Votes: 3521001
# ------------------------------------------
# Khan: 63.0% (2218231)
# Correy: 20.0% (704200)
# Li: 14.0% (492940)
# O'Tooley: 3.0% (105630)
# ------------------------------------------
# Winner: Khan
# ------------------------------------------









import os
import csv

budget_bank_csv = os.path.join("Resources","budget_data.csv")

# --------------------- Data Input to Dictionary -----------------
with open(budget_bank_csv,newline='') as budget_bank_file:
    budget_bank_reader = csv.reader(budget_bank_file, delimiter=',')
    budget_header = next(budget_bank_reader,None)
    budget_item_length = len(budget_header)
    # Initialize the budget_data dataset, assuming not knowing how many columns in the datafile
    budget_data = [[] for col in range(budget_item_length)]
    # Read through each row. attend data into budget_data
    for row in budget_bank_reader:
        for col in range(budget_item_length):
            if budget_header[col] == "Profit/Losses":
                budget_data[col].append(float(row[col]))
            else: 
                budget_data[col].append(row[col])
    
budget_data_dict = dict(zip(budget_header,budget_data))

# ---------------------- Data Analysis ----------------------------
# Output total months
budget_date = budget_data_dict["Date"]
total_months = len(set(budget_date))
# Output total annual profit & losses
total_profit_loss = round(sum(budget_data_dict["Profit/Losses"]))
# Average Change
budget_profit_loss = budget_data_dict["Profit/Losses"]
budget_monthly_change = [budget_profit_loss[data]-budget_profit_loss[data-1] for data in range(1,len(budget_profit_loss))]
budget_average_change = round(sum(budget_monthly_change) / len(budget_monthly_change),2)
# Greatest Increase
budget_great_change_amount = max(budget_monthly_change)
budget_great_change_pos = budget_monthly_change.index(budget_great_change_amount)
budget_great_change_month = budget_date[1:][budget_great_change_pos]
# Greatest Decrease
budget_worst_change_amount = min(budget_monthly_change)
budget_worst_change_pos = budget_monthly_change.index(budget_worst_change_amount)
budget_worst_change_month = budget_date[1:][budget_worst_change_pos]

# ---------------------- Data Output -----------------------------
print ("Financial Analysis")
print ("------------------------------------------")
print (f"Total Months: {total_months}")
print (f"Total: ${total_profit_loss}")
print (f"Average Change: ${budget_average_change}")
print (f"Greatest Increase in Profits: {budget_great_change_month} (${round(budget_great_change_amount)})")
print (f"Greatest Decrease in Profits: {budget_worst_change_month} (${round(budget_worst_change_amount)})")

## ---------------------- Output in the Terminal -------------------
# Financial Analysis
# ------------------------------------------
# Total Months: 86
# Total: $38382578
# Average Change: $-2315.12
# Greatest Increase in Profits: Feb-2012 ($1926159)
# Greatest Decrease in Profits: Sep-2013 ($-2196167)

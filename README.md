# SharkSzn
An exploratory analysis on shark attacks in the USA <br>
To view the finished dashboard [click here](https://public.tableau.com/app/profile/marissa.nash/viz/SharkAttacks_17225411482070/Dashboard1)

### Data Source ###
The orginal data source came from [Kaggle](https://www.kaggle.com/datasets/teajay/global-shark-attacks) and was collected by the [Global Shark Attack File](https://www.sharkattackfile.net/index.htm)

### Scope of Work ###
**Deliverables**
- A visualization of shark attacks in Tableau
- A semi-clean dataset cleaned in MySQL

**Goal**

The goal of this project is to analyze shark attacks for trends and patterns. Sharks are commonly feared amongst Americans and discovering which Shark species find themselves involved in the most shark attacks and what areas of the USA see the most shark attacks is of interest. Potential use cases for this are:
- How many attacks are provoked versus unprovoked?
- What time of year do we see most shark attacks?
- What species of shark are most involved in shark attacks?
- How many of these attacks were fatal?

### Data Set Transformations ###

| Data issue  | Solution |
| ------------- | ------------- |
| Duplicate entries | Created a row_num column to identify and remove duplicates  |
| Whitespace in Date attribute | Used TRIM function|
| Whitespace in Country attribute | Used TRIM function|
| Standardization issue in activity (Boat, boating, boatomg) | Updated data to reflect boating for all 3 |
| Whitespace in Area | Used TRIM function |
| Whitespace in Sex | Used TRIM function |
| Invalid entry in Sex, "lli"| Investigated and corrected to "M"|
| Whitespace in Species | Used TRIM function|
| Standardization issue in Species (Lots of extra text) | Standardized Species into 31 different Species including "Not Shark" and "Unknown"|
| Standardization issue in Date (Various formats) | Changed date to season due to presence of months |
| Non-relevant countries increased data numerosity| Removed all countries != USA |
| Nulls & Empty Strings in several attributes | Removed all rows with nulls and empties |
| Nulls & Empties in Species | updated to Unknown |
| Standardization issue in Fatal (Y/N) (Unknown) | Removed all rows with Unknown |
| Standardization issue in Area (North & South Carolina) | Removed all rows with "North & South Carolina"|
| Standardization issue in Season (non-conforming dates from earlier) | Removed all rows not labeled "Spring, Summer, Fall, or Winter"|
| Reduced Dimensionality of dataset to only necessary attributes | Used DROP Column function|
| Species had a persistent ' ' | Updated rows with ' ' to Unknown|


**Data Opportunities** <br>
There are opportunities to Parse the text into appropriate categories under Activity and Injury, but that is beyond my abilities.

**Finished Product** <br>
To view the finished dashboard [click here](https://public.tableau.com/app/profile/marissa.nash/viz/SharkAttacks_17225411482070/Dashboard1)

**Reflection** <br>
I've taken this very dirty dataset and turned it into usable data. I met all of the proposed use cases through my dashboard. I love that the source data provided the opportunity to work with shark species and finding which ones were involved with what type of incidents was very interesting and unique for me. In the end there were over 30 different standardizations that needed to be done to the Species data alone and that was a great exercise for me. I am much more comfortable using MYSQL now and I understand the capabilities of Tableau better. I wish I knew how to formulate Maps better as they were featured heavily in this data. I look forward to seeing how my skills improve to create a better visualization in the future. 

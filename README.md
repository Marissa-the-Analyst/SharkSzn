# SharkSzn
An exploratory analysis on shark attacks in the USA

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


**Data Opportunities**
There are opportunities to Parse the text into appropriate categories under Activity and Injury, but that is beyond my abilities.

**Finished Product**


**Reflection**

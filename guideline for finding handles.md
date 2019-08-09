Building Academic Networks Dataset: A Code Guide to Identifying Faculty Twitter Accounts

V1. screenName 

screenName is the username of the Twitter account. The format is the username with no @. 

Instructions:

    1. Search for the name with and without the middle name under "People" tab of Twitter's own search tool

    2. If multiple accounts appear, check each of them to see whether it is the person who are looking for. 
       a. Pay attention to whether this person follows any sociologists or sociology departments/journals and whether this person tweeted anything sociological. 
       b. The accounts following this person can also give you a hint, but do not confirm a match solely based on that, because sociologists may mistakenly follow someone whose account looks like their friend's. 
       c. If still uncertain, try to see whether the profile photo somehow match the person's photo on the departmental website.

    3. If no account pops up, search under "Top" tab using name+sociology and name+school name to see if someone has tweeted to the faculty of interest. 
    
    4. Once we identify the faculty's twitter account, copy-paste the screenname (next to @) under the display name.
    
V2. identified

identified is a categorical variable to indicate how sure we are about the coding of screenName.
    
    1 Know for sure this person has Twitter;
    0 Know for sure doesn’t;
    NA Can’t be sure, need to revisit this case.

V3. private.account

private.account is a dummy variable to indicate if the Twitter account is public or private.

    1 private account (you can see a lock next to th display name)
    0 public account



preliminary criterion for determining whether the account matches the person:

1. this account has a description that clearly says the person's identity. 2. this account follows at least 1 sociologist 3. this account follows the account of the person's univeristy 4. this account follows the account of the person's department 5. this account has a profile photo that matches the person 6. this account has tweeted sociological stuff. 7. there are more than 3 sociologists following this account. 

If any of these 7 is met, then the account is identifed to belong to the person. If none is met, the the account is not.

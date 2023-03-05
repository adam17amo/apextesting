# Welcome to the Apex Testing Deep Dive Repository

Please follow these steps to recreate the code in your own org.

1. Clone this repository and navigate to that folder 
```
git clone https://github.com/adam17amo/apextesting.git
```
```
cd apextesting
```

2. Open the apextesting folder in your IDE

3. Create a new scratch org
```
sfdx force:org:create -f config/project-scratch-def.json --durationdays 30 -a **YOUR_ALIAS_HERE**
```

4. Run the following command to get scratch org username and populate queue with it 

- For Mac:
```
sfdx force:user:display --json | grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" > user.txt; sed -i '' "s/\usernameHere/$(cat user.txt)/g" force-app/main/default/queues/Temp_Queue.queue-meta.xml; rm user.txt
```
- The script will do the following
   - Get user data from scratch org
   - Write username to temp file
   - Replace text "usernameHere" with org username in Temp Queue file
   - Delete temp file

- For Windows:
   - Open the Temp_Queue file under force-app/main/default/queues
   - Replace the text `usernameHere` with your org's username
   - Run the following command to get the username if you don't have it
```
sfdx force:user:display
```

5. Push source to org, 
```
sfdx force:source:push
```

6. Set the Opportunity Data Model to Private

7. Assign the Permission Set
   ```
   sfdx force:user:permset:assign --permsetname Apex_Testing_Admin
   ```

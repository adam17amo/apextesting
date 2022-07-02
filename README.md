1. Clone this repo using `git clone https://github.com/adam17amo/apextesting.git`

2. Create a new scratch org
`sfdx force:org:create -f config/project-scratch-def.json --durationdays 30 -a **YOUR_ALIAS_HERE**`

// Get user data from scratch org

// Write username to temp file

// Replace text with username in Queue file

// Delete temp file

3. Run the following command to get scratch org username and populate queue with it `sfdx force:user:display --json | grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" > user.txt; sed -i '' "s/\usernameHere/$(cat user.txt)/g" force-app/main/default/queues/Temp_Queue.queue-meta.xml; rm user.txt`

4. Push source to org, `sfdx force:source:push`

5. Set the Opportunity Data Model to Private

6. Assign the Permission Set
   `sfdx force:user:permset:assign --permsetname Apex_Testing_Admin`

1. Run the following command to get scratch org username and populate queue with it sfdx force:user:display --json | grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" > user.txt; sed -i '' "s/\usernameHere/$(cat user.txt)/g" force-app/main/default/queues/Temp_Queue.queue-meta.xml; rm user.txt
// Get user data from scratch org
// Write username to temp file
// Replace text with username in Queue file
// Delete temp file

2. Push source to org, sfdx force:source:push

3. Set the Opportunity Data Model to Private

4. Assign the Permission Set
   sfdx force:user:permset:assign --permsetname Apex_Testing_Admin

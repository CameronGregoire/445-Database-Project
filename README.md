# 445-Database-Project
Java program to insert/read data from an SQL database.
By: Nickolas Zahos, Cameron Gregoire
Project Group #13

## Preface and Pre-requisites
For our program we chose to usethe 'JDBC' API to run the conncetion between our program and the actual database.

We will assume you are running on a Windows machine, and have downloaded Microsoft SQL Server 2022.
We will also assume you have ran our 'Library DB TOTAL.sql' in Microsoft SQL Server Management Studio which creates the database, enters data, and runs some test queries.
We will assume you also have this data base (named LibraryDB) currently up and running before running our java program.

If the computer you are running this program on has not been setup for JDBC drivers, you will need to do the following:
1. Clone our repository or download the project manually.
2. Find the file in the /lib/ folder called 'mssql-jdbc_auth-12.2.0.x64.dll'
3. Right click this .dll file and open it's folder location in Windows file exporer (this is done differently depending on your IDE).
4. From the folder that this .dll is in, copy the exact path/address of the folder.
    - For example, mine was at: C:\445-Database-Project\445-Database-Project\lib
5. In your windows search bar type 'View Advanced System Settings', and select that option when you see it.
6. You will now have a new window, and be in the 'Advanced' tab. At the bottom click 'Environment Variables'.
7. From this new popup, the top list is user variables, but we want the bottom list called 'System variables'.
8. In 'System variables' find the entry named 'Path', select it and click 'Edit'.
9. From this new popup, you will click 'New' and paste that folder's path that we copied earlier.
10. Now save everything by pressing 'Ok' on each window we previously came from.

Now if you have not already enabled TCP/IP protocol mode for your SQL Server service, we will need to do that next or you will not be able to connect to the database locally:
1. Press Windows key + R and type SQLServerManager16.msc and hit enter. 
    - If it fails to find the app, then you may have a different version of Microsoft SQL Server downloaded than us (we are using the 2022 version).
2. In this new window, you need to find the node on the left tree list named 'SQL Server Network Configuration' and expand it.
    - You may see duplicate entries of this but with a (x32) at the end for example. Ours was just simply 'SQL Server Network Configuration' with no other text on it.
3. Once expanded, click the child node named "Protocols for MSSQLSERVER". This should popup some details on the right panel.
4. If TCP/IP statu says 'Disabled' then right click it and press 'Enable'. Then close out of this SQL Server Configuration Manager window.
5. Go to our 'LibraryDB' in Micrsoft SQL Server Management Studio and right click the top most parent (server), and select 'Restart'.
6. Once restarted, be sure to close and IDE you have previously open and reopen it to register all these new changes into it.

You should now be ready to run our code on the datanbase locally on your machine.

## How to run the code
1. In your IDE, select the 'Driver.java' class in the /driver/ folder and run that class.
2. You should now see our program popup with various buttons to select for different queries.

## How to run the queries correctly
Assuming you have the program now up and running:
### Function 1: Get a list of books by given book name, author name, book genre, rating, or publisher.
1. Select the first button 'Search for a Book'.
2. Enter '1984' for book name. You will see a single book's details display for the book with that name.
3. Enter nothing for the fields and hit enter, you will get a message that no books were found.


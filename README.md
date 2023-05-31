# 445-Database-Project
Java program to insert/read data from an SQL database.
By: Nickolas Zahos, Cameron Gregoire
Project Group #13

## Preface and Pre-requisites
For our program we chose to usethe 'JDBC' API to run the conncetion between our program and the actual database.

We will assume you are running on a Windows machine, and have downloaded Microsoft SQL Server 2022.
We will also assume you have ran our 'Library DB TOTAL.sql' in Microsoft SQL Server Management Studio which creates the database, enters data, and runs some test queries.
We will assume you also have this data base (named LibraryDB) currently up and running before running our java program.
We will also assume you know how to correctly add the JDBC.jar driver we included into your IDE's project classpath if it does not auto-recognize our .classpath file included.

If the computer you are running this program on has not been setup for JDBC drivers, you will need to do the following:
1. Clone our repository or download the project manually into an IDE of your choice (we recommend VS Code as it is what we used for this project).
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

## How to run the program's queries/functions
Assuming you have the program now up and running:

### Function 1: Get a list of books by given book name, author name, book genre, rating, or publisher.
1. Select the first button 'Search for a Book...'.
2. Enter '1984' for book name. You will see a single book's details display for the book with that name.
3. Enter nothing for the fields and hit enter, you will get a message that no books were found.
4. Play with the fields, leave some empty or be very specific. 
    - Be sure to check our 'Library DB TOTAL.sql' script in /SQL Scripts/ for our data entries for each table if you wish to mess around with our existing data.

### Function 2: Check the availability of a book given a specified LibraryID (int value).
You will see the term 'LibraryID' throughout the program, this refers to the different locations this library app manages.
There are 5 possible LibraryIDs (1-5). The libraries are only assigned IDs and not names for convinience of the demo.
1. If still in the previous function's submenu then press the 'Back' button at the bottom to get back to the main menu of our app.
2. Select the 'Check Availability of a Book...' button.
3. For book name type 'How to Poop', and LibraryID type '1'. You will see it show how much stock is available at LibraryID 1.
4. You can type other library ids and see which ones currently carry the book.
5. You can play with the data from our SQL script to create more test cases.

### Function 3: Check if (when and where/date and LibraryID) there are any upcoming shipments of a specified book name.
1. Go back to the main menu if not already.
2. Select the button 'Find a Book's Shipment Dates...'
3. Here you can search for upcoming scheduled shipments that are coming and which libraries they are arriving at.
    - This is useful for users who are waiting for a popular book to restock.
4. Not all book have upcoming shipments, if you type 'How to Poop' it will say there are none upcoming.
5. If you type '1984' for the book name you will see one upcoming shipment's info.
6. Play around with other data inserted from the SQL script if you wish to do so.

### Function 4: Purchase a membership with this library franchise.
1. Go back to the main menu if not already.
2. Select the button 'Purchase a Library Membership...'
3. Here you enter the customer name of the person who wishes to buy the membership. Enter 'Jane Smith'.
4. Press the purchase button and you will be able to see Jane's new memebership id number.
    - This program does not account for existing members buying a new membership as it is just a demo.
6. Play around with other data inserted from the SQL script if you wish to do so.

### Function 5: Check for upcoming events at specified libraries using a given LibraryID.
1. Go back to the main menu if not already.
2. Select the button 'Check for Events...'
3. Simply enter a LibraryID 1-5 to see all those libraries' event listings.
4. Try entering LibraryID 6 or more to see what message you get when a library would have no event listings.

### Function 6: Get a list of ALL incoming/upcoming shipments at a given LibraryID.
1. Go back to the main menu if not already.
2. Select the button 'Check all Incoming Shipments...'
    - This function is useful for employees keeping track of the upcoming shipments to the specified LibraryID.
3. Enter any of the existing library ids 1-5 to check what incoming shipmeents they are expecting.
4. Type library id of '6' or more to see what it would say when a library would have no incoming shipments.

### Function 7: Register with the library (as a new Customer) given a customer name, state name, City name, zip code, email, and phone number.
1. Go back to the main menu if not already.
2. Select the button 'Register as a New Customer...'
    - This page will let the user enter their info to register as a new customer in our library database.
    - It is VERY strict about the address info you enter here, as our database only tracks members that live in Washington state with a city name that is registered in our DB's 'CITY' table. Also the Zip code must match with the city we tied it to in the database, so be sure to follow the instructions on this one carefully.
3. For 'Customer Name' enter Bob Anderson.
4. For 'State' enter Washington.
5. For 'City' enter Puyallup.
6. For 'Zip Code' enter 98101.
    - Note that zip/city/state combos stored in our database may not be accurate as it is just sample data.
7. Enter any fake email you want for 'Email', same with 'Phone'.
8. Press the register button.
    - If any errors poped up then you probably entered an incorrect combo for state/city/zip.
9. Try registering the same exact customer name and address, you wll notice that it does not allow duplicate names at the same address.


package view;

import javax.swing.*;
import javax.swing.border.EmptyBorder;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * This class is the UI class for the main page of the program.
 * It will hold buttons for the user to decide which kind of query they wish to perform
 * on the attached library database.
 * 
 * The user should be able to choose to do any of the following from this screen:
 * 1) Get a list of books by given book name, author name, book genre, rating (float value), or publisher.
 * 2) Check the availability of a book given a specified LibraryID (int value).
 * 3) Check if (when and where/date and LibraryID) there are any up coming shipments of a specified book name.
 * 4) Purchase a membership with this library franchise.
 * 5) Check for upcoming events at specified librarys using a given LibraryID.
 * 6) Get a list of ALL incoming/upcoming shipments at a given LibraryID.
 * 7) Register with the library (as a new Customer) given a customer name, state name, City name, zip code, email, and phone number.
 * 8) Update quantity of a book in a given library by a given book name, and quantity of change.
 * 9) Find the next billing cycle of a member given the MemberID (int value).
 * 10) Find how many people are currently subscribed for a membership with the library in a given zip code, city name, or state name.
 * 11) Get a list of the customers' name, state name, City name, zip code, email, and phone number of all customers with a given name.
 */
public class MainPage {
    /** 
     * The core JFrame of our main page. 
     * Needs to be static to be referenced in action listeners.
     * */
    protected static JFrame myFrame;

    /** The panel that holds the title of the page. */
    private JPanel myTitlePanel;

    /** The center panel of our frame, this will hold all the buttons the user can choose. */
    private JPanel myButtonPanel;

    public MainPage() {
        myFrame = new JFrame("Library Management System");
        myFrame.setSize(450, 600);
        myFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        myTitlePanel = new JPanel(new BorderLayout());
        myTitlePanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        myButtonPanel = new JPanel(new GridLayout(12, 1));
        myButtonPanel.setBorder(new EmptyBorder(10, 40, 0, 40));

        JLabel titleLabel = new JLabel("Library Management System", SwingConstants.CENTER);
        titleLabel.setFont(new Font("Arial", Font.BOLD, 24)); // Set the font, size, style of the title
        myTitlePanel.add(titleLabel, BorderLayout.CENTER);

        JButton button1 = new JButton("Search for a Book...");
        button1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                myFrame.setVisible(false);
                new SearchBookPage();
            }
        });
        
        JButton button2 = new JButton("Check Availability of a Book...");
        button2.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                myFrame.setVisible(false);
                new CheckAvailabilityPage();
            }
        });

        JButton button3 = new JButton("Find a Book's Shipment Dates...");
        button3.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                myFrame.setVisible(false);
                new CheckShipmentsPage();
            }
        });

        JButton button4 = new JButton("Purchase a Library Membership...");
        JButton button5 = new JButton("Check for Events...");
        JButton button6 = new JButton("Check all Incoming Shipments...");
        JButton button7 = new JButton("Register as a New Customer...");
        JButton button8 = new JButton("Update Book Quantity...");
        JButton button9 = new JButton("Find Next Billing Cycle...");
        JButton button10 = new JButton("Find all Current Members in a Location...");
        JButton button11 = new JButton("Get Customer Details...");

        myButtonPanel.add(button1);
        myButtonPanel.add(button2);
        myButtonPanel.add(button3);
        myButtonPanel.add(button4);
        myButtonPanel.add(button5);
        myButtonPanel.add(button6);
        myButtonPanel.add(button7);
        myButtonPanel.add(button8);
        myButtonPanel.add(button9);
        myButtonPanel.add(button10);
        myButtonPanel.add(button11);

        myFrame.add(myTitlePanel, BorderLayout.NORTH);
        myFrame.getContentPane().add(myButtonPanel, BorderLayout.CENTER);
        myFrame.setLocationRelativeTo(null); // Center the UI to the screen
        myFrame.setVisible(true);
    }
}

package view;

import javax.swing.*;
import javax.swing.border.EmptyBorder;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import java.sql.*;

/**
 * This class is responsible for handling the following:
 * Get a list of ALL incoming/upcoming shipments at a given LibraryID.
 */
public class CheckAllShipmentsPage {
    private static JFrame myFrame; // Frame for the GUI
    private JTextField libraryIDField; // Text field for entering the LibraryID
    private JTextArea resultArea; // Text area for displaying the query results

    /**
     * Constructor for the CheckAllShipmentsPage class.
     * Sets up the GUI components and event listeners.
     */
    public CheckAllShipmentsPage() {
        // Create the JFrame and set its properties
        myFrame = new JFrame("Check All Incoming Shipments");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        // Create a JPanel with a grid layout and border
        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        // Add a label and text field for the LibraryID
        myPanel.add(new JLabel("LibraryID (1-5): "));
        libraryIDField = new JTextField();
        myPanel.add(libraryIDField);

        // Add a button to check for incoming shipments
        JButton checkButton = new JButton("Check For All Incoming Shipments");
        myPanel.add(checkButton);
        checkButton.addActionListener(e -> {
            String libraryID = libraryIDField.getText();

            ResultSet result = null;
            if (!libraryID.isEmpty()) {
                result = checkForAllIncomingShipments(libraryID);
            }

            // Call a function to display the result in the resultArea
            displayResult(result);
        });

        // Add a back button to return to the main page
        JButton backButton = new JButton("Back");
        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                myFrame.dispose();
                MainPage.myFrame.setVisible(true);
            }
        });

        // Add a window listener to restore the main page when the JFrame is closed
        myFrame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                MainPage.myFrame.setVisible(true);
            }
        });

        // Create a text area for displaying the query results
        resultArea = new JTextArea();
        resultArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(resultArea);

        myFrame.add(myPanel, BorderLayout.NORTH);
        myFrame.add(scrollPane, BorderLayout.CENTER);
        myFrame.add(backButton, BorderLayout.SOUTH);

        myFrame.setLocationRelativeTo(null);
        myFrame.setVisible(true);
    }

    /**
     * Establishes a connection to the database.
     * @return the Connection object or null if an error occurs
     */
    public Connection getConnection() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=LibraryDB;integratedSecurity=true;trustServerCertificate=true;";
            Connection conn = DriverManager.getConnection(url);
            return conn;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }
  
    /**
     * Executes a query to retrieve all incoming shipments for the specified LibraryID.
     * @param libraryID the LibraryID to search for
     * @return the ResultSet containing the query results or null if an error occurs
     */
    public ResultSet checkForAllIncomingShipments(String libraryID) {
        String query = "SELECT * FROM SHIPMENT WHERE LibraryID = ?";
        try {
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, libraryID);
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    /**
     * Displays the query results in the resultArea.
     * @param result the ResultSet containing the query results
     */
    public void displayResult(ResultSet result) {
        StringBuilder resultText = new StringBuilder("Results:\n");
        try {
            ResultSetMetaData metaData = result.getMetaData();
            int columnCount = metaData.getColumnCount();

            if (result != null && result.next()) {
                do {
                    for (int i = 1; i <= columnCount; i++) {
                        String columnName = metaData.getColumnName(i);
                        String columnValue = result.getString(i);
                        resultText.append(columnName).append(": ").append(columnValue).append("\n");
                    }
                    resultText.append("\n");
                } while (result.next());
            } else {
                resultText.append("No incoming shipments found for the specified library ID.\n");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        resultArea.setFont(new Font("Courier New", Font.PLAIN, 12));
        resultArea.setText(resultText.toString());
    }

    // Main method for testing the CheckAllShipmentsPage class
    public static void main(String[] args) {
        new CheckAllShipmentsPage();
    }
}


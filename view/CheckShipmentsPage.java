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
 * The CheckShipmentsPage class is responsible for handling the following:
 * Check if (when and where/date and LibraryID) there are any upcoming shipments of a specified book name.
 */
public class CheckShipmentsPage {
    private static JFrame myFrame;
    private JTextField nameField;
    private JTextArea resultArea;

    /**
     * Constructs a CheckShipmentsPage object and initializes the graphical user interface.
     * This includes creating the main frame, adding components, and setting up event listeners.
     */
    public CheckShipmentsPage() {
        // Create the main frame
        myFrame = new JFrame("Check for Upcoming Shipments");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        // Create the panel to hold components
        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        // Add book name label and text field to the panel
        myPanel.add(new JLabel("Book Name: "));
        nameField = new JTextField();
        myPanel.add(nameField);

        // Add check button to the panel
        JButton checkButton = new JButton("Check For Book's Shipments");
        myPanel.add(checkButton);
        checkButton.addActionListener(e -> {
            String bookName = nameField.getText();

            ResultSet result = null;
            if (!bookName.isEmpty()) {
                result = getUpcomingShipmentsOfBookName(bookName);
            }

            // Call a function to display the result in resultArea
            displayResult(result);
        });

        // Create the back button to return to the main page
        JButton backButton = new JButton("Back");
        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                myFrame.dispose();
                MainPage.myFrame.setVisible(true);
            }
        });

        // Make sure that if the user clicks the 'X', the main page is restored
        myFrame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                MainPage.myFrame.setVisible(true);
            }
        });

        // Create the text area to display results
        resultArea = new JTextArea();
        resultArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(resultArea);

        // Add components to the frame
        myFrame.add(myPanel, BorderLayout.NORTH);
        myFrame.add(scrollPane, BorderLayout.CENTER);
        myFrame.add(backButton, BorderLayout.SOUTH);

        myFrame.setLocationRelativeTo(null);
        myFrame.setVisible(true);
    }

    /**
     * Establishes a connection to the database.
     *
     * @return the Connection object if the connection is successful, or null otherwise.
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
     * Retrieves upcoming shipments for a given book name from the database.
     *
     * @param bookName the name of the book to check for upcoming shipments.
     * @return the ResultSet containing the shipment details if the query is successful, or null otherwise.
     */
    public ResultSet getUpcomingShipmentsOfBookName(String bookName) {
        String query = "SELECT SHIPMENT.ShipmentID, SHIPMENT.ShipDate, SHIPMENT.Description, LIBRARY.LibraryID " +
                "FROM SHIPMENT " +
                "INNER JOIN LIBRARY ON SHIPMENT.LibraryID = LIBRARY.LibraryID " +
                "WHERE SHIPMENT.Description LIKE ? AND CONVERT(DATE, SHIPMENT.ShipDate, 120) >= CONVERT(DATE, GETDATE(), 120)";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, "%" + bookName + "%");
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    /**
     * Displays the result in the resultArea.
     *
     * @param result the ResultSet containing the shipment details to display.
     */
    public void displayResult(ResultSet result) {
        StringBuilder resultText = new StringBuilder("Results:\n");
        try {
            if (!result.isBeforeFirst()) {
                resultText.append("No upcoming shipments for the specified book were found.");
            } else {
                while (result.next()) {
                    int shipmentID = result.getInt("ShipmentID");
                    String shipDate = result.getString("ShipDate");
                    String description = result.getString("Description");
                    int libraryID = result.getInt("LibraryID");

                    String line = "Shipment ID: " + shipmentID + "\n";
                    line += "Shipment Date: " + shipDate + "\n";
                    line += "Description: " + description + "\n";
                    line += "Library ID: " + libraryID + "\n";

                    resultText.append(line).append("\n");
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        resultArea.setFont(new Font("Courier New", Font.PLAIN, 12));
        resultArea.setText(resultText.toString());
    }
}


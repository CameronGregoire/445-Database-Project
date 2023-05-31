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
 * This class represents a graphical user interface for checking the availability of a book in a library system.
 * It provides a form where the user can enter the book name and library ID to perform the availability check.
 * The results are displayed in a text area.
 */
public class CheckAvailabilityPage {
    private static JFrame myFrame;
    private JTextField nameField, libraryField;
    private JTextArea resultArea;

    /**
     * Constructs a new CheckAvailabilityPage object and initializes the GUI components.
     */
    public CheckAvailabilityPage() {
        // Create the main frame
        myFrame = new JFrame("Check Availability");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        // Create a panel with a grid layout and set border
        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        // Add a label and text field for book name
        myPanel.add(new JLabel("Book Name: "));
        nameField = new JTextField();
        myPanel.add(nameField);

        // Add a label and text field for library ID
        myPanel.add(new JLabel("LibraryID (1-5): "));
        libraryField = new JTextField();
        myPanel.add(libraryField);

        // Add a button to check availability
        JButton checkButton = new JButton("Check Availability");
        myPanel.add(checkButton);
        checkButton.addActionListener(e -> {
            // Retrieve input values from text fields
            String bookName = nameField.getText();
            String libraryID = libraryField.getText();

            ResultSet result = null;
            if (!bookName.isEmpty() && !libraryID.isEmpty()) {
                // Perform the availability check in the database
                result = getAvailabilityByBookNameAndLibraryID(bookName, libraryID);
            } else if (libraryID.isEmpty() || bookName.isEmpty()) {
                // Display an error message if no data is entered
                displayResultNoDataEntered();
                return;
            }

            // Call a function to display the result in resultArea
            displayResult(result);
        });

        // Add a back button to return to the main page
        JButton backButton = new JButton("Back");
        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                // Close the current frame and show the main page frame
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

        // Create a text area for displaying the result
        resultArea = new JTextArea();
        resultArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(resultArea);

        // Add components to the frame
        myFrame.add(myPanel, BorderLayout.NORTH);
        myFrame.add(scrollPane, BorderLayout.CENTER);
        myFrame.add(backButton, BorderLayout.SOUTH);

        // Set the frame location and make it visible
        myFrame.setLocationRelativeTo(null);
        myFrame.setVisible(true);
    }

    /**
     * Establishes a database connection.
     *
     * @return the Connection object representing the database connection, or null if an error occurs.
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
     * Retrieves availability information from the database based on the book name and library ID.
     *
     * @param bookName   the name of the book
     * @param libraryID  the ID of the library
     * @return a ResultSet object containing the availability information, or null if an error occurs.
     */
    public ResultSet getAvailabilityByBookNameAndLibraryID(String bookName, String libraryID) {
        String query = "SELECT BOOK.BookName, AVAILABILITY.LibraryID, AVAILABILITY.Quantity " +
                "FROM BOOK " +
                "INNER JOIN AVAILABILITY ON BOOK.BookID = AVAILABILITY.BookID " +
                "INNER JOIN LIBRARY ON AVAILABILITY.LibraryID = LIBRARY.LibraryID " +
                "WHERE BOOK.BookName = ? AND AVAILABILITY.LibraryID = ?";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, bookName);
            stmt.setString(2, libraryID);
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    /**
     * Displays the result in the resultArea text area.
     *
     * @param result the ResultSet containing the result data to be displayed.
     */
    public void displayResult(ResultSet result) {
        StringBuilder resultText = new StringBuilder("Results:\n");
        try {
            boolean bookAvailable = false;
            ResultSetMetaData metaData = result.getMetaData();
            int columnCount = metaData.getColumnCount();

            while (result != null && result.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = metaData.getColumnLabel(i);
                    String value = result.getString(i);
                    resultText.append(columnName).append(": ").append(value).append("\n");
                }
                bookAvailable = true;
                resultText.append("\n");
            }

            if (!bookAvailable) {
                resultText.append("Book not available at the specified library.");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        resultArea.setFont(new Font("Courier New", Font.PLAIN, 12));
        resultArea.setText(resultText.toString());
    }

    /**
     * Displays a message in the resultArea text area when no data is entered.
     */
    public void displayResultNoDataEntered() {
        resultArea.setText("A field was left blank.");
    }
}


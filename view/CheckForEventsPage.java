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
 * Check for upcoming events at specified libraries using a given LibraryID.
 */
public class CheckForEventsPage {
    private static JFrame myFrame;
    private JTextField libraryField;
    private JTextArea resultArea;

    /**
     * Constructs a CheckForEventsPage object and initializes the GUI.
     */
    public CheckForEventsPage() {
        myFrame = new JFrame("Check for Events");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        // Add label and text field for entering the library ID
        myPanel.add(new JLabel("LibraryID (1-5): "));
        libraryField = new JTextField();
        myPanel.add(libraryField);

        JButton checkButton = new JButton("Check for Events");
        myPanel.add(checkButton);
        checkButton.addActionListener(e -> {
            String libraryID = libraryField.getText();
            ResultSet result = checkForEvents(libraryID);
            displayResult(result);
        });

        JButton backButton = new JButton("Back");
        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                myFrame.dispose();
                MainPage.myFrame.setVisible(true);
            }
        });

        myFrame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                MainPage.myFrame.setVisible(true);
            }
        });

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
     *
     * @return the connection object
     */
    public Connection getConnection() {
        try {
            // Connection URL for the database
            String url = "jdbc:sqlserver://localhost:1433;databaseName=LibraryDB;integratedSecurity=true;trustServerCertificate=true;";
            Connection conn = DriverManager.getConnection(url);
            return conn;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    /**
     * Retrieves upcoming events for the specified library from the database.
     *
     * @param libraryID the ID of the library
     * @return a ResultSet containing the upcoming events
     */
    public ResultSet checkForEvents(String libraryID) {
        String query = "SELECT DateOfEvent as 'Event Date', EventName as 'Event Name', EventDescription as 'Description' " +
                "FROM EVENT " +
                "WHERE LibraryID = ?";

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
     * Displays the result set in the text area.
     *
     * @param result the result set to display
     */
    public void displayResult(ResultSet result) {
        StringBuilder resultText = new StringBuilder("Results:\n");
        try {
            if (result != null && result.next()) {
                resultText.append("Upcoming Events:\n");
                do {
                    String eventDate = result.getString("Event Date");
                    String eventName = result.getString("Event Name");
                    String eventDescription = result.getString("Description");

                    resultText.append("Event Date: ").append(eventDate).append("\n");
                    resultText.append("Event Name: ").append(eventName).append("\n");
                    resultText.append("Description: ").append(eventDescription).append("\n\n");
                } while (result.next());
            } else {
                resultText.append("No upcoming events at the specified library ID.\n");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        resultArea.setFont(new Font("Courier New", Font.PLAIN, 12));
        resultArea.setText(resultText.toString());
    }
}


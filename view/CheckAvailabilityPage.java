package view;

import javax.swing.*;
import javax.swing.border.EmptyBorder;

import java.awt.*;
import java.sql.*;

/**
 * This is the UI class that performs the following with our library database:
 * Check the availability of a book (given the book name) at a specified LibraryID (int value).
 * We are basically checking the availability of a book at the specified library.
 */
public class CheckAvailabilityPage {
    private static JFrame myFrame;
    private JTextField bookNameField, libraryIDField;
    private JTextArea resultArea;

    public CheckAvailabilityPage() {
        myFrame = new JFrame("Check Book Availability");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(400, 200);

        JPanel myPanel = new JPanel(new GridLayout(2, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        myPanel.add(new JLabel("Book Name: "));
        bookNameField = new JTextField();
        myPanel.add(bookNameField);

        myPanel.add(new JLabel("Library ID: "));
        libraryIDField = new JTextField();
        myPanel.add(libraryIDField);

        JButton searchButton = new JButton("Search");
        myPanel.add(searchButton);
        searchButton.addActionListener(e -> {
            String bookName = bookNameField.getText();
            int libraryID = Integer.parseInt(libraryIDField.getText());

            ResultSet result = getBookAvailability(bookName, libraryID);

            // Call a function to display the result in resultArea
            displayResult(result);
        });

        resultArea = new JTextArea();
        resultArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(resultArea);

        myFrame.add(myPanel, BorderLayout.NORTH);
        myFrame.add(scrollPane, BorderLayout.CENTER);

        myFrame.setLocationRelativeTo(null);
        myFrame.setVisible(true);
    }

    public ResultSet getBookAvailability(String bookName, int libraryID) {
        String query = "SELECT BOOK.BookName as 'Book Name', LIBRARY_AVAILABILITY.Available as 'Availability' " +
                "FROM BOOK " +
                "INNER JOIN LIBRARY_AVAILABILITY ON LIBRARY_AVAILABILITY.BookID = BOOK.BookID " +
                "WHERE BOOK.BookName = ? AND LIBRARY_AVAILABILITY.LibraryID = ?";
        try {
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, bookName);
            stmt.setInt(2, libraryID);
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    public Connection getConnection() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=LibraryDB;integratedSecurity=true";
            Connection conn = DriverManager.getConnection(url);
            return conn;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    public void displayResult(ResultSet result) {
        try {
            if (result != null && result.next()) {
                String bookName = result.getString("Book Name");
                boolean availability = result.getBoolean("Availability");

                String availabilityText = availability ? "Available" : "Not Available";
                String resultText = "Book: " + bookName + "\nAvailability: " + availabilityText;

                resultArea.setText(resultText);
            } else {
                resultArea.setText("Book not found or library not available");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}

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
 * Get a list of books by given book name, author name, book genre, rating (float value), or publisher.
 */
public class CheckAvailabilityPage {
    private static JFrame myFrame;
    private JTextField nameField, libraryField;
    private JTextArea resultArea;

    public CheckAvailabilityPage() {
        myFrame = new JFrame("Search for a Book");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        myPanel.add(new JLabel("Book Name: "));
        nameField = new JTextField();
        myPanel.add(nameField);

        myPanel.add(new JLabel("LibraryID: "));
        libraryField = new JTextField();
        myPanel.add(libraryField);

        JButton checkButton = new JButton("Check Availability");
        myPanel.add(checkButton);
        checkButton.addActionListener(e -> {
            String bookName = nameField.getText();
            String libraryID = libraryField.getText();
            
            ResultSet result = null;
            if (!bookName.isEmpty() && !libraryID.isEmpty()) {
                result = getAvailabilityByBookNameAndLibraryID(bookName, libraryID);
            }

            // Call a function to display the result in resultArea
            displayResult(result);
        });
        // Back button to get back to the main page.
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

        resultArea = new JTextArea();
        resultArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(resultArea);

        myFrame.add(myPanel, BorderLayout.NORTH);
        myFrame.add(scrollPane, BorderLayout.CENTER);
        myFrame.add(backButton, BorderLayout.SOUTH);

        myFrame.setLocationRelativeTo(null);
        myFrame.setVisible(true);
    }

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
    
    public void displayResult(ResultSet result) {
        StringBuilder resultText = new StringBuilder("Results:\n");
        try {
            boolean bookAvailable = false;
    
            while (result != null && result.next()) {
                String bookName = result.getString("BookName");
                String libraryID = result.getString("LibraryID");
                int availableQuantity = result.getInt("Quantity");
    
                String line = bookName + " is available at Library ID " + libraryID + ". There are " + availableQuantity + " left in stock.";
                resultText.append(line).append("\n");
    
                bookAvailable = true;
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
}

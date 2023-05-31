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
 * Update quantity of a book in a given library by a given book name, and quantity of change.
 */
public class UpdateBookQuantityPage {
    private static JFrame myFrame;
    private JTextField libraryField, bookNameField, quantityChangeField;
    private JTextArea resultArea;

    public UpdateBookQuantityPage() {
        myFrame = new JFrame("Update Book Quantity");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        myPanel.add(new JLabel("LibraryID (1-5): "));
        libraryField = new JTextField();
        myPanel.add(libraryField);

        myPanel.add(new JLabel("Book Name: "));
        bookNameField = new JTextField();
        myPanel.add(bookNameField);

        myPanel.add(new JLabel("Quantity Change: "));
        quantityChangeField = new JTextField();
        myPanel.add(quantityChangeField);

        JButton updateButton = new JButton("Update Quantity");
        myPanel.add(updateButton);
        updateButton.addActionListener(e -> {
            String libraryID = libraryField.getText();
            String bookName = bookNameField.getText();
            String quantityChange = quantityChangeField.getText();

            ResultSet result = updateBookQuantity(libraryID, bookName, quantityChange);
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

    public ResultSet updateBookQuantity(String libraryID, String bookName, String quantityChange) {
        try {
            // Validate inputs
            int libraryIDInt = Integer.parseInt(libraryID);
            int quantityChangeInt = Integer.parseInt(quantityChange);
    
            // Check if the book is available at the given library ID
            String query = "SELECT * FROM AVAILABILITY WHERE LibraryID = ? AND BookID = (SELECT BookID FROM BOOK WHERE BookName = ?)";
            PreparedStatement statement = getConnection().prepareStatement(query);
            statement.setInt(1, libraryIDInt);
            statement.setString(2, bookName);
            ResultSet result = statement.executeQuery();
    
            if (!result.next()) {
                // Book not available at the given library ID
                result.close();
                statement.close();
                return null;
            }
    
            // Update the quantity of the book
            int currentQuantity = result.getInt("Quantity");
            int updatedQuantity = currentQuantity + quantityChangeInt;
    
            String updateQuery = "UPDATE AVAILABILITY SET Quantity = ? WHERE LibraryID = ? AND BookID = (SELECT BookID FROM BOOK WHERE BookName = ?)";
            PreparedStatement updateStatement = getConnection().prepareStatement(updateQuery);
            updateStatement.setInt(1, updatedQuantity);
            updateStatement.setInt(2, libraryIDInt);
            updateStatement.setString(3, bookName);
            updateStatement.executeUpdate();
    
            // Close the statements before retrieving the updated result
            statement.close();
            updateStatement.close();
    
            // Get the updated result after the update
            String updatedQuery = "SELECT * FROM AVAILABILITY WHERE LibraryID = ? AND BookID = (SELECT BookID FROM BOOK WHERE BookName = ?)";
            PreparedStatement updatedStatement = getConnection().prepareStatement(updatedQuery);
            updatedStatement.setInt(1, libraryIDInt);
            updatedStatement.setString(2, bookName);
            ResultSet updatedResult = updatedStatement.executeQuery();
    
            return updatedResult;
        } catch (NumberFormatException | SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }
    
    public void displayResult(ResultSet result) {
        if (result == null) {
            resultArea.setText("That LibraryID does not sell that book.");
        } else {
            try {
                resultArea.setText("Updated Quantity:\n\n");
                while (result.next()) {
                    int libraryID = result.getInt("LibraryID");
                    int bookID = result.getInt("BookID");
                    int quantity = result.getInt("Quantity");
    
                    // Retrieve the book name from the BOOK table using the book ID
                    String bookNameQuery = "SELECT BookName FROM BOOK WHERE BookID = ?";
                    PreparedStatement bookNameStatement = getConnection().prepareStatement(bookNameQuery);
                    bookNameStatement.setInt(1, bookID);
                    ResultSet bookNameResult = bookNameStatement.executeQuery();
    
                    if (bookNameResult.next()) {
                        String bookName = bookNameResult.getString("BookName");
                        resultArea.append("LibraryID: " + libraryID + "\n");
                        resultArea.append("Book Name: " + bookName + "\n");
                        resultArea.append("Quantity: " + quantity + "\n\n");
                    }
    
                    // Close the book name statement and result set
                    bookNameStatement.close();
                    bookNameResult.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}

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
public class SearchBookPage {
    private static JFrame myFrame;
    private JTextField nameField, authorField, genreField, ratingField, publisherField;
    private JTextArea resultArea;

    public SearchBookPage() {
        myFrame = new JFrame("Search for a Book");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        myPanel.add(new JLabel("Book Name: "));
        nameField = new JTextField();
        myPanel.add(nameField);

        myPanel.add(new JLabel("Author Name: "));
        authorField = new JTextField();
        myPanel.add(authorField);

        myPanel.add(new JLabel("Genre: "));
        genreField = new JTextField();
        myPanel.add(genreField);

        myPanel.add(new JLabel("Rating: "));
        ratingField = new JTextField();
        myPanel.add(ratingField);

        myPanel.add(new JLabel("Publisher: "));
        publisherField = new JTextField();
        myPanel.add(publisherField);

        JButton searchButton = new JButton("Search");
        myPanel.add(searchButton);
        searchButton.addActionListener(e -> {
            String bookName = nameField.getText();
            String authorName = authorField.getText();
            String genre = genreField.getText();
            String rating = ratingField.getText();
            String publisher = publisherField.getText();
            
            ResultSet result = null;
            if (!bookName.isEmpty()) {
                result = getBooksByName(bookName);
            } else if (!authorName.isEmpty()) {
                result = getBooksByAuthor(authorName);
            } else if (!genre.isEmpty()) {
                result = getBooksByGenre(genre);
            } else if (!rating.isEmpty()) {
                result = getBooksByRating(rating);
            } else if (!publisher.isEmpty()) {
                result = getBooksByPublisher(publisher);
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
    
    

    public ResultSet getBooksByName(String bookName) {
        String query = "SELECT BOOK.BookID, BOOK.BookName as 'Book Name', BOOK.PageCount as 'Page Count', " +
                       "BOOK.AuthorName as 'Author Name', PUBLISHER.PublisherName as 'Publisher Name' " +
                       "FROM BOOK INNER JOIN PUBLISHER ON PUBLISHER.PublisherID = BOOK.PublisherID " +
                       "WHERE BookName = ?";
        try {
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, bookName);
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    public ResultSet getBooksByAuthor(String authorName) {
        String query = "SELECT BOOK.BookID, BOOK.BookName as 'Book Name', BOOK.PageCount as 'Page Count', " +
                       "BOOK.AuthorName as 'Author Name', PUBLISHER.PublisherName as 'Publisher Name' " +
                       "FROM BOOK INNER JOIN PUBLISHER ON PUBLISHER.PublisherID = BOOK.PublisherID " +
                       "WHERE AuthorName = ?";
        try {
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, authorName);
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }
    
    public ResultSet getBooksByGenre(String genre) {
        String query = "SELECT BOOK.BookID, BOOK.BookName as 'Book Name', BOOK.PageCount as 'Page Count', " +
                       "BOOK.AuthorName as 'Author Name', PUBLISHER.PublisherName as 'Publisher Name' " +
                       "FROM BOOK INNER JOIN PUBLISHER ON PUBLISHER.PublisherID = BOOK.PublisherID " +
                       "WHERE Genre = ?";
        try {
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, genre);
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }
    
    public ResultSet getBooksByRating(String rating) {
        String query = "SELECT BOOK.BookID, BOOK.BookName as 'Book Name', BOOK.PageCount as 'Page Count', " +
                       "BOOK.AuthorName as 'Author Name', PUBLISHER.PublisherName as 'Publisher Name', REVIEW.Rating as 'Rating' " +
                       "FROM BOOK " +
                       "INNER JOIN PUBLISHER ON PUBLISHER.PublisherID = BOOK.PublisherID " +
                       "INNER JOIN REVIEW ON REVIEW.BookID = BOOK.BookID " +
                       "WHERE REVIEW.Rating = ?";
        try {
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(rating));
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }
    
    
    public ResultSet getBooksByPublisher(String publisherName) {
        String query = "SELECT BOOK.BookID, BOOK.BookName as 'Book Name', BOOK.PageCount as 'Page Count', " +
                       "BOOK.AuthorName as 'Author Name', PUBLISHER.PublisherName as 'Publisher Name' " +
                       "FROM BOOK INNER JOIN PUBLISHER ON PUBLISHER.PublisherID = BOOK.PublisherID " +
                       "WHERE PublisherName = ?";
        try {
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, publisherName);
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }    

    public void displayResult(ResultSet result) {
        StringBuilder resultText = new StringBuilder("Results:\n");
        try {
            while (result != null && result.next()) {
                // You may need to adjust this based on the result structure of your SQL queries
                String line = result.getString("Book Name") + " - " + result.getString("Author Name");
                resultText.append(line).append("\n");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        resultArea.setText(resultText.toString());
    }
    
}

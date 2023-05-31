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
 * Get a list of books by given book name, author name, book genre, rating, or publisher.
 */
public class SearchBookPage {
    private static JFrame myFrame;
    private JTextField nameField, authorField, genreField, ratingField, publisherField;
    private JTextArea resultArea;

    public SearchBookPage() {
        // Create and configure the JFrame
        myFrame = new JFrame("Search for a Book");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        // Create the main panel with a grid layout
        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        // Add labels and text fields for user input
        myPanel.add(new JLabel("Book Name Contains: "));
        nameField = new JTextField();
        myPanel.add(nameField);

        myPanel.add(new JLabel("Author Name Contains: "));
        authorField = new JTextField();
        myPanel.add(authorField);

        myPanel.add(new JLabel("Genre Name"));
        genreField = new JTextField();
        myPanel.add(genreField);

        myPanel.add(new JLabel("Rating (0-5 stars): "));
        ratingField = new JTextField();
        myPanel.add(ratingField);

        myPanel.add(new JLabel("Publisher Contains: "));
        publisherField = new JTextField();
        myPanel.add(publisherField);

        // Add a search button
        JButton searchButton = new JButton("Search for Books");
        myPanel.add(searchButton);
        searchButton.addActionListener(e -> {
            // Retrieve input values from text fields
            String bookName = nameField.getText();
            String authorName = authorField.getText();
            String genre = genreField.getText();
            String rating = ratingField.getText();
            String publisher = publisherField.getText();

            ResultSet result = null;
            if (!bookName.isEmpty() || !authorName.isEmpty() || !genre.isEmpty() || !rating.isEmpty() || !publisher.isEmpty()) {
                result = getBook(bookName, authorName, genre, rating, publisher);
            }

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

        // Configure the main frame
        myFrame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                MainPage.myFrame.setVisible(true);
            }
        });

        // Create a text area to display the search results
        resultArea = new JTextArea();
        resultArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(resultArea);

        // Add components to the main frame
        myFrame.add(myPanel, BorderLayout.NORTH);
        myFrame.add(scrollPane, BorderLayout.CENTER);
        myFrame.add(backButton, BorderLayout.SOUTH);

        myFrame.setLocationRelativeTo(null);
        myFrame.setVisible(true);
    }

    // Establish a connection to the database
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

    // Retrieve a list of books based on the search criteria
    public ResultSet getBook(String bookName, String authorName, String genre, String rating, String publisher) {
        try {
            Connection conn = getConnection();
            Statement stmt = conn.createStatement();

            String query = "SELECT B.* FROM BOOK B";

            if (!bookName.isEmpty() || !authorName.isEmpty() || !genre.isEmpty() || !rating.isEmpty() || !publisher.isEmpty()) {
                query += " INNER JOIN AVAILABILITY A ON B.BookID = A.BookID";
                query += " INNER JOIN LIBRARY_SECTION LS ON A.SectionID = LS.SectionID";
                query += " INNER JOIN PUBLISHER P ON B.PublisherID = P.PublisherID";
            }

            query += " WHERE 1 = 1";

            if (!bookName.isEmpty()) {
                query += " AND B.BookName LIKE '%" + bookName + "%'";
            }

            if (!authorName.isEmpty()) {
                query += " AND B.AuthorName LIKE '%" + authorName + "%'";
            }

            if (!genre.isEmpty()) {
                query += " AND LS.GenreName = '" + genre + "'";
            }

            if (!rating.isEmpty()) {
                query += " AND B.BookID IN (SELECT BookID FROM REVIEW WHERE Rating >= " + rating + ")";
            }

            if (!publisher.isEmpty()) {
                query += " AND P.PublisherName LIKE '%" + publisher + "%'";
            }

            ResultSet result = stmt.executeQuery(query);
            return result;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    // Display the search results in the text area
    public void displayResult(ResultSet result) {
        try {
            if (result == null) {
                resultArea.setText("No books found.");
                return;
            }

            StringBuilder output = new StringBuilder();
            output.append("Books found:\n\n");

            while (result.next()) {
                int bookID = result.getInt("BookID");
                String bookName = result.getString("BookName");
                int pageCount = result.getInt("PageCount");
                String authorName = result.getString("AuthorName");
                int publisherID = result.getInt("PublisherID");

                // Get genre for the book
                Statement stmt = getConnection().createStatement();
                ResultSet genreResult = stmt.executeQuery("SELECT GenreName FROM LIBRARY_SECTION WHERE SectionID IN (SELECT SectionID FROM AVAILABILITY WHERE BookID = " + bookID + ")");
                String genre = "";
                while (genreResult.next()) {
                    genre += genreResult.getString("GenreName") + ", ";
                }
                if (!genre.isEmpty()) {
                    genre = genre.substring(0, genre.length() - 2); // Remove the trailing comma and space
                }

                // Get publisher name
                ResultSet publisherResult = stmt.executeQuery("SELECT PublisherName FROM PUBLISHER WHERE PublisherID = " + publisherID);
                String publisherName = "";
                if (publisherResult.next()) {
                    publisherName = publisherResult.getString("PublisherName");
                }

                // Append book details to the output string
                output.append("Book ID: ").append(bookID).append("\n");
                output.append("Book Name: ").append(bookName).append("\n");
                output.append("Page Count: ").append(pageCount).append("\n");
                output.append("Author Name: ").append(authorName).append("\n");
                output.append("Genre: ").append(genre).append("\n");
                output.append("Publisher: ").append(publisherName).append("\n");
                output.append("----------------------------------------\n");
            }

            resultArea.setText(output.toString());
        } catch (SQLException ex) {
            ex.printStackTrace();
            resultArea.setText("Error occurred while displaying books.");
        }
    }
}



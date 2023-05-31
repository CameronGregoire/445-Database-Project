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
    private static JFrame myFrame;
    private JTextField libraryIDField;
    private JTextArea resultArea;

    public CheckAllShipmentsPage() {
        myFrame = new JFrame("Check All Incoming Shipments");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        myPanel.add(new JLabel("LibraryID (1-5): "));
        libraryIDField = new JTextField();
        myPanel.add(libraryIDField);

        JButton checkButton = new JButton("Check For All Incoming Shipments");
        myPanel.add(checkButton);
        checkButton.addActionListener(e -> {
            String libraryID = libraryIDField.getText();

            ResultSet result = null;
            if (!libraryID.isEmpty()) {
                result = checkForAllIncomingShipments(libraryID);
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

    /**
     * This method connects to the database using JDBC dependency.
     * 
     * @return  The connection to return
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
     * 
     * 
     * @param libraryID
     * @return
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
}

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
 * Get a list of the customers' name, state name, City name, zip code, email, and phone number of all customers with a given name.
 */
public class CustomerDetailsPage {
    private static JFrame myFrame;
    private JTextField nameField;
    private JTextArea resultArea;

    public CustomerDetailsPage() {
        myFrame = new JFrame("Customer Details");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        myPanel.add(new JLabel("Customer Name: "));
        nameField = new JTextField();
        myPanel.add(nameField);

        JButton checkButton = new JButton("Get Details");
        myPanel.add(checkButton);
        checkButton.addActionListener(e -> {
            String customerName = nameField.getText();

            ResultSet result = null;
            if (!customerName.isEmpty()) {
                result = getCustomerDetails(customerName);
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

    public ResultSet getCustomerDetails(String customerName) {
        String query = "SELECT C.CustomerName, CI.CityName, S.StateName, Z.ZipCode, C.Email, C.Phone " +
                "FROM CUSTOMER C INNER JOIN CITY CI ON C.CityID = CI.CityID " +
                "INNER JOIN STATE S ON C.StateID = S.StateID INNER JOIN ZIP Z ON C.ZipCode = Z.ZipCode " +
                "WHERE C.CustomerName LIKE ?";

        try {
            Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, "%" + customerName + "%");
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    public void displayResult(ResultSet result) {
        StringBuilder resultText = new StringBuilder("Results:\n");
        try {
            if (!result.isBeforeFirst()) {
                resultText.append("No customer details were found");
            } else {
                while (result.next()) {
                    String customerName = result.getString("CustomerName");
                    String customerCity = result.getString("CityName");
                    String customerState = result.getString("StateName");
                    String customerZip = result.getString("Zipcode");
                    String customerEmail = result.getString("Email");
                    String customerPhone = result.getString("Phone");

                    String line = "Name: " + customerName + "\n";
                    line += "City: " + customerCity + "\n";
                    line += "State: " + customerState + "\n";
                    line += "Zipcode: " + customerZip + "\n";
                    line += "Email " + customerEmail + "\n";
                    line += "Phone number: " + customerPhone + "\n";

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
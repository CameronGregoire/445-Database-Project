package view;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * This class is responsible for handling the following:
 * Register with the library (as a new Customer) given a customer name, state name, City name, zip code, email, and phone number.
 */
public class RegisterAsNewCustomerPage {
    private static JFrame myFrame;
    private JTextField customerNameField, customerStateField, customerCityField, customerZipField, customerEmailField, customerPhoneField;
    private JTextArea resultArea;

    public RegisterAsNewCustomerPage() {
        myFrame = new JFrame("Register as New Customer");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        JPanel myPanel = new JPanel(new GridBagLayout());
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.anchor = GridBagConstraints.WEST;
        gbc.insets = new Insets(5, 5, 5, 5);

        gbc.gridx = 0;
        gbc.gridy = 0;
        myPanel.add(new JLabel("Customer Name:"), gbc);

        gbc.gridx = 1;
        gbc.gridy = 0;
        customerNameField = new JTextField(20);
        myPanel.add(customerNameField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 1;
        myPanel.add(new JLabel("State:"), gbc);

        gbc.gridx = 1;
        gbc.gridy = 1;
        customerStateField = new JTextField(20);
        myPanel.add(customerStateField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 2;
        myPanel.add(new JLabel("City:"), gbc);

        gbc.gridx = 1;
        gbc.gridy = 2;
        customerCityField = new JTextField(20);
        myPanel.add(customerCityField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 3;
        myPanel.add(new JLabel("ZIP Code:"), gbc);

        gbc.gridx = 1;
        gbc.gridy = 3;
        customerZipField = new JTextField(20);
        myPanel.add(customerZipField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 4;
        myPanel.add(new JLabel("Email:"), gbc);

        gbc.gridx = 1;
        gbc.gridy = 4;
        customerEmailField = new JTextField(20);
        myPanel.add(customerEmailField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 5;
        myPanel.add(new JLabel("Phone:"), gbc);

        gbc.gridx = 1;
        gbc.gridy = 5;
        customerPhoneField = new JTextField(20);
        myPanel.add(customerPhoneField, gbc);

        JButton registerButton = new JButton("Register");
        gbc.gridx = 0;
        gbc.gridy = 6;
        gbc.gridwidth = 2;
        gbc.anchor = GridBagConstraints.CENTER;
        myPanel.add(registerButton, gbc);
        registerButton.addActionListener(e -> {
            String customerName = customerNameField.getText();
            String customerState = customerStateField.getText();
            String customerCity = customerCityField.getText();
            String customerZip = customerZipField.getText();
            String customerEmail = customerEmailField.getText();
            String customerPhone = customerPhoneField.getText();

            if (customerName.isEmpty()) {
                displayResult("Customer Name field is blank.");
            } else if (customerState.isEmpty()) {
                displayResult("State field is blank.");
            } else if (customerCity.isEmpty()) {
                displayResult("City field is blank.");
            } else if (customerZip.isEmpty()) {
                displayResult("ZIP Code field is blank.");
            } else if (customerEmail.isEmpty()) {
                displayResult("Email field is blank.");
            } else if (customerPhone.isEmpty()) {
                displayResult("Phone field is blank.");
            } else {
                String result = registerAsNewCustomer(customerName, customerState, customerCity, customerZip, customerEmail, customerPhone);
                displayResult(result);
            }
        });

        // Back button to get back to the main page.
        JButton backButton = new JButton("Back");
        gbc.gridx = 0;
        gbc.gridy = 7;
        gbc.gridwidth = 2;
        gbc.anchor = GridBagConstraints.CENTER;
        myPanel.add(backButton, gbc);
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
     * This method connects to the database.
     * 
     * @return  The connection to the database.
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
     * This method performs the primary function of the page.
     * It will register a new customer under the given address, name, email, and phone.
     * 
     * @param customerName  The name of the customer.
     * @param customerState The name of the state.
     * @param customerCity  The name of the city.
     * @param customerZip   The zip code.
     * @param customerEmail The customer email.
     * @param customerPhone The custmer phone.
     * @return  Return the string result of if the register.
     */
    public String registerAsNewCustomer(String customerName, String customerState, String customerCity, String customerZip, String customerEmail, String customerPhone) {
        try {
            Connection conn = getConnection();
            if (conn == null) {
                return "Error: Unable to connect to the database.";
            }
    
            // Check if the customer already exists
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM CUSTOMER WHERE CustomerName = ?");
            stmt.setString(1, customerName);
            ResultSet result = stmt.executeQuery();
            if (result.next()) {
                return "Error: Customer already exists.";
            }
    
            // Retrieve the StateID for the provided customerState
            stmt = conn.prepareStatement("SELECT StateID FROM STATE WHERE StateName = ?");
            stmt.setString(1, customerState);
            result = stmt.executeQuery();
            if (!result.next()) {
                return "Error: Invalid state.";
            }
            int stateID = result.getInt("StateID");
    
            // Retrieve the CityID for the provided customerCity
            stmt = conn.prepareStatement("SELECT CityID FROM CITY WHERE CityName = ?");
            stmt.setString(1, customerCity);
            result = stmt.executeQuery();
            if (!result.next()) {
                return "Error: Invalid city.";
            }
            int cityID = result.getInt("CityID");
    
            // Retrieve the ZipCode for the provided customerZip
            int zipCode = Integer.parseInt(customerZip);
    
            // Insert the new customer into the database
            stmt = conn.prepareStatement("INSERT INTO CUSTOMER (CustomerName, StateID, CityID, ZipCode, Email, Phone) VALUES (?, ?, ?, ?, ?, ?)");
            stmt.setString(1, customerName);
            stmt.setInt(2, stateID);
            stmt.setInt(3, cityID);
            stmt.setInt(4, zipCode);
            stmt.setString(5, customerEmail);
            stmt.setString(6, customerPhone);
            int rowsAffected = stmt.executeUpdate();
    
            if (rowsAffected > 0) {
                return "Registration successful.";
            } else {
                return "Error: Failed to register as a new customer.";
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            return "Error: " + ex.getMessage();
        }
    }
    
    /**
     * Displays the results of the primary function to the user.
     * 
     * @param result    The result of the function.
     */
    public void displayResult(String result) {
        resultArea.setFont(new Font("Courier New", Font.PLAIN, 12));
        resultArea.setText("");
        resultArea.append(result);
    }
}

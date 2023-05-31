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
 * Find how many people who have had or currently have a membership with the library in a given zip code, city name, or state name.
 */
public class FindAllMembersByLocationPage {
    private static JFrame myFrame;
    private JTextField stateField, cityField, zipField;
    private JTextArea resultArea;

    public FindAllMembersByLocationPage() {
        myFrame = new JFrame("Find Library Members by Location");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        myPanel.add(new JLabel("State Name: "));
        stateField = new JTextField();
        myPanel.add(stateField);

        myPanel.add(new JLabel("City Name: "));
        cityField = new JTextField();
        myPanel.add(cityField);

        myPanel.add(new JLabel("Zip Code: "));
        zipField = new JTextField();
        myPanel.add(zipField);

        JButton findButton = new JButton("Find Memebers in Location");
        myPanel.add(findButton);
        findButton.addActionListener(e -> {
            String stateName = stateField.getText();
            String cityName = cityField.getText();
            String zipCode = zipField.getText();

            ResultSet result = findMembersByLocation(stateName, cityName, zipCode);
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

    public ResultSet findMembersByLocation(String stateName, String cityName, String zipCode) {
        try {
            Connection conn = getConnection();
            Statement stmt = conn.createStatement();
    
            String query = "SELECT * FROM CUSTOMER " +
                    "JOIN ADDRESS ON CUSTOMER.StateID = ADDRESS.StateID " +
                    "AND CUSTOMER.CityID = ADDRESS.CityID " +
                    "AND CUSTOMER.ZipCode = ADDRESS.ZipCode " +
                    "WHERE 1=1";
    
            if (!stateName.isEmpty()) {
                query += " AND ADDRESS.StateID IN (SELECT StateID FROM STATE WHERE StateName = '" + stateName + "')";
            }
            if (!cityName.isEmpty()) {
                query += " AND ADDRESS.CityID IN (SELECT CityID FROM CITY WHERE CityName = '" + cityName + "')";
            }
            if (!zipCode.isEmpty()) {
                query += " AND ADDRESS.ZipCode = " + zipCode;
            }
    
            query += " AND CUSTOMER.MembershipID IS NOT NULL";
    
            ResultSet result = stmt.executeQuery(query);
            return result;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }
    
    
    public void displayResult(ResultSet result) {
        try {
            if (!result.isBeforeFirst()) {
                resultArea.setText("No customers with a membership exist in the given location.");
            } else {
                StringBuilder sb = new StringBuilder();
                while (result.next()) {
                    sb.append("Customer ID: ").append(result.getInt("CustomerID")).append("\n");
                    sb.append("Customer Name: ").append(result.getString("CustomerName")).append("\n");
                    sb.append("Membership ID: ").append(result.getInt("MembershipID")).append("\n\n");
                }
                resultArea.setText(sb.toString());
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    
}

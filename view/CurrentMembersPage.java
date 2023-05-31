package view;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.sql.*;

public class CurrentMembersPage {
    private static JFrame myFrame;
    private JTextField zipcodeField;
    private JTextField cityField;
    private JTextField stateField;
    private JTextArea resultArea;

    public CurrentMembersPage() {
        myFrame = new JFrame("Current Members");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        JPanel myPanel = new JPanel(new GridLayout(7, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        myPanel.add(new JLabel("Zipcode: "));
        zipcodeField = new JTextField();
        myPanel.add(zipcodeField);

        myPanel.add(new JLabel("City: "));
        cityField = new JTextField();
        myPanel.add(cityField);

        myPanel.add(new JLabel("State: "));
        stateField = new JTextField();
        myPanel.add(stateField);

        JButton checkButton = new JButton("Get Members");
        myPanel.add(checkButton);
        checkButton.addActionListener(e -> {
            String zipcode = zipcodeField.getText();
            String city = cityField.getText();
            String state = stateField.getText();

            ResultSet result = null;
            if (!zipcode.isEmpty() || !city.isEmpty() || !state.isEmpty()) {
                result = getCurrentMembers(zipcode, city, state);
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

    public ResultSet getCurrentMembers(String zipcode, String city, String state) {
        String query = "SELECT COUNT(DISTINCT C.CustomerID) AS MemberCount \n" +
                "FROM CUSTOMER C INNER JOIN MEMBERSHIP M ON C.MembershipID = M.MembershipID \n" +
                "INNER JOIN ADDRESS A ON C.StateID = A.StateID AND C.CityID = A.CityID AND C.ZipCode = A.ZipCode \n" +
                "WHERE A.ZipCode LIKE ? OR A.StateID LIKE ? OR A.CityID LIKE ?";

        try {
            Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, "%" + zipcode + "%");
            stmt.setString(2, "%" + city + "%");
            stmt.setString(3, "%" + state + "%");
            return stmt.executeQuery();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }


    public void displayResult(ResultSet result) {
        StringBuilder resultText = new StringBuilder("Results:\n");
        try {
            if (result.next()) {
                int memberCount = result.getInt("MemberCount");
                resultText.append("Member Count: ").append(memberCount);
            } else {
                resultText.append("No members found");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        resultArea.setFont(new Font("Courier New", Font.PLAIN, 12));
        resultArea.setText(resultText.toString());
    }
}



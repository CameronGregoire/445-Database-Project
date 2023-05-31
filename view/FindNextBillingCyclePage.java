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
 * Find the next billing cycle of a member given the MemberID (int value).
 */
public class FindNextBillingCyclePage {
    private static JFrame myFrame;
    private JTextField membershipField;
    private JTextArea resultArea;

    public FindNextBillingCyclePage() {
        myFrame = new JFrame("Find Next Billing Cycle");
        myFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        myFrame.setSize(600, 400);

        JPanel myPanel = new JPanel(new GridLayout(6, 2));
        myPanel.setBorder(new EmptyBorder(10, 10, 10, 10));

        myPanel.add(new JLabel("Enter the MembershipID: "));
        membershipField = new JTextField();
        myPanel.add(membershipField);

        JButton checkButton = new JButton("Check for Next Billing Cycle");
        myPanel.add(checkButton);
        checkButton.addActionListener(e -> {
            String membershipID = membershipField.getText();

            ResultSet result = checkForNextBillingCycle(membershipID);
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
     * This performs the primary function of this page.
     * 
     * @param membershipID  The membership ID to check the billing cylce of.
     * @return  The next billing cycle, or tell them that the membership is expired.
     */
    public ResultSet checkForNextBillingCycle(String membershipID) {
        try {
            Connection conn = getConnection();
            String query = "SELECT EndDate FROM MEMBERSHIP WHERE MembershipID = ?";
            PreparedStatement statement = conn.prepareStatement(query);
            statement.setInt(1, Integer.parseInt(membershipID));

            ResultSet result = statement.executeQuery();
            return result;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    /**
     * Displays the results of the primary function to the user.
     * 
     * @param result    The result of the function.
     */
    public void displayResult(ResultSet result) {
        try {
            if (result.next()) {
                String endDate = result.getString("EndDate");
                String currentDate = java.time.LocalDate.now().toString();
    
                if (endDate.compareTo(currentDate) < 0) {
                    resultArea.setText("This membership has expired as of " + endDate + ".");
                } else {
                    resultArea.setText("Next billing cycle for membershipID " + membershipField.getText() + " is " + endDate + ".");
                }
            } else {
                resultArea.setText("Membership ID not found.");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}

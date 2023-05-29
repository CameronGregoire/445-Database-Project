package driver;

import view.MainPage;

/**
 * This class will be the driver for our program.
 * Everything will be initialized by running this class.
 * 
 * @author Nickolas Zahos
 * @author Cameron Gregoire
 */
public class Driver {
    public static void main(String[] args) {
        javax.swing.SwingUtilities.invokeLater(new Runnable() { // This ensures that our UI program is 'thread safe', this is the standard code for starting up UI.
            public void run() {
                new MainPage();
            }
        });
    }
}

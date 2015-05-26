package popsuite.bootstrap.jetty;

import org.eclipse.jetty.server.Server;

/**
 * The simplest possible Jetty server, not even a handler.
 *  
 * $ cd <project path>
 * $ mvn clean compile antrun:run -Dlauncher
 * 
 * Return a 404 error for every request.
 *
 * Note. As there is no servlet, this project can't be tested with jetty:run
 * 
 */
public class Launcher {
 
	private static final int DEFAULT_PORT = 8090;
 
    public static void main(final String[] args) throws Exception {
    	final Server server = new Server(DEFAULT_PORT);
        server.start();
        server.dumpStdErr();
        server.join();
    }
}
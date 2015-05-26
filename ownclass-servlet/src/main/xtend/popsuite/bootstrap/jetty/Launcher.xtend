package popsuite.bootstrap.jetty

import org.eclipse.jetty.server.Server
import org.eclipse.jetty.servlet.ServletHandler
import popsuite.servlet.HelloServlet

/**
 * A very simple Jetty server, with just a servlet.
 *  
 * $ cd <project path>
 * $ mvn clean compile antrun:run -Dlauncher
 * $ curl localhost:8090
 * <h1>Hello from HelloServlet</h1>
 * 
 * $ cd <project path>
 * $ mvn clean package antrun:run -Dstandalone
 * $ curl localhost:8090
 * <h1>Hello from HelloServlet</h1>
 * 
 */
class Launcher {
 
    static val DEFAULT_PORT = 8090
 
    static def main(String[] args) {
        extension val server = new Server(DEFAULT_PORT)
        
        val servlethandler = new ServletHandler
        servlethandler.addServletWithMapping(HelloServlet, "/*")
        
        server.handler = servlethandler
        start
        join
    }
    
}

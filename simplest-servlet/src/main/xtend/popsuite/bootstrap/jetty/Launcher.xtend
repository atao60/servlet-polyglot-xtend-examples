package popsuite.bootstrap.jetty

import javax.servlet.http.HttpServlet
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.servlet.ServletHandler
import org.eclipse.jetty.server.handler.HandlerList
import org.eclipse.jetty.server.handler.DefaultHandler

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
 * Note. As the servlet is declared as an inner class, jetty:run can't catch it. 
 */
class Launcher {
 
    static val DEFAULT_PORT = 8090
 
    static def main(String[] args) {
        extension val server = new Server(DEFAULT_PORT)
        
        val servlethandler = new ServletHandler
        servlethandler.addServletWithMapping(HelloServlet, "/*")
        
        val handlers = new HandlerList
        handlers.handlers = #[servlethandler, new DefaultHandler]
        server.handler = handlers
        start
        join
    }
    
    static class HelloServlet extends HttpServlet
    {
        override protected def doGet(HttpServletRequest request, extension HttpServletResponse response) {
            contentType = "text/html"
            status = HttpServletResponse.SC_OK
            writer.println("<h1>Hello from HelloServlet</h1>")
        }
    }   

}

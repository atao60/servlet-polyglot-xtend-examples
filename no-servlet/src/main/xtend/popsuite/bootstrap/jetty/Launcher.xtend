package popsuite.bootstrap.jetty

import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import org.eclipse.jetty.server.Request
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.server.handler.AbstractHandler

/**
 * A very simple Jetty server, with just a handler.
 *  
 * $ cd <project path>
 * $ mvn clean compile antrun:run -Dlauncher
 * Hello there.
 * 
 * $ cd <project path>
 * $ mvn clean package antrun:run -Dstandalone
 * Hello there.
 * 
 * Note. As there is no servlet, this project can't be tested with jetty:run
 * 
 */
class Launcher extends AbstractHandler {
 
    static val DEFAULT_PORT = 8090
 
    override def handle(String target, Request baseRequest, HttpServletRequest request, 
            HttpServletResponse response) {
        
        response.contentType = "text/plain;charset=utf-8"
        response.status = HttpServletResponse.SC_OK
        baseRequest.handled = true
        response.writer.println("Hello there.")
    }

    static def main(String[] args) {
        val server = new Server(DEFAULT_PORT)
        server.handler = new Launcher
        server.start
        server.join
    }
}

package popsuite.bootstrap.jetty

import org.eclipse.jetty.server.Server

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
class Launcher {
 
    static val DEFAULT_PORT = 8090
 
    static def main(String[] args) {
        val server = new Server(DEFAULT_PORT)
        server.start
        server.dumpStdErr
        server.join
    }
}
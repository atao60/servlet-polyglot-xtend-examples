package popsuite.bootstrap.jetty

import java.net.MalformedURLException
import org.eclipse.jetty.annotations.AnnotationConfiguration
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.util.resource.Resource
import org.eclipse.jetty.webapp.Configuration.ClassList
import org.eclipse.jetty.webapp.JettyWebXmlConfiguration
import org.eclipse.jetty.webapp.WebAppContext

import static java.lang.String.format

/**
 * A very simple Jetty server, with just a annotated servlet.
 *  
 * $ cd <project path>
 * $ mvn clean jetty:run
 * $ curl localhost:7080/webapp
 * <h1>Hello from annotated HelloServlet</h1>
 * 
 * $ cd <project path>
 * $ mvn clean compile antrun:run -Dlauncher
 * $ curl localhost:8090/webapp
 * <h1>Hello from annotated HelloServlet</h1>
 * 
 * $ cd <project path>
 * $ mvn clean package antrun:run -Dstandalone
 * $ curl localhost:8090/webapp
 * <h1>Hello from annotated HelloServlet</h1>
 * 
 * Any attempt to others pages will return an error 404 "Not found".
 * 
 */
class Launcher {
 
    static val JAR_INTERNAL_PATH = "(?<=\\.(?:jar|war)!/).*$"
    static val NOTHING = ""
    static val MALFORMED_RESOURCE_URL_MSG = "Resource URL (%s) is malformed."
 
    public static val DEFAULT_APP_CONTEXT_PATH      = "/webapp"
    
    public static val DEFAULT_PORT = 8090
 
    static def main(String[] args) {
        val server = new Server(DEFAULT_PORT)
        
        ClassList.setServerDefault(server) => [
            addBefore(JettyWebXmlConfiguration.name, AnnotationConfiguration.name)
        ]

        val webcontext = new WebAppContext => [
            war = webDir
            contextPath = DEFAULT_APP_CONTEXT_PATH
            // Specify where to search servlets annotated with @WebServlet (no default value) 
            metaData.webInfClassesDirs = #[webDirResource]
        ]

        server.handler = webcontext
        server.start
        server.join
    }
    
    static private def getWebDir() {
        val location = Launcher.protectionDomain.codeSource.location
        return location.toExternalForm.replaceFirst(JAR_INTERNAL_PATH, NOTHING)
    }
    
    static private def getWebDirResource() {
        try {
            return Resource.newResource(webDir)
        } catch (MalformedURLException e) {
            throw new IllegalArgumentException(format(MALFORMED_RESOURCE_URL_MSG, webDir, e))
        }
    }
    
}

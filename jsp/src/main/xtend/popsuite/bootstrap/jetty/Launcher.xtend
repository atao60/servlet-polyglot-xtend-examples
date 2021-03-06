package popsuite.bootstrap.jetty

import java.net.MalformedURLException
import org.eclipse.jetty.annotations.AnnotationConfiguration
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.util.resource.Resource
import org.eclipse.jetty.webapp.Configuration.ClassList
import org.eclipse.jetty.webapp.JettyWebXmlConfiguration
import org.eclipse.jetty.webapp.WebAppContext

import static java.lang.String.format
import org.eclipse.jetty.rewrite.handler.RewriteHandler
import org.eclipse.jetty.rewrite.handler.RedirectRegexRule
import popsuite.servlet.HelloServlet
import org.eclipse.jetty.server.handler.HandlerList
import org.eclipse.jetty.server.handler.DefaultHandler
import org.eclipse.jetty.servlet.ErrorPageErrorHandler
import javax.servlet.http.HttpServlet
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import org.eclipse.jetty.servlet.ServletHandler
import org.eclipse.jetty.server.handler.ContextHandler
import org.eclipse.jetty.server.handler.ResourceHandler
import org.eclipse.jetty.webapp.WebInfConfiguration

/**
 * A very simple Jetty server, with just a annotated servlet.
 *  
 * $ cd <project path>
 * $ mvn clean jetty:run
 * $ curl localhost:7080/webapp/hello
 * <h1>Hello from HelloServlet, with redirection.</h1>
 * 
 * Any attempt to others pages will return an jetty error page or directory content.
 * 
 * $ cd <project path>
 * $ mvn clean compile antrun:run -Dlauncher
 * $ curl localhost:8090
 * <h1>Hello from HelloServlet, with redirection.</h1>
 * 
 * $ cd <project path>
 * $ mvn clean package antrun:run -Dstandalone
 * $ curl localhost:8090
 * <h1>Hello from HelloServlet, with redirection.</h1>
 * 
 * The static content is available through "localhost:8090/doc" 
 * 
 * Any attempt to "/" or "/webapp" will be redirected to "/webapp/hello".
 * Any attempt to others pages will return an customized "404 Not found" error page.
 * 
 */
class Launcher {

    public static val DIR_ALLOWED_TAG = "org.eclipse.jetty.servlet.Default.dirAllowed"

    static val JAR_INTERNAL_PATH = "(?<=\\.(?:jar|war)!/).*$"
    static val NOTHING = ""
    static val MALFORMED_RESOURCE_URL_MSG = "Resource URL (%s) is malformed."
    static val URI_SEP = "/"
    static val ROOT_URI = URI_SEP
    static val ORIGINAL_REQUEST_PATH_TAG = "requestedPath"
//    static val REDIRECTION_PAGE_FILE_NAME = "/redirection.html"
    static val ERROR_PAGE_FILE_NAME = "/unavailable.html"
    static val STATIC_CONTENT_PATH = "static/"
    static val JSP_CONTENT_PATH = "jsp/"
    
    static val JAR_TO_BE_SCANNED_PATTERN   = ".*/(?:" //
            + "[^/]*servlet-api-" // any jar whose name contains "servlet-api-"
            + "|javax.servlet.jsp.jstl-" // any jar whose name starts with "javax.servlet.jsp.jstl-"
            + "|[^/]*taglibs" // any jar whose name contains "taglibs"
            + ")[^/]*\\.jar$";
    
    public static val DEFAULT_APP_CONTEXT_PATH    = "/webapp"
    public static val DEFAULT_STATIC_CONTEXT_PATH = "/doc"
    public static val DEFAULT_JSP_CONTEXT_PATH    = "/grid"

    public static val DEFAULT_PORT = 8090

    // deal with wrong URI inside a context
    static class ErrorHandler extends ErrorPageErrorHandler {
        new() {
            addErrorPage(ErrorPageErrorHandler.GLOBAL_ERROR_PAGE, ERROR_PAGE_FILE_NAME)
        }
    }

    // deal with wrong URI outside the contexts
    static class ErrorServlet extends HttpServlet {
        override protected doGet(HttpServletRequest request, HttpServletResponse response) {
            response.sendRedirect(DEFAULT_APP_CONTEXT_PATH + ERROR_PAGE_FILE_NAME)
        }
    }

    static def main(String[] args) {
        val server = new Server(DEFAULT_PORT)

        ClassList.setServerDefault(server) => [
            addBefore(JettyWebXmlConfiguration.name, AnnotationConfiguration.name)
        ]

        val webcontext = new WebAppContext => [
            contextPath = DEFAULT_APP_CONTEXT_PATH
            war = webDir
            setInitParameter(DIR_ALLOWED_TAG, Boolean.FALSE.toString)
            errorHandler = new ErrorHandler
            
            // Constrain list of jar files where to search tlds, web-fragments etc. 
            setAttribute(WebInfConfiguration.CONTAINER_JAR_PATTERN, JAR_TO_BE_SCANNED_PATTERN)
            
            // Specify where to search servlets annotated with @WebServlet (no default value)
            metaData.webInfClassesDirs = #[webDirResource]
        ]

        val staticcontexthandler = new ContextHandler => [
            contextPath = DEFAULT_STATIC_CONTEXT_PATH
            handler = new ResourceHandler => [
                resourceBase = webDir + STATIC_CONTENT_PATH
                directoriesListed = false
            ]
        ]
        
        val jspcontext = new WebAppContext => [
            contextPath = DEFAULT_STATIC_CONTEXT_PATH // DEFAULT_JSP_CONTEXT_PATH
            resourceBase = webDir + JSP_CONTENT_PATH
            setInitParameter(DIR_ALLOWED_TAG, Boolean.FALSE.toString)
            errorHandler = new ErrorHandler
        ]

        val errorHandler = new ServletHandler => [
            addServletWithMapping(ErrorServlet.name, ROOT_URI)
        ]

        val handlers = new HandlerList
        handlers.handlers = #[
            redirectWebAppContextUrlHandler,
            webcontext,
            staticcontexthandler,
            jspcontext,
            redirectRootUrlHandler,
            errorHandler,
            new DefaultHandler
        ]
        server.handler = handlers
        server.start
        server.join
    }

    static private def getWebDir() {
        val location = Launcher.protectionDomain.codeSource.location
        location.toExternalForm.replaceFirst(JAR_INTERNAL_PATH, NOTHING)
    }

    static private def getWebDirResource() {
        try {
            Resource.newResource(webDir)
        } catch (MalformedURLException e) {
            throw new IllegalArgumentException(format(MALFORMED_RESOURCE_URL_MSG, webDir, e))
        }
    }

    static def getRedirectRootUrlHandler() {

        val redirect = new RedirectRegexRule => [
            regex = ROOT_URI
            replacement = DEFAULT_APP_CONTEXT_PATH + URI_SEP + HelloServlet.URL_PATTERN
        ]

        new RewriteHandler => [
            rewriteRequestURI = true
            rewritePathInfo = false
            originalPathAttribute = ORIGINAL_REQUEST_PATH_TAG
            addRule(redirect)
        ]
    }

    static def getRedirectWebAppContextUrlHandler() {

        val redirect = new RedirectRegexRule => [
            regex = DEFAULT_APP_CONTEXT_PATH + URI_SEP + "?"
            replacement = DEFAULT_APP_CONTEXT_PATH + URI_SEP + HelloServlet.URL_PATTERN
        ]

        new RewriteHandler => [
            rewriteRequestURI = true
            rewritePathInfo = false
            originalPathAttribute = ORIGINAL_REQUEST_PATH_TAG
            addRule(redirect)
        ]
    }
}

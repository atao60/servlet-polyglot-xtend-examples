package popsuite.servlet

import javax.servlet.annotation.WebServlet
import javax.servlet.http.HttpServlet
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@WebServlet(urlPatterns = #[HelloServlet.URL_PATTERN])
class HelloServlet extends HttpServlet {

    public static val String URL_PATTERN = "hello" 
    
        override protected def doGet(HttpServletRequest request, extension HttpServletResponse response) {
            contentType = "text/html"
            status = HttpServletResponse.SC_OK
            writer.println("<h1>Hello from HelloServlet with redirection.</h1>")
        }
    }   

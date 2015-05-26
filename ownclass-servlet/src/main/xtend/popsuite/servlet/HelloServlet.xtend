package popsuite.servlet

import javax.servlet.http.HttpServlet
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

class HelloServlet extends HttpServlet
    {
        override protected def doGet(HttpServletRequest request, extension HttpServletResponse response) {
            contentType = "text/html"
            status = HttpServletResponse.SC_OK
            writer.println("<h1>Hello from HelloServlet</h1>")
        }
    }   

A Web site without any servlet or handler
===============

Not even a handler is provided to the server. Any request will return an error 404.

No Xtend, no Polyglot Maven.

As there is no servlet, this project can't be tested with jetty:run, only with antrun:run (°).

Note (°). maven-antrun-plugin is used here as exec-maven-plugin under m2e is unable to stop the process that it has launched. 

Configuration - Tools
-----

JDK 1.7

Servlet 3.1

Maven 3.1 & +

Eclipse Luna

Running
-----

$ cd <project path>
$ mvn clean compile antrun:run -Dlauncher
$ curl localhost:8090
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1"/>
<title>Error 404 </title>
</head>
<body>
<h2>HTTP ERROR: 404</h2>
<p>Problem accessing /. Reason:
<pre>    Not Found</pre></p>
<hr /><i><small>Powered by Jetty://</small></i>
</body>
</html>

Same thing with:
$ mvn clean package antrun:run -Dstandalone

References
-----

Jetty Development Guide - Chapter 25. Embedding - Embedding Jetty
http://www.eclipse.org/jetty/documentation/9.2.10.v20150310/embedding-jetty.html

A Web site with JSP
===============

This sample application is build upon the previous [*server with redirection* one](../redirection).

The web application path is "/webapp/hello".

The documentation is available from "/doc", either pure static HTML pages or JSP pages.

Error management:

* any access to "/" or "/webapp" will be redirected to the web application.
* any access to an unexpected url under "/webapp/hello" will be redirected to a customized 404 Error page
* any other unexpected access will go to the standard jetty error page.

Use Polyglot Maven with Groovy as build language.

Now *jetty:run* can catch the servlets annotated with @WebServlet.

Changes
-----

### JSP

Add content with a mix of static HTML pages and JSP pages:

- create JSP pages and webapp/static/index.html
- add the code to deal with it in Launcher
- add the dependency for apache-jsp and apache-jstl
- upgrade to JDK 1.8 to get the new Date and Time API

### Redirections ###

- add the dependency for org.eclipse.jetty:jetty-rewrite
- add a RewriteHandler to the launcher
- add a file src/main/webapp/redirection.html
- add a file src/main/webapp/unavailable.html

### Context path ###

Previously, the context path was empty. Use here a non empty one, i.e. "webapp", without DefaultHandler.

### Annotated servlet ###

The servlet class is annotated with @WebServlet. Then the launcher doesn't need anymore to reference explicitly the servlet.

Now, jetty:run can be used to test it:
- add the plugin jetty-maven-plugin
- add the dependency for org.eclipse.jetty:jetty-annotations

### Servlet with its own class ###

The servlet is extracted from the launcher to become its own class.

### Servlet as an inner class of the launcher ###

The handler is replaced by a servlet. This servlet is declared as an inner class of the launcher.

In the pom:

* Add dependency for org.eclipse.jetty:jetty-webapp

### Server with a handler ###

A handler is added to provide a content to the server.

### Xtend ###

In the pom:

* Add dependency for org.eclipse.xtend:org.eclipse.xtend.lib
* Add plugin org.eclipse.xtend:xtend-maven-plugin
* Use build-helper-maven-plugin to deal with Xtend source folders

Create the source folders for Xtend classes in src/main/xtend

Create the Xtend class "popsuite.bootstrap.jetty.Launcher"

Under Eclipse:
   Properties > Xtend > Compiler 
   
   - Directory: target/xtend-gen
   - Allow output directory per source folder
   
     - src/main/java  ---> target/xtend-gen/main
     - src/main/xtend ---> target/xtend-gen/main
     - src/test/java  ---> target/xtend-gen/test
     - src/test/xtend ---> target/xtend-gen/test

### Maven Polyglot ###

To use Maven Polyglot with Groovy as build language:

* Maven 3.3.1 & +
* add .mvn/extensions.xml   

`        <?xml version="1.0" encoding="UTF-8"?>`  
`        <extensions>`  
`            <extension>`  
`                <groupId>io.takari.polyglot</groupId>`  
`                <artifactId>polyglot-groovy</artifactId>`  
`                <version>0.1.8</version>`  
`            </extension>`  
`        </extensions>`  

* create a pom.groovy file

Under [Eclipse Luna](https://projects.eclipse.org/releases/luna), [m2e](http://eclipse.org/m2e/) is not aware of [Polyglot](https://github.com/takari/maven-polyglot) yet. At the moment (m2e v. 1.5.1), the only workaround is to use JBoss Tools [m2e-polyglot-poc](https://github.com/jbosstools/m2e-polyglot-poc). This tool automatically generates pom.xml files from the Polyglot ones.

> Note. This tool requires that a pom.xml file is present before editing the polyglot pom file. The pom.xml must be valid with at least a GAV, even if with non empty arbitrary values.  

With an existing Maven project, the most straightforward way to start is to get a groovy pom from the pom.xml file using the tool provided by [Takari](http://takari.io/), i.e. :

         mvn io.takari.polyglot:polyglot-translate-plugin:translate -Dinput=pom.xml -Doutput=pom.groovy

> Note. Under Eclipse, each Maven Build launch configuration has to specify:

>* on the tab "Main", Maven Runtime: `MAVEN (External {your maven path} {3.3.1 or above})`
>* on the tab "JRE", VM Arguments: `-Dmaven.multiModuleProjectDirectory=`

Running
-----

With *jetty-maven-plugin*:

        $ cd <project path>
        $ mvn clean jetty:run
        $ curl localhost:7080/webapp/hello
        <h1>Hello from annotated HelloServlet.</h1>

With *maven-antrun-plugin* and the launcher:

        $ cd <project path>
        $ mvn clean compile antrun:run -Dlauncher
        $ curl localhost:8090
        <h1>Hello from annotated HelloServlet.</h1>

With *maven-antrun-plugin* and the runnable war:

        $ cd <project path>
        $ mvn clean package antrun:run -Dstandalone
        $ curl localhost:8090
        <h1>Hello from annotated HelloServlet.</h1>

References
-----

Jetty Development Guide - Chapter 25. Embedding - Embedding Jetty
http://www.eclipse.org/jetty/documentation/9.2.10.v20150310/embedding-jetty.html

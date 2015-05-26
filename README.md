Servlet examples with Xtend
========

__WARNING__: it's a __work in progress__. The README.md files are not always up-to-date with the code.

Rational
------

This repository aims to put together some simple web projects using a mix of classic and trendy tools.

For the classic one: [Maven](https://maven.apache.org/), JSP and Servlet.

For the trendy ones:  

* [Xtend](https://eclipse.org/xtend/) as coding language,
* Maven again but with [Polyglot]() and Groovy as build language,
* Servlet again but with version 3.0 or above to setup a full Java configuration,
* [Spring Boot Maven Plugin](http://docs.spring.io/spring-boot/docs/current/maven-plugin/) and [Jetty](http://eclipse.org/jetty/) to generate runnable war.

With Maven Polyglot and Servlet 3.0, there is no more XML configuration files.

At the moment, [Java](https://www.java.com) 1.7 does the job.

Step by step, each project will add a new feature. 

Any of those projects works out of the box:

* with *[Apache Maven AntRun Plugin](https://maven.apache.org/plugins/maven-antrun-plugin/)(°)* or *[Jetty Maven Plugin](http://www.eclipse.org/jetty/documentation/current/jetty-maven-plugin.html)(°°)*,
* and as a runnable war.

Notes

(°): The *Apache Maven AntRun Plugin* is used rather than *[Exec Maven Plugin](http://mojo.codehaus.org/exec-maven-plugin/)* as the latter, when working under m2e, is unable to stop the wrapped process. 

(°°): When a servlet is reachable through annotation or deployment descriptor.

Steps
-----

### [a lonely server](legacy-simplest-server) ###

Neither servlet nor handler. Doesn't use Xtend or Polyglot Maven yet. 

### [polyglot maven](polyglot-simplest-server) ###

Use Polyglot Maven with Groovy as build language.

### [xtend](xtend-simplest-server) ###

Use Xtend as coding language.

### [no servlet](no-servlet) ###

Just a simple handler.
 
### [simple servlet](simplest-servlet) ###

A first servlet as inner class of the launcher.

### [simple servlet with it own class](ownclass-servlet) ###

The servlet in its own class.

### [simple servlet as annotated class](annotated-servlet) ###

The servlet class is annotated with @WebServlet. Now jetty-maven-plugin can be used to test the servlet.
And the launcher doesn't catch anymore the servlet explicitely.

### [Non empty context path](contextpath-servlet) ###

A non empty context path is specified.

### [redirections](redirection) ###

Manage unexpected access.

### [jsp](jsp) ###

Add some JSP content.

References
-------

Start with:

>Jetty Development Guide - Chapter 25. Embedding - Embedding Jetty
>http://www.eclipse.org/jetty/documentation/9.2.10.v20150310/embedding-jetty.html


Polyglot but with various languages under the umbrella of the JVM:

>vakuum/polyglot-java  
>A demonstration on how to integrate different JVM languages into a multi-module Maven build.  
>https://github.com/vakuum/polyglot-java  


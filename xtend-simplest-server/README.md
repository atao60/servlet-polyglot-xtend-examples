A Web site without any servlet or handler
===============

This sample application is build upon the previous [*polyglot* one](../polyglot-simplest-server), but it uses [Xtend](https://eclipse.org/xtend/) in place of [Java](https://www.java.com).

Not even a handler is provided to the server. Any request will return an error 404.

Use Polyglot Maven with Groovy as build language.

As there is no servlet, this project can't be tested with jetty:run, only with antrun:run (°).

Note (°). maven-antrun-plugin is used here as exec-maven-plugin under m2e is unable to stop the process that it has launched. 

Changes
-----

### Xtend ###

In the pom:

* Add dependency for org.eclipse.xtend:org.eclipse.xtend.lib
* Add plugin org.eclipse.xtend:xtend-maven-plugin
* Use build-helper-maven-plugin to deal with Xtend source folders

Create the source folders for Xtend classes in src/main/xtend

Create the Xtend class "popsuite.bootstrap.jetty.Launcher"

Under Eclipse:
   Properies > Xtend > Compiler 
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
<?xml version="1.0" encoding="UTF-8"?>
<extensions>
    <extension>
        <groupId>io.takari.polyglot</groupId>
        <artifactId>polyglot-groovy</artifactId>
        <version>0.1.8</version>
    </extension>
</extensions>
* create pom.groovy

* Under [Eclipse Luna](https://projects.eclipse.org/releases/luna), [m2e](http://eclipse.org/m2e/) is not aware of [Polyglot](https://github.com/takari/maven-polyglot) yet. At the moment (m2e v. 1.5.1), the only workaround is to use JBoss Tools [m2e-polyglot-poc](https://github.com/jbosstools/m2e-polyglot-poc). This tool automatically generates pom.xml files from the Polyglot ones.

> Note. This tool requires that a pom.xml file is present before editing the polyglot pom file. The pom.xml must be valid with at least a GAV, even if with non empty arbitrary values.  

With an existing Maven project, the most straightforward way to start is to get a groovy pom from the pom.xml file using the tool provided by [Takari](http://takari.io/), i.e. :

         mvn io.takari.polyglot:polyglot-translate-plugin:translate -Dinput=pom.xml -Doutput=pom.groovy

> Note. Under Eclipse, each Maven Build launch configuration has to specify:

* on the tab "Main", Maven Runtime: `MAVEN (External {your maven path} {3.3.1 or above})`
* on the tab "JRE", VM Arguments: `-Dmaven.multiModuleProjectDirectory=`

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

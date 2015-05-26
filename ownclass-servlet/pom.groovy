project(modelVersion: '4.0.0') {

	groupId 'servlet-polyglot-xtend-examples'
	artifactId 'ownclass-servlet'
	version '0.0.1-SNAPSHOT'
	packaging 'war'

	properties {

		/* Project parameters */
		'root-name' 'servlet-polyglot-xtend'

		'web.port' '7080'
		'war.runnable.classifier' 'standalone'
		'main.class' 'popsuite.bootstrap.jetty.Launcher'
		
		'xtend.outputDir' '${project.build.directory}/xtend-gen/main'
		'xtend.testOutputDir' '${project.build.directory}/xtend-gen/test'

		/* JVM Management */
		'project.jdk.version' '1.7' // JDK 1.7 or above requiered by Jetty 9
		'project.encoding' 'UTF-8'

		'project.build.sourceEncoding' '${project.encoding}'
		'project.reporting.outputEncoding' '${project.encoding}'

		'maven.compiler.source' '${project.jdk.version}'
		'maven.compiler.target' '${project.jdk.version}'
		'maven.compiler.compilerVersion' '${project.jdk.version}'
		'maven.compiler.fork' 'true'
		'maven.compiler.verbose' 'true'
		'maven.compiler.optimize' 'true'
		'maven.compiler.debug' 'true'

		/* Maven and Plugin Management */
		'maven.minimal.version' '3.3.1'  // Maven 3.3.1 or above required for Polyglot
		
		'xtendVersion' '2.7.3'

		'spring.boot.maven.version' '1.2.3.RELEASE'
		'ant.maven.version' '1.8'

		'build.helper.maven.version' '1.9.1'
		'enforcer.maven.version' '1.4'
		'xtend.maven.version' '${xtendVersion}'

		'clean.maven.version' '2.6.1'

		/* used with antrun:run and the launcher */ 
		'resources.maven.version' '2.7'
		'compiler.maven.version' '3.3'

		/* used when generating a war file */
		'war.maven.version' '2.6'
		'surefire.maven.version' '2.18.1'

		/* other plugins */
		'install.maven.version' '2.4'
		'deploy.maven.version' '2.7'

		/* Dependency Management */

		'javax.servlet.version' '3.1.0' // Servlet 3.0 or above required for Java Base Configuration
		'jetty.version' '9.2.10.v20150310'
		'xtend.version' '${xtendVersion}'
	}
	dependencies {
		dependency('org.eclipse.xtend:org.eclipse.xtend.lib:${xtend.version}')
		
		/* Servlet specification 3.0 or above */
		dependency('javax.servlet:javax.servlet-api:${javax.servlet.version}:provided')
		
		/* Standalone application */
		dependency('org.eclipse.jetty:jetty-server:${jetty.version}:provided')
		dependency('org.eclipse.jetty:jetty-webapp:${jetty.version}:provided')
	}
	build {
		plugins {
			plugin( 'org.codehaus.mojo:build-helper-maven-plugin')
			plugin( 'org.eclipse.xtend:xtend-maven-plugin' )
			plugin( 'org.apache.maven.plugins:maven-enforcer-plugin' )
		}
		pluginManagement {
			plugins {
				plugin('org.eclipse.xtend:xtend-maven-plugin:${xtend.maven.version}') {
					executions {
						execution {
							goals { 
								goal 'compile' 
								goal 'testCompile' 
							}
						}
					}
					configuration {
						outputDirectory '${xtend.outputDir}'
						testOutputDirectory '${xtend.testOutputDir}'
					}
				}
				
				plugin('org.codehaus.mojo:build-helper-maven-plugin:${build.helper.maven.version}') {
					executions {
						execution(id: 'get-maven-version') {
							goals { goal 'maven-version' }
						}
						/* required to be be able to put the xtend classes in a separate source folder */
						execution(id: 'add-source', phase: 'generate-sources') {
							goals {
								goal 'add-source'
							}
							configuration {
								sources {
									source 'src/main/xtend'
								}
							}
						}
						execution(id: 'add-test-source', phase: 'generate-test-sources') {
							goals {
								goal 'add-test-source'
							}
							configuration {
								sources {
									source 'src/test/xtend'
								}
							}
						}
					}
				}
				plugin {
					artifactId 'maven-enforcer-plugin'
					version '${enforcer.maven.version}'
					executions {
						execution {
							id 'enforce-versions'
							goals { goal 'enforce' }
							configuration {
								fail 'true'
								rules {
									requireMavenVersion {
										version '${maven.minimal.version}'
										message '''[ERROR] OLD MAVEN [${maven.version}] in use. 
                                            Maven ${maven.minimal.version} or newer is required.'''
									}
									requireJavaVersion {
										version '${project.jdk.version}'
										message '''[ERROR] OLD JDK [${java.version}] in use. 
                                            JDK ${project.jdk.version} or newer is required.'''
									}
									requirePluginVersions {
										banLatest 'true'
										banRelease 'true'
										banSnapshots 'true'
										unCheckedPluginList 'org.apache.maven.plugins:maven-site-plugin'
									}
									bannedDependencies {
										searchTransitive 'true'
										excludes {
											exclude 'commons-logging'
											exclude 'log4j'
											exclude 'org.apache.logging.log4j'
										}
									}
								}
							}
						}
					}
				}
				plugin('org.apache.maven.plugins:maven-compiler-plugin:${compiler.maven.version}')
				plugin('org.apache.maven.plugins:maven-jar-plugin:${jar.maven.version}')
				plugin('org.apache.maven.plugins:maven-clean-plugin:${clean.maven.version}')
				plugin('org.apache.maven.plugins:maven-resources-plugin:${resources.maven.version}')
				plugin('org.apache.maven.plugins:maven-war-plugin:${war.maven.version}') 
				plugin('org.apache.maven.plugins:maven-surefire-plugin:${surefire.maven.version}')
				plugin('org.apache.maven.plugins:maven-install-plugin:${install.maven.version}')
				plugin('org.apache.maven.plugins:maven-deploy-plugin:${deploy.maven.version}')
			}
		}
	}
	profiles {
		profile(id: 'launcher') {
			activation { property { name 'launcher'
				} }
			build {
				resources {
					resource { directory 'src/main/resources' }
					resource { directory 'src/main/webapp' }
				}
				plugins {
					plugin('org.apache.maven.plugins:maven-antrun-plugin:${ant.maven.version}') {
						configuration {
							target {
								java(classname:'${main.class}', fork:'true') {   classpath(refid:'maven.compile.classpath')  }
							}
						}
					}
				}
			}
		}
		profile(id: 'standalone') {
			activation { property { name 'standalone'
				} }
			build {
				finalName '${root.name}-${project.artifactId}'
				plugins {
					plugin('org.apache.maven.plugins:maven-war-plugin') {
						configuration { failOnMissingWebXml 'false' }
					}
					plugin('org.springframework.boot:spring-boot-maven-plugin:${spring.boot.maven.version}') {
						executions {
							execution(id: 'package-runable-war') {
								goals { goal 'repackage' }
							}
						}
						configuration {
							classifier '${war.runnable.classifier}'
							mainclass '${main.class}'
						}
					}
					plugin('org.apache.maven.plugins:maven-antrun-plugin:${ant.maven.version}') {
						configuration {
							target {
								java(jar:'target/${project.build.finalName}-${war.runnable.classifier}.war', fork:'true')
							}
						}
					}
				}
			}
		}
	}
}

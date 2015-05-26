project {
	modelVersion '4.0.0'
	groupId 'servlet-polyglot-xtend-examples'
	artifactId 'polyglot-simplest-server'
	version '0.0.1-SNAPSHOT'
	packaging 'war'

	properties {

		/* Project parameters */
		'root-name' 'servlet-polyglot-xtend'

		'web.port' '7080'
		'war.runnable.classifier' 'standalone'
		'main.class' 'popsuite.bootstrap.jetty.Launcher'

		/* JVM Management */
		'project.jdk.version' '1.7'
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
		'maven.minimal.version' '3.3.1'

		'ant.maven.version' '1.8'
		'spring.boot.maven.version' '1.2.3.RELEASE'

		'build.helper.maven.version' '1.9.1'
		'enforcer.maven.version' '1.4'

		/* used with jetty:run */ 
		'resources.maven.version' '2.7'
		'compiler.maven.version' '3.3'
		'clean.maven.version' '2.6.1'

		/* used when generating a war file */
		'war.maven.version' '2.6'
		'surefire.maven.version' '2.18.1'

		/* other plugins */
		'install.maven.version' '2.4'
		'deploy.maven.version' '2.7'

		/* Dependency Management */

		'javax.servlet.version' '3.1.0'
		'jetty.version' '9.2.10.v20150310'
	}
	dependencies {
		dependency {
			groupId 'javax.servlet'
			artifactId 'javax.servlet-api'
			version '${javax.servlet.version}'
			scope 'provided'
		}
		/* Standalone application */
		dependency {
			groupId 'org.eclipse.jetty'
			artifactId 'jetty-server'
			version '${jetty.version}'
			scope 'provided'
		}
	}
	build {
		plugins {
			plugin {
				groupId 'org.codehaus.mojo'
				artifactId 'build-helper-maven-plugin'
			}
			plugin { artifactId 'maven-enforcer-plugin' }
		}
		pluginManagement {
			plugins {
				plugin {
					artifactId 'maven-compiler-plugin'
					version '${compiler.maven.version}'
				}
				plugin {
					artifactId 'maven-clean-plugin'
					version '${clean.maven.version}'
				}
				plugin {
					artifactId 'maven-resources-plugin'
					version '${resources.maven.version}'
				}
				plugin {
					artifactId 'maven-surefire-plugin'
					version '${surefire.maven.version}'
				}
				plugin {
					artifactId 'maven-war-plugin'
					version '${war.maven.version}'
				}
				plugin {
					artifactId 'maven-install-plugin'
					version '${install.maven.version}'
				}
				plugin {
					artifactId 'maven-deploy-plugin'
					version '${deploy.maven.version}'
				}
				plugin {
					groupId 'org.codehaus.mojo'
					artifactId 'build-helper-maven-plugin'
					version '${build.helper.maven.version}'
					executions {
						execution {
							id 'get-maven-version'
							goals { goal 'maven-version' }
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
			}
		}
	}
	profiles {
		profile {
			id 'launcher'
			activation { property { name 'launcher'
				} }
			build {
				resources {
					resource { directory 'src/main/resources' }
					resource { directory 'src/main/webapp' }
				}
				plugins {
					plugin {
						artifactId 'maven-antrun-plugin'
						version '${ant.maven.version}'
						configuration {
							target {
								java(classname:'${main.class}', fork:'true') {   classpath(refid:'maven.compile.classpath')  }
							}
						}
					}
				}
			}
		}
		profile {
			id 'standalone'
			activation { property { name 'standalone'
				} }
			build {
				finalName '${root.name}-${project.artifactId}'
				plugins {
					plugin {
						artifactId 'maven-war-plugin'
						configuration { failOnMissingWebXml 'false' }
					}
					plugin {
						groupId 'org.springframework.boot'
						artifactId 'spring-boot-maven-plugin'
						version '${spring.boot.maven.version}'
						executions {
							execution {
								id 'package-runable-war'
								goals { goal 'repackage' }
							}
						}
						configuration {
							classifier '${war.runnable.classifier}'
							mainclass '${main.class}'
						}
					}
					plugin {
						artifactId 'maven-antrun-plugin'
						version '${ant.maven.version}'
						configuration {
							target {
								java(fork:'true', jar:'target/${project.build.finalName}-${war.runnable.classifier}.war')
							}
						}
					}
				}
			}
		}
	}
}

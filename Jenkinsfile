@Library('xmos_jenkins_shared_library@v0.34.0') _

pipeline {
    agent {
        label 'x86_64 && linux'
    }
    environment {
        REPO = "lib_locks"
    }
    options {
        buildDiscarder(xmosDiscardBuildSettings())
        skipDefaultCheckout()
        timestamps()
    }
    parameters {
        string(
            name: 'TOOLS_VERSION',
            defaultValue: '15.3.0',
            description: 'The XTC tools version'
        )
        string(
            name: 'XMOSDOC_VERSION',
            defaultValue: 'v6.1.2',
            description: 'The xmosdoc version'
        )
        string(
            name: 'INFR_APPS_VERSION',
            defaultValue: 'v2.0.1',
            description: 'The infr_apps version'
        )
    }

    stages {
        stage ("Build examples") {
            steps {
                dir("${REPO}") {
                    checkout scm

                    dir("examples") {
                        withTools(params.TOOLS_VERSION){
                            sh "cmake -B build -G \"Unix Makefiles\""
                            sh "xmake -C build -j"
                        }
                    }
                }
            }
        } // Build examples

        stage('Library checks') {
            steps {
                runLibraryChecks("${WORKSPACE}/${REPO}", "${params.INFR_APPS_VERSION}")
            }
        }

        stage('Documentation') {
          steps {
            dir("${REPO}") {
              warnError("Docs") {
                buildDocs()
              }
            }
          }
        }

        stage ("Tests") {
            steps {
                withTools(params.TOOLS_VERSION) {
                    dir("${REPO}/tests") {
                        createVenv(reqFile: 'requirements.txt')
                        withVenv {
                            catchError {
                                sh "python -m pytest --junitxml=results.xml -rA -v --durations=0 -o junit_logging=all"
                            }
                            archiveArtifacts artifacts: "results.xml"
                            junit "results.xml"
                        }
                    }
                }
            }
        } // Tests
    } // stages

    post {
        cleanup {
            xcoreCleanSandbox()
        }
    }
}

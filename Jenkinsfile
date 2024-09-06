@Library('xmos_jenkins_shared_library@v0.27.0') _

pipeline {
    agent {
        label 'linux&&64'
    }

    options {
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timestamps()
        buildDiscarder(xmosDiscardBuildSettings(onlyArtifacts=false))
    }
    parameters {
        string(
            name: 'TOOLS_VERSION',
            defaultValue: '15.3.0',
            description: 'The XTC tools version'
        )
    }

    stages {
        stage ("Build and Test") {
            steps {
                withTools(params.TOOLS_VERSION){ 
                    dir("lib_locks") {
                        // clone 
                        checkout scm

                        // build examples
                        dir("examples") {
                            sh "cmake -B build -G \"Unix Makefiles\""
                            sh "xmake -C build"
                            archiveArtifacts artifacts: "**/*.xe"
                        }

                        // run tests
                        createVenv('requirements.txt')
                        withVenv {
                            sh "pip install -r requirements.txt"
                            dir("tests") {
                                catchError {
                                    sh "python -m pytest --junitxml=results.xml -rA -v --durations=0 -o junit_logging=all"
                                }
                                archiveArtifacts artifacts: "results.xml"
                                junit "results.xml"
                            }
                        }
                    }
                }
            }
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}

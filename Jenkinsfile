@Library('xmos_jenkins_shared_library@v0.27.0') _

pipeline {
    agent none

    options {
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timestamps()
        buildDiscarder(xmosDiscardBuildSettings(onlyArtifacts=false))
    }
    parameters {
        string(
            name: 'TOOLS_VERSION',
            defaultValue: '15.2.1',
            description: 'The XTC tools version'
        )
    }

    stages {
        stage("Do Jenkins") {
            agent {
                label 'linux&&64'
            }
            stages {
                stage ("Do Jenkins") {
                    steps {
                        withTools(params.TOOLS_VERSION){ 
                            sh "mkdir -p my-sandbox/lib_locks"
                            dir("my-sandbox/lib_locks") {
                                // clone 
                                checkout scm

                                // build examples
                                dir("examples/locks_lib_example") {
                                    sh "./build-all-targets"
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
                                        junit "results.xml"
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

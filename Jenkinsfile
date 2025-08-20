// This file relates to internal XMOS infrastructure and should be ignored by external users

@Library('xmos_jenkins_shared_library@v0.41.1') _

getApproval()
pipeline {

    agent none

    parameters {
        string(
            name: 'TOOLS_VERSION',
            defaultValue: '15.3.1',
            description: 'XTC tools version'
        )
        string(
            name: 'XMOSDOC_VERSION',
            defaultValue: 'v7.3.0',
            description: 'xmosdoc version'
        )
        string(
            name: 'INFR_APPS_VERSION',
            defaultValue: 'v3.1.1',
            description: 'The infr_apps version'
        )
        choice(
            name: 'TEST_LEVEL', choices: ['smoke', 'default', 'extended'],
            description: 'The level of test coverage to run'
        )
    }

    options {
        skipDefaultCheckout()
        timestamps()
        buildDiscarder(xmosDiscardBuildSettings(onlyArtifacts = false))
    }

    stages {
        stage('🏗️ Build and test') {
            agent {
                label 'x86_64 && linux && documentation'
            }

            stages {
                stage('Checkout') {
                    steps {

                        println "Stage running on ${env.NODE_NAME}"

                        script {
                            def (server, user, repo) = extractFromScmUrl()
                            env.REPO_NAME = repo
                        }

                        dir(REPO_NAME){
                            checkoutScmShallow()
                        }
                    }
                }

                stage('Examples build') {
                    steps {
                        dir("${REPO_NAME}/examples") {
                            xcoreBuild()
                        }
                    }
                }

                stage('Repo checks') {
                    steps {
                        warnError("Repo checks failed")
                        {
                            runRepoChecks("${WORKSPACE}/${REPO_NAME}")
                        }
                    }
                }

                stage('Doc build') {
                    steps {
                        dir(REPO_NAME) {
                            buildDocs()
                        }
                    }
                }

                stage ("Tests") {
                    steps {
                        withTools(params.TOOLS_VERSION) {
                            dir("${REPO_NAME}/tests") {
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

                stage("Archive sandbox") {
                    steps {
                        archiveSandbox(REPO_NAME)
                    }
                }
            } // stages
            post {
                cleanup {
                    xcoreCleanSandbox()
                }
            }
        } // stage 'Build and test'

        stage('🚀 Release') {
            steps {
                triggerRelease()
            }
        }
    } // stages
} // pipeline

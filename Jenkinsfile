@Library('sym-pipeline') _
import com.symphony.cicd.CICDConstants
import com.symphony.cicd.SymphonyCICDUtils
import com.symphony.cicd.util.GitHubUtils
import groovy.json.JsonSlurperClassic

node(){
    SymphonyCICDUtils cicdUtils = new SymphonyCICDUtils()
    echo "current build number: ${currentBuild.number}"
    echo "previous build number: ${currentBuild.previousBuild.getNumber()}"
    //githubNotify context: 'Notification key', description: 'This is a shorted example',  status: 'SUCCESS'
    echo CICDConstants.POST_PROCESSING_VALIDATION
    echo "${env.BUILD_URL}"
    shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
    echo shortCommit
    echo CICDConstants.GH_STATUS_FAILURE

}

@Library('sym-pipeline') _
import com.symphony.cicd.CICDConstants
import com.symphony.cicd.SymphonyCICDUtils
import com.symphony.cicd.util.GitHubUtils
import groovy.json.JsonSlurperClassic

node(){
    SymphonyCICDUtils cicdUtils = new SymphonyCICDUtils()
    echo "current build number: ${currentBuild.number}"
    echo "previous build number: ${currentBuild.previousBuild.getNumber()}"
     echo "current build number: ${currentBuild.sha}"
    echo CICDConstants.POST_PROCESSING_VALIDATION
    echo "${env.BUILD_URL}"
    echo CICDConstants.GH_STATUS_FAILURE

}

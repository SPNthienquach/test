@Library('sym-pipeline') _
import com.symphony.cicd.CICDConstants
import com.symphony.cicd.SymphonyCICDUtils
import com.symphony.cicd.util.GitHubUtils
import groovy.json.JsonSlurperClassic

node(){
    SymphonyCICDUtils cicdUtils = new SymphonyCICDUtils()
    def PULL_REQUEST = env.CHANGE_ID
    echo "PULL_REQUEST2"
    echo PULL_REQUEST
    echo CICDConstants.POST_PROCESSING_VALIDATION
    echo "${env.BUILD_URL}"
    echo CICDConstants.GH_STATUS_FAILURE
    cicdUtils.sendStatusToPullRequest(CICDConstants.POST_PROCESSING_VALIDATION,CICDConstants.GH_STATUS_FAILURE,
                "Post processing has failed. More details in build logs", "${env.BUILD_URL}")
}

@Library('sym-pipeline') _
import com.symphony.cicd.CICDConstants
import com.symphony.cicd.SymphonyCICDUtils
import com.symphony.cicd.util.GitHubUtils
import groovy.json.JsonSlurperClassic

node(){
    SymphonyCICDUtils cicdUtils = new SymphonyCICDUtils()
    def PULL_REQUEST = env.CHANGE_ID
    echo "PULL_REQUESTe"
    echo "${PULL_REQUEST}"
    echo "${env.CHANGE_ID}"
    echo "CHANGE_ID"
    echo env.CHANGE_ID
    echo CICDConstants.POST_PROCESSING_VALIDATION
    echo "${env.BUILD_URL}"
    echo CICDConstants.GH_STATUS_FAILURE
   // def a = automerge()
    prHeadHash = cicdUtils.getHeadShaForPR("SPNthienquach","test",env.CHANGE_ID)
    print prHeadHash

}

@Library('sym-pipeline') _
import com.symphony.cicd.CICDConstants
import com.symphony.cicd.SymphonyCICDUtils
import com.symphony.cicd.util.GitHubUtils
import groovy.json.JsonSlurperClassic
github.com/SPNthienquach/test/
node(){
    withEnv([
        "JOB_NAME=github.com/SPNthienquach/test/${env.CHANGE_BRANCH}"
    ]){
    SymphonyCICDUtils cicdUtils = new SymphonyCICDUtils()
   
   // def a = automerge()
    String prHeadHash = cicdUtils.getHeadShaForPR("SPNthienquach","test","${env.CHANGE_ID}")
    automerge(prHeadHash)
    }

}

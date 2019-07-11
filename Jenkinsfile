@Library('sym-pipeline') _
import com.symphony.cicd.CICDConstants
import com.symphony.cicd.SymphonyCICDUtils
import com.symphony.cicd.util.GitHubUtils
import groovy.json.JsonSlurperClassic

node(){
    SymphonyCICDUtils cicdUtils = new SymphonyCICDUtils()
   
   // def a = automerge()
    prHeadHash = cicdUtils.getHeadShaForPR("SPNthienquach","test","${env.CHANGE_ID}")
    print prHeadHash

}

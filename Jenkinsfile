@Library('sym-pipeline') _
import com.symphony.cicd.CICDConstants
import com.symphony.cicd.SymphonyCICDUtils
import com.symphony.cicd.util.GitHubUtils
import com.symphony.cicd.NotificationUtils
import groovy.transform.Field
import java.io.File
node(){  
	def scmVars = checkout scm	
withEnv(["GIT_REPO=test",
	// "CHANGE_ID=50",
	 "JOB_NAME=https://github.com/SPNthienquach/test/${env.CHANGE_BRANCH}"
	 ]){
	   echo "============" + env.JOB_NAME
     
      stage("Clean work-space") {
            // 4. At this point, a valid report can certainly be issued
            String finalStatus = CICDConstants.UNIT_TESTS_STATUS_NAME
            String statusMessage = 'Pull request is allowed'

            // Send final report as PR comment
	    GitHubUtils gitHubUtils = new GitHubUtils()
            def commentPayload = gitHubUtils.sendCommentOnPR(
                    "test-pr",
                    "${currentBuild.number.toInteger()}"
            )

            // Set GitHub pull request status
	  	SymphonyCICDUtils cicdUtils = new SymphonyCICDUtils()
          cicdUtils.addStatusToPullRequest(
                    "${CICDConstants.NEMESIS_STATUS}",
                    "${finalStatus}",
                    "This is not good",
                    "${commentPayload.html_url}"
            )

            cleanWs()
        }
    }     

}

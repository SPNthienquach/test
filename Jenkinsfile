@Library('sym-pipeline') _
import com.symphony.cicd.CICDConstants
import com.symphony.cicd.SymphonyCICDUtils
import com.symphony.cicd.util.GitHubUtils
import com.symphony.cicd.NotificationUtils
import groovy.transform.Field

import com.cloudbees.groovy.cps.NonCPS
import com.symphony.cicd.util.review.Review
import com.symphony.cicd.util.review.ReviewStatusEnum
import groovy.json.JsonSlurperClassic
import groovy.json.JsonSlurper
import com.symphony.cicd.CICDConstants
import com.symphony.cicd.SymphonyCICDUtils
import com.symphony.cicd.GitRepository
import com.symphony.cicd.ProjectEnum
import groovy.json.*
import com.symphony.cicd.util.exceptions.FileNotFoundException
import com.symphony.cicd.Utils
import com.symphony.cicd.SatRobotDescriptor
import org.kohsuke.github.GHCommit
import org.kohsuke.github.GHRepository
import org.kohsuke.github.GitHub

import java.util.regex.Matcher
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

            // Set GitHub pull request status
	  	SymphonyCICDUtils cicdUtils = new SymphonyCICDUtils()
          cicdUtils.addStatusToPullRequest(
                    "${CICDConstants.NEMESIS_STATUS}",
                    "${finalStatus}",
                    "This is not good",
                    "https://system-lab.dev.symphony.com/jenkins/view/War-Dashboard/job/testPR/view/change-requests/job/PR-10/18/console"
            )

            cleanWs()
        }
    }     

}

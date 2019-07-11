@Library('sym-pipeline') _
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
import com.symphony.cicd.util.GitHubUtils
import java.util.regex.Matcher

/**
 * Conditions to automerge (all must be true):
 *
 * - PR is mergeable, mergeable GitHub PR property
 * - PR is not blocked: it would be blocked if there is missing status checks or code reviews
 * - target branch is RC-*
 * - PR is labeled with 'do not merge'
 *
 */

def isBuildSuccessful() {
    if (!currentBuild.result) {
        echo "[WARNING] build result not set"
    }

    if ((!currentBuild.result) || currentBuild.result == CICDConstants.SUCCESS) {
        return true
    } else {
        return false
    }
}

/**
 * gitHubCheck returns a list of strings, if there are a restriction by github and if it is possible to do the automerge.
 *
 * @param issueNumber the PR number (this will determine witch statuses are required)
 * @param github
 *
 * @return returns a list of strings with why for the github is not possible to do the automerge
 */
def gitHubCheck(issueNumber, github) {
    def noMergeReasons = []

    def pr = github.getPullRequest(issueNumber)

    // Check if there is a restriction on Github side.
    if (!pr.getMergeable()) {
        noMergeReasons.add("PR not mergeable")
    }

    // Also a GitHub restriction, the mergeable_state will be blocked if the PR is waiting for a review, for example.
    if (pr.getMergeableState() != 'clean' && pr.getMergeableState() != 'unstable') {
        noMergeReasons.add("PR mergeable_state=" + pr.getMergeableState())
    }

    // Do not auto-merge if requested by label "DO NOT MERGE"
    if (github.pullRequestHasLabel(issueNumber, CICDConstants.DO_NOT_MERGE_LABEL)) {
        noMergeReasons.add("Requested by ${CICDConstants.DO_NOT_MERGE_LABEL} label")
    }

    pr = null

    return noMergeReasons
}

def call1(prHeadHash, deleteBranch=false) {
    echo "automerge process starting"

    SymphonyCICDUtils util = new SymphonyCICDUtils()
    LinkedHashMap repoInfo = util.repoInformation()
    int issueNumber = env.CHANGE_ID.toInteger()

    // -----------------------------------------------------------------------------------------------------------------
    // Auto-merge the PR, if appropriate :)
    // -----------------------------------------------------------------------------------------------------------------
    boolean isMergeable = true
    def noMergeReasons = []

    // Check if the build is successful
    if (!isBuildSuccessful()) {
        // Also set isMergeable to false. This is an extra protection, as mergeable_state will be "blocked" if we
        // do not send the continuous-integration/jenkins/pr-merge check.
        noMergeReasons.add("Build failed")
        isMergeable = false
    }

    // Check if the user disabled auto-merge functionality
    if (env.DISABLE_AUTO_MERGE && env.DISABLE_AUTO_MERGE == "true") {
        noMergeReasons.add("Auto merge is disabled by DISABLE_AUTO_MERGE")
        isMergeable = false
    }

    // Do not auto-merge when target branch is RC or master
    if (util.isTargetProtected()) {
        noMergeReasons.add("RC/Master Branch must be merged by QA")
        isMergeable = false
    }

    // Validate that the commit has all the required status for the PR target branch as successful.
    GitHubUtils ghUtil = new GitHubUtils()
    def ignoreList = [CICDConstants.PR_MERGE_STATUS_NAME]
    if (!ghUtil.isCommitValid(prHeadHash, issueNumber, ignoreList)) {
        noMergeReasons.add("Not all PR required status are successful")
        isMergeable = false
    }

    // Check if the PR can be merged from GitHub information on the PR
    def github = GitHubClient.CreateGitHubClient(util, repoInfo.org, repoInfo.repo, steps)
    def reasons = gitHubCheck(issueNumber, github)
    if (reasons.size() > 0) {
        isMergeable = false
        noMergeReasons += reasons
    }

    def msg = ''
    if (isMergeable) {
        echo "Auto-merging the PR"
        String commitMessage = "Your PR build passed! Warp Drive Automerge"
        if (github.mergePullRequest(issueNumber, commitMessage, deleteBranch)) {
            echo "Auto-merge succeeded"
        }
    } else {
        echo "The PR will *not* be auto-merged"
        for (int i = 0; i < noMergeReasons.size(); i++) {
            msg += noMergeReasons[i] + "\n"
        }
        echo msg
        sendCommentOnPR("AUTOMERGE RESULTS:\n${msg}", env.CHANGE_ID.toInteger())
    }

    // remove GitHubClient from the object stack (non serializable)
    github = null
    // remove GitHubUtils from the object stack (non serializable)
    ghUtil = null

    return isMergeable
}
/**
 * Put a comment on a Pull Request
 * @param comment
 * @param prNumber
 * @return
 */
def sendCommentOnPR(comment, prNumber) {
    echo "Sending comment on PR"
    SymphonyCICDUtils util = new SymphonyCICDUtils()
    LinkedHashMap repoInfo = util.repoInformation()
    def gitHubToken = util.getSecretTextCredential('symphonyjenkinsauto-token')
    def map = ["body": "${comment}"]
    def payload = JsonOutput.toJson(map)
    def url = new URL("https://api.github.com/repos/${repoInfo.org}/${repoInfo.repo}/issues/${prNumber}/comments?access_token=${gitHubToken}")
    def connection = url.openConnection()

    connection.setRequestMethod("POST")
    connection.setRequestProperty("Content-Type", "application/json")
    connection.doOutput = true

    def writer = new OutputStreamWriter(connection.outputStream)
    writer.write(payload)
    writer.flush()
    writer.close()
    connection.connect()

    def postRC = connection.getResponseCode()
    def postRM = connection.getResponseMessage()
    def commentPayload = new JsonSlurperClassic().parseText("${connection.getContent()}")

    echo "Send comment response: ${postRC}"
    echo "Send comment response message: ${postRM}"
    echo "Comment ID: ${commentPayload.id}"

    return commentPayload
}
node(){
    withEnv([
        "JOB_NAME=github.com/SPNthienquach/test/${env.CHANGE_BRANCH}"
    ]){
    SymphonyCICDUtils cicdUtils = new SymphonyCICDUtils()
   
   // def a = automerge()
    String prHeadHash = cicdUtils.getHeadShaForPR("SPNthienquach","test","${env.CHANGE_ID}")
    call1(prHeadHash)
    }

}

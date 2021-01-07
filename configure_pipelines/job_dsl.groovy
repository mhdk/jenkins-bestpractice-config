def pipelines = [
    [name: 'job1', scriptPath: 'Hello_World/Jenkinsfile'],
    [name: 'job2', scriptPath: 'Hello_World/Jenkinsfile']
]

for(p in pipelines) {
	pipelineJob("${p.name}") {
	    definition {
	        cpsScm {
	            scm {
	                git {
	                  remote {
	                    name('github')
	                    url('https://github.com/whayward-stfc/jenkins-test-applications.git')
	                  }
	                  branch('master')
	                  extensions {
	                  	cloneOptions {
	                  	  shallow(true)
	                  	  depth(1)
						  noTags(true)
	                  	}
	                  }
	                }
	            }
	            scriptPath("${p.scriptPath}")
	        }
	    }
	    triggers {
	        cron('H H(1-8) * * *')
	    }
	}
}
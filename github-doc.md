# Git stuff on github.com

Git has its quirks and with all possible options can become confusing. The following is a collection of things I learned and need to remember. Much of it is based on my very incomplete understanding of git.

### Cloning

With a sshkey policy only in place cloning has become problematic at times. Use the right syntax and it should work.

    git clone git@github.com:mit-submit/submit-users-guide.git


### Setting up a remote url location

Setting up the remote url is essential for push it seems. You can only execute the below example command when inside the github area ('Config').

    git remote set-url origin git@github.com:cpausmit/Config



###Steps to install SAM(Serverless Application Model) CLI on Linux
* Install pip from [here](https://pip.pypa.io/en/stable/installing/).
* Install AWS CLI from [here](https://docs.aws.amazon.com/cli/latest/userguide/).
* Install Docker from [here](https://www.docker.com/).
* Install the AWS SAM CLI (https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
  * On Linux using pip, make sure the python version is  2.7 or 3.6.:
    ```bash
    pip install --user aws-sam-cli

    ````
  * Adjust your PATH to include the Python scripts that are installed under the user's home directory:
    ```bash 
     # Find your Python User Base path (where Python --user will install packages/scripts)
     $ USER_BASE_PATH=$(python -m site --user-base)

     # Update your preferred shell configuration
     -- Standard bash --> ~/.bash_profile
     -- ZSH           --> ~/.zshrc
     $ export PATH=$PATH:$USER_BASE_PATH/bin
    ```
  * Check SAM version:
    ```bash
     sam --version
    ```
  * Complete installation is [here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-additional.html#serverless-sam-cli-install-using-pip).
*Test example application (https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-quick-start.html)
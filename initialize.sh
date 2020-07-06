#!/bin/bash
#
#       Initializes the repository
#

#
#   Path to the directory with this script
#
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


#
#   Path to the configuration file
#
CONFIGURATION_FILE_PATH=~/.choco-scripts.cfg

#
#   Verification of the choco scripts installation
#
if [ -f "$CONFIGURATION_FILE_PATH" ]
then 
    source $CONFIGURATION_FILE_PATH
else 
    printf "\033[31;1mChoco-Scripts are not installed for this user\033[0m\n"
    exit 1
fi

#
#   Information message
#
echo "Using choco-scripts from path $CHOCO_SCRIPTS_PATH in version $CHOCO_SCRIPTS_VERSION"

#
#   Importing of the framework main script
#
source $(getChocoScriptsPath)

#
#   The function prepares a framework script to work
#
function prepareScript()
{
    defineScript "$0" "The script is for initialization of the repository"
       
    addCommandLineOptionalArgument USE_DOCKER "--use-docker" "bool" "If true, the script uses docker for building of the package" "FALSE"

    parseCommandLineArguments "$@"
}

#######################################################################################
#
#   MAIN
#
prepareScript "$@"

doCommandAsStep "GIT Submodules initialization" git submodule init
doCommandAsStep "GIT Submodules update" git submodule update
doCommandAsStep "Applying custom changes to the swagger repository" cp -r ./modules ./repository/
cd repository
if [ "$USE_DOCKER" == "TRUE" ]
then 
    doCommandAsStep "Building swagger-codegen" ./run-in-docker.sh mvn clean package
else 
    doCommandAsStep "Building swagger-codegen" ./mvnw clean package
fi
cd $THIS_DIR

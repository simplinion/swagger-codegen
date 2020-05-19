#!/bin/bash
#
#       Builds an image for generation of the code
#

#
#   Path to the directory with this script
#
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


#
#   Path to the configuration file
#
CONFIGURATION_FILE_NAME=.choco-scripts.cfg
CONFIGURATION_FILE_PATH=~/$CONFIGURATION_FILE_NAME

#
#   Verification of the choco scripts installation
#
if [ -f "$CONFIGURATION_FILE_PATH" ]
then 
    source $CONFIGURATION_FILE_PATH
else 
    printf "\033[31;1mChoco-Scripts are not installed for user '$USER' at '$HOME'\033[0m\n"
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
    defineScript "$0" "Builds an image for generation of the code"
    
    addCommandLineOptionalArgument REPOSITORY_NAME "-r|--repository" "not_empty_string" "Name of the dockerhub repository" "chocotechnologies"
    addCommandLineOptionalArgument IMAGE_NAME "-i|--image-name" "not_empty_string" "Name of the image to publish" "swagger-codegen" 
    addCommandLineRequiredArgument VERSION "-v|--version" "not_empty_string" "Version of the image to build"
    
    parseCommandLineArguments "$@"
}

#
#   Builds the image
#
function buildImage()
{
    local fullImageName=$REPOSITORY_NAME/$IMAGE_NAME
    doCommandAsStep "Building of image $fullImageName" docker build -t "$fullImageName" -f Dockerfile .
    doCommandAsStep "Tagging of image $fullImageName with version $VERSION" docker tag "$fullImageName:latest" "$fullImageName:$VERSION"
    doCommandAsStep "Pushing of the image $fullImageName:$VERSION" docker push $fullImageName:$VERSION
    doCommandAsStep "Pushing of the image $fullImageName:latest" docker push $fullImageName:latest
}

#######################################################################################
#
#   MAIN
#
prepareScript "$@"
buildImage

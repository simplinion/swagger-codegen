#!/bin/bash
#
#       Generates only the API documentation
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
    defineScript "$0" "The script is for generation of REST API documentation only. Please remember to call initialize.sh script first"
    
    addCommandLineOptionalArgument MODULE "-m|--module" "options" "Name of swagger-codegen module to use" "php-symfony" "php-symfony php"
    addCommandLineRequiredArgument TARGET_PATH "-t|--target-path" "directory" "Target directory for the generated documentation"
    addCommandLineRequiredArgument YAML_PATH "-i|--input" "existing_file" "Yaml file with definition of the interface"
    addCommandLineOptionalArgument SWAGGER_JAR_FILE "--jar" "file" "Path to the previously compiled swagger-codegen." "$THIS_DIR/repository/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    addCommandLineOptionalArgument SWAGGER_OPTS "-o|--options" "string" "Additional parameters to be added to the swagger-codegen command" ""
    
    addRequiredTool java "JAVA is required for the swagger-codegen, to execute the JAR file" "TRUE" "sudo apt-get install default-jdk"
    
    parseCommandLineArguments "$@"
}

#
#   Generates the documentation only
#
function generate()
{
    doCommandAsStep "Generation of the documentation for $YAML_PATH at the path $TARGET_PATH/docs" java -DapiDocs -DmodelDocs -jar "$SWAGGER_JAR_FILE" generate -i "$YAML_PATH" -l "$MODULE" -o "$TARGET_PATH/docs" $SWAGGER_OPTS
}

#######################################################################################
#
#   MAIN
#
prepareScript "$@"
generate

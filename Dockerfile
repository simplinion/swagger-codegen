#
#   Docker image for swagger-codegen 
#
FROM chocotechnologies/scripts:1.0.4

#
#   Disabling interactive mode
#
ENV DEBIAN_FRONTEND=noninteractive

#
#   Install JDK for executing of swagger
#
RUN apt-get update
RUN apt-get install -y default-jdk

#
#   Install GIT because it is required in swagger pipelines and
#   it does not make any sense to create a separate image just for that
#
RUN apt-get install -y git

#
#   Some installation in the packages are interactive, so we 
#   want to force noninteractive mode
#
RUN ln -fs /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
RUN apt-get install -y tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get install -y sudo

#
#   Configuration of paths in the image
#
ENV SWAGGER_DIR=/swagger
ENV SWAGGER_JAR_FILE=$SWAGGER_DIR/swagger-codegen-cli.jar
ENV GENERATE_FILE=$SWAGGER_DIR/generate.sh

#
#   Copying of all the required swagger files to the image
#
RUN mkdir -p $SWAGGER_DIR
COPY repository/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar $SWAGGER_JAR_FILE
COPY generate.sh $GENERATE_FILE
RUN printf "y\n8\n" | $GENERATE_FILE --install-all-required

#
#   Creation of linked generate script
#
RUN echo 'alias generate="$GENERATE_FILE --jar='$SWAGGER_JAR_FILE'"' >> ~/.bashrc

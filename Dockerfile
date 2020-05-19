#
#   Docker image for swagger-codegen 
#
FROM chocotechnologies/scripts:1.0.3

RUN apt-get update
RUN apt-get install -y default-jdk
RUN apt-get install -y git

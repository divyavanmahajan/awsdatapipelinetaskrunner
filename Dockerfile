FROM openjdk:7
COPY . /usr/src/taskrunner
WORKDIR /usr/src/taskrunner
RUN curl -O http://s3.amazonaws.com/datapipeline-us-east-1/us-east-1/software/latest/TaskRunner/TaskRunner-1.0.jar 
RUN curl -O http://s3.amazonaws.com/datapipeline-prod-us-east-1/software/latest/TaskRunner/mysql-connector-java-bin.jar
CMD ["/usr/src/taskrunner/run.sh"]
VOLUME /usr/src/taskrunner

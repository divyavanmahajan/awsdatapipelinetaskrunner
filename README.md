# Java taskrunner for AWS Datapipeline

This Docker image is based off [openjdk](https://hub.docker.com/_/openjdk/). It runs a [AWS Datapipeline Task Runner](http://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-how-remote-taskrunner-client.html). Each activity in a data pipeline executes on a task runner.

## Demo
```sh
docker run --detach --name taskrunner \
    --env WORKERGROUP="myworkergroup" \
    --env REGION="us-east-1" \
    --env LOGURI="s3://mybucket/logpath/myworkergroup" \
    --env ACCESSID="AKIAJTVPEXXXXWD2VRXX" \
    --env SECRETKEY="Iz6BU1/w65+6JY4SIWm+xDOkK7XXXXXXXXXXXXXX" 
    vanmahajan/awsdatapipelinetaskrunner
```

Create a datapipeline and set the "workergroup" of an activity to "myworkergroup". Execute the datapipeline to see the taskrunner execute your activity.

## What is a Datapipeline Task Runner
Task Runner is a task agent application that polls AWS Data Pipeline for scheduled tasks and executes them on Amazon EC2 instances, Amazon EMR clusters, or other computational resources, reporting status as it does so. Depending on your application, you may choose to:

* Allow AWS Data Pipeline to install and manage one or more Task Runner applications for you. When a pipeline is activated, the default Ec2Instance or EmrCluster object referenced by an activity runsOn field is automatically created. AWS Data Pipeline takes care of installing Task Runner on an EC2 instance or on the master node of an EMR cluster. In this pattern, AWS Data Pipeline can do most of the instance or cluster management for you.
* Run all or parts of a pipeline on resources that you manage. The potential resources include a long-running Amazon EC2 instance, an Amazon EMR cluster, or a physical server. You can install a task runner (which can be either Task Runner or a custom task agent of your own devise) almost anywhere, provided that it can communicate with the AWS Data Pipeline web service. In this pattern, you assume almost complete control over which resources are used and how they are managed, and you must manually install and configure Task Runner. To do so, use the procedures in this section, as described in [Executing Work on Existing Resources Using Task Runner](http://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-how-task-runner-user-managed.html).

In the default setup of a data pipeline, a new EC2 instance is started to run your task. However, you can use the 'workerGroup' 
parameter to direct the activity to a specific set of task runners. This docker image has all the setup to run the [default Java task runner](http://aws.amazon.com/developertools/AWS-Data-Pipeline/1920924250474601).
Customize the Dockerfile to add your own commands.

This is useful in the following situations
* Reduce waiting time by avoiding starting up a new EC2 instance to execute a task.
* Run the activity inside your firewall to access an internal database.
* Troubleshooting an activity in a pipeline.
* Running shell scripts and custom commands.


## Environment variables
To run you must set the following environment variables in your Docker command line or Kitematic UI.

Variable | Description
-------- | -----------
 WORKERGROUP | The AWS Datapipeline workergroup that this taskrunner will monitor. e.g. myWorkergroup
 REGION | AWS Region of the datapipeline. e.g. us-east-1
 LOGURI | S3 url to store the log files. After execution of a datapipeline activity, the logs of the activity are pushed to this location. This makes it easier to debug if you don't have access to the taskrunner file system. e.g. s3://yourbucket/path-to-logs
 ACCESSID | AWS access ID of the user or IAM role. This user should have IAM privileges of DataPipelineResourceRole.
 SECRETKEY | AWS secret key for the above access ID.

## Troubleshooting

The image exposes `/usr/src/taskrunner` which stores the log files locally before they are sent to S3. If there is a problem connecting to AWS, you should check these log files.
`run.sh` contains the following to 
```sh
java -jar TaskRunner-1.0.jar --workerGroup=${WORKERGROUP} --region=${REGION} --logUri=${LOGURI} --accessId=${ACCESSID} --secretKey=${SECRETKEY}
```
## 

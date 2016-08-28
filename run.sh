#!/bin/sh
java -jar TaskRunner-1.0.jar --workerGroup=${WORKERGROUP} --region=${REGION} --logUri=${LOGURI} --accessId=${ACCESSID} --secretKey=${SECRETKEY}

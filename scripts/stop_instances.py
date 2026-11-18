import boto3
import json
from botocore.exceptions import ClientError
# tags = {
#     "env" : ["dev"],
#     "schudule_to_stop" : ["true"]
# }
# region = "us-east-1"

def stop_instance(tags,region):
    ec2 = boto3.client("ec2", region_name=region)
    tags_filter = [
        {'Name': f'tag:{key}', 'Values': values }
        for key, values in tags.items()
        ]
    tags_filter.append({"Name": "instance-state-name","Values": ["running"]})
    try:
        response = ec2.describe_instances(
            Filters = tags_filter
        )
        instances = []
        for reservations in response["Reservations"]:
            for instanceId in reservations["Instances"]:
                instances.append(instanceId['InstanceId'])
                print(f"instance ID: {instanceId['InstanceId']},Instance Status: {instanceId['State']['Name']}")
        print(instances)
        if instances:
            response = ec2.stop_instances(InstanceIds=instances)
            print("Stop request submitted:", instances)
        else:
            print("No running instances found to stop.")
    except ClientError as e:
        print(f"client errot :{e}")


def lambda_handler(event, context):
    tags = {
            "env" : ["dev"],
            "schedule_to_stop" : ["true"]
            }
    region = "us-east-1"
    stop_instance(tags,region)
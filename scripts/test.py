# def tag(tags):
#     tags_filter = [
#                     {'Name': f'tag:{key}', 'Values': f'{values}'}
#                     for key, values in tags.items()
#                 ]
#     print(tags_filter)

# t = {
#     "test_key" : ["test_value", "test_value2"]
# }
# tag(t)
tags = {"test_key" : ["test_value", "test_value2"]}

tags_filter = [
        {'Name': f'tag:{key}', 'Values': values}
        for key, values in tags.items()
        ]
tags_filter.append({"Name": "instance-state-name","Values": ["running"]})

print(tags_filter)



    # response = ec2.describe_instances(
    #     Filters = [
    #         {"Name": "instance-state-name","Values": ["running"]},
    #         {"Name": "tag:env", "Values": ["dev"]},
    #         {"Name": "tag:schudule_to_stop", "Values": ["true"]}
    #     ]
    # )
# print(response)
# with open("./response.json", "w", encoding="utf-8") as file:
#     json.dump(response, file, indent=4, default=str)
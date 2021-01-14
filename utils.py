import json

def get_target_group_arns():
    with open('response.json') as f:
        resp = json.load(f)

    output = "\n"

    if (resp != None and resp != {}):
        for target_group in resp['TargetGroups']:
            
            output+="Name:\t{}\n".format(target_group['TargetGroupName'])
            output+="ARN:\t{}\n\n".format(target_group['TargetGroupArn'])

    f.close()
    return(output)
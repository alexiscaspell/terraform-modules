#!/usr/bin/env python3

import json
import logging
import os
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)
logging.getLogger('boto3').setLevel(logging.CRITICAL)
logging.getLogger('botocore').setLevel(logging.CRITICAL)

def send_to_teams(teams_message, teams_webhook_url):
    status = False

    headers = {
        'Content-Type': 'application/json'
    }

    LOGGER.info("Sending message to teams:")
    LOGGER.info(teams_message)

    req = Request(teams_webhook_url, json.dumps(teams_message).encode('utf-8'),headers=headers)

    try:
        LOGGER.info(f"Calling webhook {teams_webhook_url} ...")

        response = urlopen(req)
        response.read()
        LOGGER.info("Message posted to Teams channel")
        status = True
    except HTTPError as e:
        LOGGER.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        LOGGER.error("Error sending Teams message: %s", e.reason)

    return status

def lambda_handler(event, context):
    LOGGER.info('REQUEST RECEIVED: {}'.format(json.dumps(event, default=str)))

    message = json.dumps(event)
    message = json.loads(message)
    sns_message = message['Records'][0]['Sns']['Message']
    LOGGER.info("Message: " + str(sns_message))

    teams_webhook_url = os.environ.get('TEAMS_WEBHOOK')

    try:
        sns_alarm_body = json.loads(sns_message)
        teams_message = f"""
            {sns_alarm_body['AlarmName'].upper()}
            {sns_alarm_body["AlarmDescription"]}
            Status ANTERIOR: {sns_alarm_body.get('OldStateValue','Indeterminado')}
            Status ACTUAL: {sns_alarm_body.get('NewStateValue','Indeterminado')}
            """
        
    except Exception as _:
        teams_message = sns_message
    
    teams_body = {
        'text': teams_message
    }

    if teams_webhook_url:
        status = send_to_teams(teams_body, teams_webhook_url)
    else:
        LOGGER.error("Unable to obtain the Teams webhook URL to post to")
        status = False

    return {
        'statusCode': 200 if status else 500,
        'body': json.dumps({'success': status})
    }

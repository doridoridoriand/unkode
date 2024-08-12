
# $MESSAGE="Hi I am a bot that can post messages to any public channel."
# $CHANNEL_ID=C123456
# $SLACK_TOKEN=xoxb-not-a-real-token-this-will-not-work

curl -d "text=$MESSAGE" -d "channel=$CHANNEL_ID" -H "Authorization: Bearer $SLACK_TOKEN" -X POST https://slack.com/api/chat.postMessage

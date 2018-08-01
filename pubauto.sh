echo "enter topic name: "
read topic_name
echo "enter subscription name: "
read sub_name
echo "function name:"
read function_name
#create topic
gcloud pubsub topics create $topic_name
#create subscription
gcloud pubsub subscriptions create $sub_name --topic $topic_name
mkdir pubsubcode
cd pubsubcode
#copying files from the buckets
gsutil cp gs://utsav-pe/main.py main.py
gsutil cp gs://utsav-pe/requirements.txt requirements.txt
# trigger cloud function
gcloud beta functions deploy $function_name --runtime python37 --entry-point hello_pubsub --trigger-resource $topic_name --trigger-event google.pubsub.topic.publish
echo "enter publish message: "
read message
gcloud pubsub topics publish $topic_name --message "$message"

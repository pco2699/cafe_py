#!/usr/bin/env python
# -*- coding: utf-8 -*-

import paho.mqtt.client as mqtt

MQTTHOST = "localhost"

# 3.1.1用のClientを作成します
client = mqtt.Client()

# メッセージを受信した時に呼ばれる。
def on_message(mqttc, obj, msg):
    print("Hoge")
    print(str(msg.payload))
    data = str(msg.payload)

    f = open('data.txt', 'w')
    f.write(str(data.count('person')))
    f.close()

def on_connect(client, userdata, flags, respons_code):
    print('status {0}'.format(respons_code))


# 接続します
client.connect(MQTTHOST, port=1883)

TOPIC = "berrynet/dashboard/inferenceResult"

client.on_message = on_message
client.on_connect = on_connect
# Subssibeします
client.subscribe(TOPIC)

# メッセージを待ち受けるループに入ります
client.loop_forever()

#!/usr/bin/env python
# -*- coding: utf-8 -*-

import paho.mqtt.client as mqtt

MQTTHOST = "localhost"

# 3.1.1用のClientを作成します
client = mqtt.Client()

# メッセージを受信した時に呼ばれる。
def on_message(mqttc, obj, msg):
    data = str(msg.payload)

    f = open('data.txt', 'w')
    f.write(str(data.count('person')))
    f.close()

# 接続します
client.connect(MQTTHOST, port=1883)

TOPIC = "berrynet/dashboard/inferenceResult"

client.on_message = on_message
# Subssibeします
client.subscribe(TOPIC)

# メッセージを待ち受けるループに入ります
client.loop_forever()

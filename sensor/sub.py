#!/usr/bin/env python
# -*- coding: utf-8 -*-

import paho.mqtt.client as mqtt

MQTTHOST = "localhost"
USERNAME = "example@github"
PASSWORD = "password"

# 3.1.1用のClientを作成します
client = mqtt.Client(protocol=mqtt.MQTTv311)

# メッセージを受信した時に呼ばれる。
def on_message(mqttc, obj, msg):
    data = str(msg.payload)

    f = open('data.txt', 'w')
    f.write(data.count('person'))
    f.close()

# 接続します
client.connect(MQTTHOST)

TOPIC = ""
# Subscribeします
client.subscribe(TOPIC)

# メッセージを待ち受けるループに入ります
client.loop_forever()

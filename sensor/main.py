# -*- coding: utf-8 -*-

import datetime
import grovepi
import plotly.tools as tls
from time import sleep
import plotly.graph_objs as go
import plotly.plotly as py
import requests
import json

TEMP_HUMID_PORT = 7  # 温湿度を取得するポートはD7
LOUDNESS_PORT = 0  # 騒音センサーを取得するポートはA0
LIGHT_PORT = 1  # 照度センサーを取得するポートはA1
AIR_PORT = 2  # 空気の綺麗さを取得するポートはA2


class Plotly_writer:
    def __init__(self):
        self.stream_ids = tls.get_credentials_file()['stream_ids']

        # Get stream id from stream id list
        self.stream_id1 = self.stream_ids[0]
        self.stream_id2 = self.stream_ids[1]


        # Make instance of stream id object
        self.stream_1 = go.Stream(
            token=self.stream_id1,  # link stream id to 'token' key
            maxpoints=80  # keep a max of 80 pts on screen
        )

        # Make instance of stream id object
        self.stream_2 = go.Stream(
            token=self.stream_id2,  # link stream id to 'token' key
            maxpoints=80  # keep a max of 80 pts on screen
        )

        # Initialize trace of streaming plot by embedding the unique stream_id
        self.trace1 = go.Scatter(
            x=[],
            y=[],
            mode='lines+markers',
            stream=self.stream_1,  # (!) embed stream id, 1 per trace
            name="loudness"
        )

        self.trace2 = go.Scatter(
            x=[],
            y=[],
            mode='lines+markers',
            stream=self.stream_2,  # (!) embed stream id, 1 per trace
            name="Light"
        )

        self.data = go.Data([self.trace1, self.trace2])

        # Add title to layout object
        self.layout = go.Layout(title='GrovePi Sensor Data')

        # Make a figure object
        self.fig = go.Figure(data=self.data, layout=self.layout)

        # Send fig to Plotly, initialize streaming plot, open new tab
        py.plot(self.fig, filename='python-streaming')

        self.s1 = py.Stream(self.stream_id1)
        self.s2 = py.Stream(self.stream_id2)

    def open_stream(self):
        # We then open a connection
        self.s1.open()
        self.s2.open()

    def write_stream(self, x, loudness, light):
        self.s1.write({"x": x, "y": loudness})
        self.s2.write({"x": x, "y": light})

    def close_stream(self):
        self.s1.close()
        self.s2.close()


class RequestToApi:
    def __init__(self, request_url, **kwargs):
        print(request_url)
        self.request_url = request_url
        self.request_parameter = {}
        for key, value in kwargs.iteritems():
            self.request_parameter[key] = value

    def execute_request(self):
        result = requests.post(self.request_url, data=json.dumps(self.request_parameter))
        print(result.text)


def get_mac(interface):
    # Return the MAC address of interface
    try:
        mac_address = open('/sys/class/net/' + interface + '/address').read()
    except:
        mac_address = "00:00:00:00:00:00"
    return mac_address[0:17]


def main():
    ply = Plotly_writer()
    ply.open_stream()

    mac_address = get_mac('wlan0')

    print("starting post to the api...")

    while True:
        print("fetching data from sensor...")
        # 各種センサー情報の取得
        loudness = grovepi.analogRead(LOUDNESS_PORT)
        light = grovepi.analogRead(LIGHT_PORT)
        air_cleanness = grovepi.analogRead(AIR_PORT)
        (temp, humid) = grovepi.dht(TEMP_HUMID_PORT, 0)

        now_time = datetime.datetime.now().strftime('%Y-%m-%dT%H:%M:%SZ')

        ply.write_stream(x=now_time, loudness=loudness, light=light)

        req = RequestToApi('http://KS-MACBOOK-PRO.local/api/environments/', time=now_time, place=mac_address, loudness=loudness,
                           light=light, air_cleanness=air_cleanness, temp=temp, humid=humid)
        req.execute_request()

        sleep(1)


if __name__ == '__main__':
    main()

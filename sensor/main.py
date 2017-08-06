# -*- coding: utf-8 -*-

import datetime
import grovepi
import plotly.tools as tls
from time import sleep
import plotly.graph_objs as go
import plotly.plotly as py

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
            name="oudness"
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


def main():
    ply = Plotly_writer()
    ply.open_stream()

    while True:
        # 各種センサー情報の取得
        loudness = grovepi.analogRead(LOUDNESS_PORT)
        light = grovepi.analogRead(LIGHT_PORT)
        air_cleaness = grovepi.analogRead(AIR_PORT)
        # (temp, humid) = grovepi.dht(TEMP_HUMID_PORT)

        x = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')

        ply.write_stream(x=x, loudness=loudness, light=light)

        sleep(1)


if __name__ == '__main__':
    main()

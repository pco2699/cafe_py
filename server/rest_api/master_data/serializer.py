# coding: utf-8

from rest_framework import serializers
from .models import Place, Environment


class PlaceSerializer(serializers.ModelSerializer):
    # sensor_mac_address = serializers.CharField(required=False)
    class Meta:
        model = Place
        fields = ('name', 'address', 'sensor_mac_address')


class EnviromentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Environment
        fields = ('place', 'time', 'temp', 'humid', 'light', 'loudness')
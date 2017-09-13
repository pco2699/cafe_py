# coding: utf-8

from rest_framework import serializers
from .models import Place, Environment


class PlaceSerializer(serializers.ModelSerializer):
    # sensor_mac_address = serializers.CharField(required=False)
    class Meta:
        model = Place
        fields = ('id', 'address', 'long', 'lat', 'name', 'sensor_mac_address', 'has_wifi', 'has_power',
                  'is_permitSmoking', 'place_description')


class EnvironmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Environment
        fields = ('id', 'place', 'time', 'temp', 'humid', 'light', 'loudness', 'air_cleanness',
                  'co2_ppm', 'no_of_person')

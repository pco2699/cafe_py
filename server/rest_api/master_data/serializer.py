# coding: utf-8

from rest_framework import serializers
from .models import Place, Environment


class PlaceSerializer(serializers.ModelSerializer):
    # sensor_mac_address = serializers.CharField(required=False)
    class Meta:
        model = Place
        fields = ('id', 'address', 'long', 'lat', 'name', 'sensor_mac_address', 'has_wifi', 'has_power',
                  'is_permitSmoking', 'place_description', 'has_sensor')


class EnvironmentSerializer(serializers.ModelSerializer):
    temp = serializers.DecimalField(max_digits=4, decimal_places=2, coerce_to_string=False)
    humid = serializers.DecimalField(max_digits=4, decimal_places=2, coerce_to_string=False)

    class Meta:
        model = Environment
        fields = ('id', 'place', 'time', 'temp', 'humid', 'light', 'loudness', 'air_cleanness',
                  'co2_ppm', 'no_of_person')

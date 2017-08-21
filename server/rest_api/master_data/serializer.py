# coding: utf-8

from rest_framework import serializers
from .models import Place, Environment


class PlaceSerializer(serializers.ModelSerializer):
    # sensor_mac_address = serializers.CharField(required=False)
    class Meta:
        model = Place
        fields = ('id', 'name')


# class EnvironmentSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Environment
#         fields = ()
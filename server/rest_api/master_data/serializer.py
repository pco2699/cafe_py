# coding: utf-8

from rest_framework import serializers
from .models import Place, Environment


class PlaceSerializer(serializers.ModelSerializer):
    # sensor_mac_address = serializers.CharField(required=False)
    class Meta:
        model = Place
        fields = ('id', 'name')


class EnvironmentSerializer(serializers.Serializer):
    time = serializers.DateTimeField()
    temp = serializers.DecimalField(max_digits=4, decimal_places=2)
    humid = serializers.DecimalField(max_digits=4, decimal_places=2)
    light = serializers.DecimalField(max_digits=3, decimal_places=2)
    loudness = serializers.DecimalField(max_digits=3, decimal_places=2)
    air_cleanness = serializers.DecimalField(max_digits=3, decimal_places=2, default=0)

    def create(self, validated_data):
        return Environment,objects.create(**validated_data)

# Create your views here.
# coding: utf-8

import django_filters
from django.shortcuts import render
from rest_framework import viewsets, filters
from rest_framework.response import Response
from rest_framework.decorators import list_route

from .models import Place, Environment
from .serializer import PlaceSerializer, EnvironmentSerializer


class PlaceViewSet(viewsets.ModelViewSet):
    queryset = Place.objects.all()
    serializer_class = PlaceSerializer


class EnvironmentFilter(filters.FilterSet):
    min_time = django_filters.DateTimeFilter(name="time", lookup_expr='gte')
    max_time = django_filters.DateTimeFilter(name="time", lookup_expr='lte')

    class Meta:
        model = Environment
        fields = ['place', 'min_time', 'max_time']


class EnvironmentViewSet(viewsets.ModelViewSet):
    queryset = Environment.objects.all()
    serializer_class = EnvironmentSerializer
    filter_fields = ('sensor_mac_address')

    @list_route()
    def recent_data(self, request, place=None):
        recent_users = Environment.objects.all().order_by('-time').first()

        serializer = self.get_serializer(recent_users)
        return Response(serializer.data)

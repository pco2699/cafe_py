# Create your views here.
# coding: utf-8

import django_filters
from django.shortcuts import render
from rest_framework import viewsets, filters
from rest_framework.response import Response
from rest_framework.decorators import list_route

from .models import Place, Environment
from .serializer import PlaceSerializer, EnvironmentSerializer


class PlaceFilter(django_filters.FilterSet):
    long = django_filters.RangeFilter()
    lat = django_filters.RangeFilter()
    name = django_filters.CharFilter(lookup_expr=['contains'])

    class Meta:
        model = Place
        fields = ['lat', 'long', 'name']


class PlaceViewSet(viewsets.ModelViewSet):
    queryset = Place.objects.all()
    serializer_class = PlaceSerializer
    filter_class = PlaceFilter


class EnvironmentFilter(django_filters.FilterSet):
    time = django_filters.DateTimeFromToRangeFilter()

    class Meta:
        model = Environment
        fields = ['place', 'time']


class EnvironmentViewSet(viewsets.ModelViewSet):
    queryset = Environment.objects.all()
    serializer_class = EnvironmentSerializer
    filter_class = EnvironmentFilter

    @list_route()
    def recent_data(self, request, place=None):
        recent_users = Environment.objects.all().order_by('-time').first()

        serializer = self.get_serializer(recent_users)
        return Response(serializer.data)

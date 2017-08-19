# Create your views here.
# coding: utf-8

import django_filters
from django.shortcuts import render
from rest_framework import viewsets, filters

from .models import Place, Environment
from .serializer import PlaceSerializer, EnviromentSerializer


class PlaceViewSet(viewsets.ModelViewSet):
    queryset = Place.objects.all()
    serializer_class = PlaceSerializer


class EnviromentViewSet(viewsets.ModelViewSet):
    queryset = Environment.objects.all()
    serializer_class = EnviromentSerializer
# Create your views here.
# coding: utf-8

import django_filters
from django.shortcuts import render
from rest_framework import viewsets, filters
from django.views.decorators.csrf import csrf_exempt
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser

from django.http import HttpResponse, JsonResponse

from .models import Place, Environment
from .serializer import PlaceSerializer, EnvironmentSerializer

@csrf_exempt
def place_list(request):
    if request.method == 'GET':
        snippets = Place.objects.all()
        serializer = PlaceSerializer(snippets, many=True)
        return JsonResponse(serializer.data, safe=False)
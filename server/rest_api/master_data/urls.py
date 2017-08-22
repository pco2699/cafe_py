# coding: utf-8

from .views import PlaceViewSet, EnvironmentViewSet
from django.conf.urls import url
from rest_framework import routers

router = routers.DefaultRouter()
router.register(r'places', PlaceViewSet)
router.register(r'environments', EnvironmentViewSet)

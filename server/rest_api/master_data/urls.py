# coding: utf-8

from rest_framework import routers
from .views import EnvironmentViewSet, PlaceViewSet


router = routers.DefaultRouter()
router.register(r'environments', EnvironmentViewSet)
router.register(r'places', PlaceViewSet)
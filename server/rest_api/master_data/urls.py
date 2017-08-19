# coding: utf-8

from rest_framework import routers
from .views import EnviromentViewSet, PlaceViewSet


router = routers.DefaultRouter()
router.register(r'envrioments', EnviromentViewSet)
router.register(r'places', PlaceViewSet)
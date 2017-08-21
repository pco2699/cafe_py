# coding: utf-8

from .views import place_list
from django.conf.urls import url
from rest_framework import routers

router = routers.DefaultRouter()
router.register(r'places', place_list)

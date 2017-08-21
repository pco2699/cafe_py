# coding: utf-8

from .views import place_list
from django.conf.urls import url

urlpatterns = [
    url(r'^places/$', place_list)
]
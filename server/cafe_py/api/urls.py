from django.conf.urls import url
from . import views

urlpatterns = [
    # 温湿度
    url(r'^v1/temps/$', views.temp_list, name='temp_list'),     # 一覧
    url(r'^v1/temps/add$', views.temp_add, name='temp_add'),     #
]
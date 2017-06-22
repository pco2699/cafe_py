from django.conf.urls import url
from api import views

urlpatterns = [
    # 書籍
    url(r'^v1/temps/$', views.temp_list, name='temp_list'),     # 一覧
]
from django.contrib import admin
from .models import Place,Environment

# Register your models here.


@admin.register(Place)
class PlaceAdmin(admin.ModelAdmin):
    pass


@admin.register(Environment)
class EnvironmentAdmin(admin.ModelAdmin):
    pass


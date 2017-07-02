from django.contrib import admin
from .models import Temp

# Register your models here.
#admin.site.register(Temp)


class TempAdmin(admin.ModelAdmin):
    list_display = ('id', 'temp', 'humid', 'creation_date')
    list_display_links = ('temp', 'humid')

admin.site.register(Temp, TempAdmin)


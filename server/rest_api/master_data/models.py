from django.db import models

# Create your models here.


class Place(models.Model):
    name = models.CharField(max_length=32)
    address = models.CharField(max_length=100)
    long = models.DecimalField(max_digits=15, decimal_places=12, null=True)
    lat = models.DecimalField(max_digits=15, decimal_places=12, null=True)
    sensor_mac_address = models.CharField(max_length=17, unique=True, blank=True)
    has_sensor = models.NullBooleanField()
    has_wifi = models.NullBooleanField()
    has_power = models.NullBooleanField()
    is_permitSmoking = models.NullBooleanField()


class Environment(models.Model):
    place = models.ForeignKey(Place, to_field="sensor_mac_address")
    time = models.DateTimeField()
    temp = models.DecimalField(max_digits=4, decimal_places=2)
    humid = models.DecimalField(max_digits=4, decimal_places=2)
    light = models.IntegerField()
    loudness = models.IntegerField()
    air_cleanness = models.IntegerField()
    co2_ppm = models.IntegerField()

    class Meta:
        unique_together = (("place", "time"),)


class Song(models.Model):
    place = models.ForeignKey(Place)
    time = models.DateTimeField()
    song_name = models.CharField(max_length=20)
    artist_name = models.CharField(max_length=20)

    class Meta:
        unique_together = (("place", "time"),)





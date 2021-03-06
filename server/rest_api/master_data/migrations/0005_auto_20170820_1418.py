# -*- coding: utf-8 -*-
# Generated by Django 1.11.4 on 2017-08-20 14:18
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('master_data', '0004_auto_20170820_0848'),
    ]

    operations = [
        migrations.AlterField(
            model_name='place',
            name='lat',
            field=models.DecimalField(decimal_places=3, max_digits=9, null=True),
        ),
        migrations.AlterField(
            model_name='place',
            name='long',
            field=models.DecimalField(decimal_places=3, max_digits=9, null=True),
        ),
        migrations.AlterField(
            model_name='place',
            name='sensor_mac_address',
            field=models.CharField(blank=True, max_length=17, unique=True),
        ),
    ]

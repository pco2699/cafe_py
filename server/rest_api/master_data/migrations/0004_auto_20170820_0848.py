# -*- coding: utf-8 -*-
# Generated by Django 1.11.4 on 2017-08-20 08:48
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('master_data', '0003_auto_20170813_0243'),
    ]

    operations = [
        migrations.AddField(
            model_name='environment',
            name='air_cleanness',
            field=models.DecimalField(decimal_places=2, default=0, max_digits=3),
        ),
        migrations.AddField(
            model_name='place',
            name='has_power',
            field=models.NullBooleanField(),
        ),
        migrations.AddField(
            model_name='place',
            name='has_wifi',
            field=models.NullBooleanField(),
        ),
        migrations.AddField(
            model_name='place',
            name='is_permitSmoking',
            field=models.NullBooleanField(),
        ),
        migrations.AddField(
            model_name='place',
            name='lat',
            field=models.DecimalField(decimal_places=2, max_digits=6, null=True),
        ),
        migrations.AddField(
            model_name='place',
            name='long',
            field=models.DecimalField(decimal_places=2, max_digits=6, null=True),
        ),
    ]

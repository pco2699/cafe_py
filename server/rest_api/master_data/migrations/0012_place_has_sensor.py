# -*- coding: utf-8 -*-
# Generated by Django 1.11.4 on 2017-09-02 08:05
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('master_data', '0011_auto_20170902_0556'),
    ]

    operations = [
        migrations.AddField(
            model_name='place',
            name='has_sensor',
            field=models.NullBooleanField(),
        ),
    ]

# -*- coding: utf-8 -*-
# Generated by Django 1.11.4 on 2017-08-13 02:43
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('master_data', '0002_auto_20170813_0239'),
    ]

    operations = [
        migrations.AlterField(
            model_name='place',
            name='sensor_mac_address',
            field=models.CharField(blank=True, default='hoge', max_length=30, unique=True),
            preserve_default=False,
        ),
    ]

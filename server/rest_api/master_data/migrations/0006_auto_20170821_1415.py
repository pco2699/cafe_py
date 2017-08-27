# -*- coding: utf-8 -*-
# Generated by Django 1.11.4 on 2017-08-21 14:15
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('master_data', '0005_auto_20170820_1418'),
    ]

    operations = [
        migrations.AlterField(
            model_name='place',
            name='lat',
            field=models.DecimalField(decimal_places=6, max_digits=9, null=True),
        ),
        migrations.AlterField(
            model_name='place',
            name='long',
            field=models.DecimalField(decimal_places=6, max_digits=9, null=True),
        ),
    ]
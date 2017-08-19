# -*- coding: utf-8 -*-
# Generated by Django 1.11.4 on 2017-08-13 02:26
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Environment',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('time', models.DateTimeField()),
                ('temp', models.DecimalField(decimal_places=2, max_digits=4)),
                ('humid', models.DecimalField(decimal_places=2, max_digits=4)),
                ('light', models.DecimalField(decimal_places=2, max_digits=3)),
                ('loudness', models.DecimalField(decimal_places=2, max_digits=3)),
            ],
        ),
        migrations.CreateModel(
            name='Place',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=32)),
                ('address', models.CharField(max_length=100)),
                ('sensor_mac_address', models.CharField(max_length=30, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='Song',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('time', models.DateTimeField()),
                ('song_name', models.CharField(max_length=20)),
                ('artist_name', models.CharField(max_length=20)),
                ('place', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='master_data.Place')),
            ],
        ),
        migrations.AddField(
            model_name='environment',
            name='place',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='master_data.Place', to_field='sensor_mac_address'),
        ),
        migrations.AlterUniqueTogether(
            name='song',
            unique_together=set([('place', 'time')]),
        ),
        migrations.AlterUniqueTogether(
            name='environment',
            unique_together=set([('place', 'time')]),
        ),
    ]
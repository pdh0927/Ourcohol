# Generated by Django 4.1.5 on 2023-04-08 16:23

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("participant", "0002_remove_participant_amount_alcohol"),
    ]

    operations = [
        migrations.AddField(
            model_name="participant",
            name="alarm_flag",
            field=models.BooleanField(default=True),
        ),
    ]
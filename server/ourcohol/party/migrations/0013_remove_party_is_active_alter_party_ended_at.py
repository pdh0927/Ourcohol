# Generated by Django 4.1.5 on 2023-03-27 16:55

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("party", "0012_alter_party_ended_at"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="party",
            name="is_active",
        ),
        migrations.AlterField(
            model_name="party",
            name="ended_at",
            field=models.DateTimeField(
                default=datetime.datetime(2023, 3, 28, 16, 55, 19, 353483)
            ),
        ),
    ]

# Generated by Django 4.1.5 on 2023-03-17 08:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0016_alter_user_managers'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='active_party',
            field=models.IntegerField(default=-1),
        ),
    ]

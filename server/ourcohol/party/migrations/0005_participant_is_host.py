# Generated by Django 4.1.5 on 2023-03-03 18:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('party', '0004_remove_party_king_user_id_remove_party_last_user_id_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='participant',
            name='is_host',
            field=models.BooleanField(default=False),
        ),
    ]
# Generated by Django 3.2.9 on 2023-05-18 16:40

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0025_alter_user_image_memory'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='image_memory',
            field=models.TextField(blank=True, default=''),
        ),
    ]

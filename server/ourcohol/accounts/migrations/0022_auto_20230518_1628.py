# Generated by Django 3.2.9 on 2023-05-18 16:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0021_user_type_alcohol_alter_user_amount_alcohol'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='user',
            name='image',
        ),
        migrations.AddField(
            model_name='user',
            name='image_memory',
            field=models.CharField(blank=True, default='', max_length=1000000000000000, null=True),
        ),
    ]

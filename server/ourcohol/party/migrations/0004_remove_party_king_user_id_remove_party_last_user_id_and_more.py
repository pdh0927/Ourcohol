# Generated by Django 4.1.5 on 2023-03-03 18:18

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('party', '0003_party_king_user_id_party_last_user_id_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='party',
            name='king_user_id',
        ),
        migrations.RemoveField(
            model_name='party',
            name='last_user_id',
        ),
        migrations.RemoveField(
            model_name='party',
            name='participations',
        ),
        migrations.AddField(
            model_name='party',
            name='drank_beer',
            field=models.IntegerField(default=0),
        ),
        migrations.AddField(
            model_name='party',
            name='drank_soju',
            field=models.IntegerField(default=0),
        ),
        migrations.AddField(
            model_name='party',
            name='is_active',
            field=models.BooleanField(default=False),
        ),
        migrations.CreateModel(
            name='Participant',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('drank_beer', models.IntegerField(default=0)),
                ('drank_soju', models.IntegerField(default=0)),
                ('amount_alcohol', models.IntegerField(default=1)),
                ('party', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='participants', to='party.party')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='connected_party', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
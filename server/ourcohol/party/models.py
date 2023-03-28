from django.db import models
from django.utils import timezone
import datetime


class Party(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    place = models.CharField(max_length=255)
    image = models.ImageField(blank=True, null=True)  # 술자리 사진
    created_at = models.DateTimeField(default=timezone.now)  # 술자리가 만들어진 시간
    started_at = models.DateTimeField(blank=True, null=True)
    ended_at = models.DateTimeField(
        default=datetime.datetime.now() + datetime.timedelta(days=1)
    )
    drank_beer = models.IntegerField(default=0)
    drank_soju = models.IntegerField(default=0)

    def __str__(self):
        return f"{self.id}"

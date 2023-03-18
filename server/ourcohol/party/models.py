from django.db import models
from django.utils import timezone
from accounts.models import User

class Party(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length = 255)
    place = models.CharField(max_length = 255)
    image = models.ImageField(blank=True,null=True)    # 술자리 사진
    created_at = models.DateTimeField(default=timezone.now) # 술자리가 만들어진 시간
    started_at = models.DateTimeField
    ended_at = models.DateTimeField(blank=True,null=True) 
    drank_beer = models.IntegerField(default=0)
    drank_soju = models.IntegerField(default=0)
    is_active = models.BooleanField(default=False) 
    
    def __str__(self):
        return f'{self.id}'

class Participant(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='connected_party')
    party =  models.ForeignKey(Party, on_delete=models.CASCADE, related_name='participants')
    drank_beer = models.IntegerField(default=0)
    drank_soju = models.IntegerField(default=0)
    amount_alcohol = models.IntegerField(default=1)
    is_host = models.BooleanField(default=False)

    def __str__(self):
        return self.user.email



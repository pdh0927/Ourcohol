from django.db import models
from django.utils import timezone

class Party(models.Model):
    id = models.AutoField(primary_key=True)
    # host =  models.ForeignKey(User on_delete=models.CASCADE, related_name='outfit')
    name = models.CharField(max_length =  255)
    place = models.CharField(max_length =  255)
    image = models.ImageField(null=True)    # 술자리 사진
    # participates = models.ManyToManyField(User, blank=True, related_name='participate')
    # king_user_id = models.ManyToManyField(User, blank=True, related_name='participate')
    # last_user_id = models.ManyToManyField(User, blank=True, related_name='participate')
    started_at = models.DateTimeField
    ended_at = models.DateTimeField(null=True) 
    created_at = models.DateTimeField(default=timezone.now) # 술자리가 만들어진 시간
    is_delete = models.BooleanField(default=False)  # for soft delete
    # 먹은 술 총량
    # 방 code

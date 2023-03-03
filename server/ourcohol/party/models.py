from django.db import models
from django.utils import timezone
from accounts.models import User

class Party(models.Model):
    id = models.AutoField(primary_key=True)
    # host =  models.ForeignKey(User on_delete=models.CASCADE, related_name='outfit')
    name = models.CharField(max_length =  255)
    place = models.CharField(max_length =  255)
    image = models.ImageField(blank=True,null=True)    # 술자리 사진
    participations = models.ManyToManyField(User, related_name='participate') # 참여자 id
    king_user_id = models.ManyToManyField(User, blank=True, related_name='win_party') # 가장 많이 먹은 사람 id
    last_user_id = models.ManyToManyField(User, blank=True, related_name='lose_party') # 가장 적게 먹은 사람 id
    started_at = models.DateTimeField
    created_at = models.DateTimeField(default=timezone.now) # 술자리가 만들어진 시간
    ended_at = models.DateTimeField(null=True) 
    is_active = models.BooleanField(default=False) 
    is_delete = models.BooleanField(default=False)  # for soft delete
    # 먹은 술 총량
    # 방 code

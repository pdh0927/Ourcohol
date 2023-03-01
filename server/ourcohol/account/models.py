from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    # AbstractUser의 기본 제공 필드
    # id : PK
    # username 
    # first_name
    # last_name
    # email
    # password
    # is_staff
    # is_activate
    # is_superuser
    # last_login
    # data_joined
    
    nickname = models.CharField(max_length=50)
    image = models.ImageField(blank=True,null=True)
    
    # 목표 주량
    # 마신 술 양

from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.db import models
from django.utils.translation import gettext_lazy as _

class UserManager(BaseUserManager):
    # 일반 user 생성
    def create_user(self, email, nickname, password, **extra_fields):
        if not email:
            raise ValueError(_('The Email must be set'))
        if not nickname:
            raise ValueError(_('The Nickname must be set'))
        email = self.normalize_email(email)
        user = self.model(email=email,nickname=nickname,**extra_fields)
        user.set_password(password)
        user.save()
        return user

    # 관리자 user 생성
    def create_superuser(self, email, nickname, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_active', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_admin', True)


        if extra_fields.get('is_staff') is not True:
            raise ValueError(_('Superuser must have is_staff=True.'))
        if extra_fields.get('is_superuser') is not True:
            raise ValueError(_('Superuser must have is_superuser=True.'))
        return self.create_user(email, nickname, password,  **extra_fields)
    
class User(AbstractUser):
    id = models.AutoField(primary_key=True)
    username = None
    email = models.EmailField(_('email address'), unique=True)
    nickname = models.CharField(default='', max_length=100, null=False, blank=False)
    image = models.ImageField(blank=True,null=True)
    active_party = models.IntegerField(default=-1)
    is_active = models.BooleanField(default=True)   
    is_staff =  models.BooleanField(default=False)
    is_admin =  models.BooleanField(default=False)
    
    # 헬퍼 클래스 사용
    objects = UserManager()

    # 사용자의 username field는 email으로 설정
    USERNAME_FIELD = 'email'

    # 필수로 작성해야하는 field
    REQUIRED_FIELDS = ['nickname']

    def __str__(self):
        return self.email


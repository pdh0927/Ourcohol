from django.urls import path, include, re_path
from rest_framework.routers import DefaultRouter
from . import views
from dj_rest_auth.registration.views import VerifyEmailView
from django.contrib.auth.models import User

router = DefaultRouter()
router.register('', views.UserViewSet)

urlpatterns = [
    # list, detail
    path('', include(router.urls)),

    # 일반 회원 회원가입/로그인
    path('dj-rest-auth/', include('dj_rest_auth.urls')),
    path('dj-rest-auth/registration/', include('dj_rest_auth.registration.urls')),
    
    # email 인증
    # 유효한 이메일이 유저에게 전달
    re_path(r'^account-confirm-email/$', VerifyEmailView.as_view(), name='account_email_verification_sent'),
    # 유저가 클릭한 이메일(=링크) 확인
    re_path(r'^account-confirm-email/(?P<key>[-:\w]+)/$', views.ConfirmEmailView.as_view(), name='account_confirm_email'),

    # reset password
    path('auth/', include('django.contrib.auth.urls')),
    # http://127.0.0.1:8000/api/accounts/auth/password_reset/
]
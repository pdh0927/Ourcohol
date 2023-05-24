from pathlib import Path
import os
from datetime import timedelta

from django.conf import settings
from . import my_settings

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = my_settings.SECRET_KEY

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ["*"]
# ALLOWED_HOSTS = ["127.0.0.1", "10.0.2.2", "OURcohol-eb-server-dev.ap-northeast-2.elasticbeanstalk.com"]

# Application definition

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",

    # Installed Librarys
    "rest_framework",
    "rest_framework.authtoken",
    "rest_framework_simplejwt",
    "dj_rest_auth",
    "dj_rest_auth.registration",
    "allauth",
    "allauth.account",
    "allauth.socialaccount",
    'storages',

    # My Apps
    "party",
    "accounts",
    "comment",
    "participant",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "ourcohol.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [os.path.join(BASE_DIR, "templates")],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "ourcohol.wsgi.application"


# Database
# https://docs.djangoproject.com/en/4.1/ref/settings/#databases



DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql', # engine: mysql
        'NAME' :my_settings.DATABASE_NAME, # DB Name
        'USER' : my_settings.DATABASE_USER, # DB User
        'PASSWORD' :my_settings.DATABASE_PASSWORD, # Password
        'HOST':my_settings.DATABASE_HOST, # 생성한 데이터베이스 엔드포인트
        'PORT': '3306', # 데이터베이스 포트
        'OPTIONS': {
            'sql_mode': 'STRICT_ALL_TABLES'  # Strict Mode 활성화
        }
    }
}

# DATABASES = {
#     "default": {
#         "ENGINE": "django.db.backends.sqlite3",
#         "NAME": BASE_DIR / "db.sqlite3",
#     }
# }



# Password validation
# https://docs.djangoproject.com/en/4.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]

AUTH_USER_MODEL = "accounts.User"

# Internationalization
# https://docs.djangoproject.com/en/4.1/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.1/howto/static-files/

STATIC_URL = "static/"
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")

MEDIA_URL = "media/"
MEDIA_ROOT = os.path.join(BASE_DIR, "media")

# Default primary key field type
# https://docs.djangoproject.com/en/4.1/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"


# Storage
DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
STATICFILES_STORAGE = 'storages.backends.s3boto3.S3StaticStorage'
# STATICFILES_STORAGE = 'storages.backends.s3boto3.S3ManifestStaticStorage'
AWS_STORAGE_BUCKET_NAME = my_settings.AWS_STORAGE_BUCKET_NAME

SITE_ID = 1 # 해당 도메인의 id
ACCOUNT_UNIQUE_EMAIL = True # User email unique 사용 여부
ACCOUNT_USER_MODEL_USERNAME_FIELD = None    # User username type
ACCOUNT_USERNAME_REQUIRED = False   # User username 필수 여부
ACCOUNT_EMAIL_REQUIRED = True   # User email 필수 여부
ACCOUNT_NICKNAME_REQUIRED = True    # User nickname 필수 여부
ACCOUNT_AUTHENTICATION_METHOD = "email"    # 로그인 인증 수단

REST_AUTH = {
    'USE_JWT': True,
    'JWT_AUTH_HTTPONLY': False,  # refresh_token를 사용할 예정이라면, False로 설정을 바꿔야한다.
    
    'USER_DETAILS_SERIALIZER': 'accounts.serializers.UserSerializer',
    'REGISTER_SERIALIZER' : 'accounts.serializers.UserRegisterSerializer'
}

REST_USE_JWT = True # JWT 사용 여부
JWT_AUTH_COOKIE = "my-app-auth" # 호출할 Cookie Key값
JWT_AUTH_REFRESH_COOKIE = "my-refresh-token"    # Refresh Token Cookie Key 값
REST_FRAMEWORK = {
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.AllowAny",
    ],
    "DEFAULT_AUTHENTICATION_CLASSES": [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
        'dj_rest_auth.jwt_auth.JWTCookieAuthentication',
    ],
}

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=36500),  # access 토큰의 만료 시간입니다. # 우선 무한대의 유효기간을 가짐
    'REFRESH_TOKEN_LIFETIME': timedelta(days=36500),  # refresh 토큰의 만료 시간입니다. # 우선 무한대의 유효기간을 가짐
}

EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
EMAIL_HOST = "smtp.gmail.com"  # 메일 호스트 서버
EMAIL_PORT = "587"  # gmail과 통신하는 포트
EMAIL_HOST_USER = "pdh980927@gmail.com"  # 발신할 이메일
EMAIL_HOST_PASSWORD = my_settings.EMAIL_HOST_PASSWORD  # 발신할 메일의 비밀번호
EMAIL_USE_TLS = True  # TLS 보안 방법
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
# URL_FRONT = 'http://****' # 공개적인 웹페이지가 있다면 등록
ACCOUNT_CONFIRM_EMAIL_ON_GET = True  # 유저가 받은 링크를 클릭하면 회원가입 완료되게끔
ACCOUNT_EMAIL_REQUIRED = True
ACCOUNT_EMAIL_VERIFICATION = "mandatory"  # mandatory : email 인증필요, none : email 인증 필요 없음
ACCOUNT_EMAIL_CONFIRMATION_EXPIRE_DAYS = 1
# 이메일에 자동으로 표시되는 사이트 정보
ACCOUNT_EMAIL_SUBJECT_PREFIX = "OURcohol[이메일 인증]"

import os
from django.conf import settings
from rest_framework import serializers
from django.utils.translation import gettext_lazy as _
from dj_rest_auth.registration.serializers import RegisterSerializer
from .models import User
from allauth.account.adapter import get_adapter
import base64
import boto3

class UserRegisterSerializer(RegisterSerializer):
    nickname = serializers.CharField(
        max_length=100,
    )
    image = serializers.ImageField(required=False, allow_null=True)  # image 필드가 필수가 아님을 명시합니다.

    class Meta:
        model = User
        fields = [
            "email",
            "password",
            "nickname",
            "image",
            "type_alcohol",
            "amount_alcohol",
        ]

    # override get_cleaned_data of RegisterSerializer
    def get_cleaned_data(self):
        return {
            "password1": self.validated_data.get("password1", ""),
            "password2": self.validated_data.get("password2", ""),
            "email": self.validated_data.get("email", ""),
            "nickname": self.validated_data.get("nickname", ""),
            "image": self.validated_data.get("image", None),  # None이 기본값이 됩니다.
        }

    # override save method of RegisterSerializer
    def save(self, request):
        adapter = get_adapter()
        user = adapter.new_user(request)
        self.cleaned_data = self.get_cleaned_data()
        user.nickname = self.cleaned_data.get("nickname")
        user.image = self.cleaned_data.get("image")
        user.save()
        adapter.save_user(request, user, self)
        return user


class UserSerializer(serializers.ModelSerializer):
   # image_memory = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            "id",
            "email",
            "nickname",
            "image",
           # "image_memory",
            "type_alcohol",
            "amount_alcohol",
        ]

    # def get_image_memory(self, user: User):
    #     return Base64Encoding.encoding_image(user)


# class Base64Encoding:
#     def encoding_image(instance):
#         if instance.image and instance.image.name:
#             s3 = boto3.client('s3')
#             bucket_name = settings.AWS_STORAGE_BUCKET_NAME  # S3 버킷 이름

#             try:
#                 # S3에서 이미지 파일을 가져옴
#                 response = s3.get_object(Bucket=bucket_name, Key=instance.image.name)
#                 image_data = response['Body'].read()

#                 # 이미지를 base64로 인코딩하여 반환
#                 return base64.b64encode(image_data).decode('utf-8')
#             except Exception as e:
#                 print(f'Failed to encode image: {str(e)}')

#         return None
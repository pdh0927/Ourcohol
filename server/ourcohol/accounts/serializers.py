from rest_framework import serializers
from django.utils.translation import gettext_lazy as _
from dj_rest_auth.registration.serializers import RegisterSerializer
from .models import User
from allauth.account.adapter import get_adapter
import base64

class UserRegisterSerializer(RegisterSerializer):
    nickname = serializers.CharField( max_length=100,)
    class Meta:
        model = User
        fields = ['email', 'password', 'nickname']

    # override get_cleaned_data of RegisterSerializer
    def get_cleaned_data(self):
        return {
            'password1': self.validated_data.get('password1', ''),
            'password2': self.validated_data.get('password2', ''),
            'email': self.validated_data.get('email', ''),
            'nickname': self.validated_data.get('nickname', ''),
        }

    #override save method of RegisterSerializer
    def save(self, request):
        adapter = get_adapter()
        user = adapter.new_user(request)
        self.cleaned_data = self.get_cleaned_data()
        user.nickname = self.cleaned_data.get('nickname')
        user.save()
        adapter.save_user(request, user, self)
        return user

class UserSerializer(serializers.ModelSerializer):
    image_memory = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id','email', 'nickname', 'image_memory']

    def get_image_memory(self, user: User):
        return Base64Encoding.encoding_image(user)

class Base64Encoding():
    def encoding_image(instance):
        if instance.image != None and instance.image != '':
            with open(f'media/{instance.image.name}', mode='rb') as loadedfile:
                return base64.b64encode(loadedfile.read())
        else:
            return
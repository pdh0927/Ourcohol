from rest_framework import serializers
from .models import Comment
from accounts.serializers import UserSerializer

class CommentSerializer(serializers.ModelSerializer):
    user =  UserSerializer(many=False)

    class Meta:
        model = Comment
        fields = '__all__'
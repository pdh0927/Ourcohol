from rest_framework import serializers
from .models import Comment
from party.serializers import PartyRetrieveSerializer

class CommentSerializer(serializers.ModelSerializer):
    user =  serializers.StringRelatedField(many=False)
    party = PartyRetrieveSerializer(many=False)

    class Meta:
        model = Comment
        fields = '__all__'
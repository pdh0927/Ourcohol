from rest_framework import serializers
from .models import Party
from participant.models import Participant
from accounts.serializers import UserSerializer
from comment.serializers import CommentSerializer


class ParticipantSerializer(serializers.ModelSerializer):
    user = UserSerializer(many=False)
    party = serializers.StringRelatedField

    class Meta:
        model = Participant
        fields = "__all__"


class PartyRetrieveSerializer(serializers.ModelSerializer):
   # image_memory = serializers.SerializerMethodField()
    participants = ParticipantSerializer(many=True)
    comments = CommentSerializer(many=True)

    class Meta:
        model = Party
        fields = "__all__"

    # def get_image_memory(self, party: Party):
    #     return Base64Encoding.encoding_image(party)


class PartyPostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Party
        fields = "__all__"


class ParticipantPartySerializer(serializers.ModelSerializer):
    party = PartyRetrieveSerializer(many=False)

    class Meta:
        model = Participant
        fields = ["party"]

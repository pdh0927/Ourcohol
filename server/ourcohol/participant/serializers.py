from rest_framework import serializers
from .models import Participant
from accounts.serializers import UserSerializer
from party.serializers import PartyRetrieveSerializer


class ParticipantSerializer(serializers.ModelSerializer):
    user = UserSerializer(many=False)

    class Meta:
        model = Participant
        fields = "__all__"


class ParticipantCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Participant
        fields = "__all__"


class ParticipantPartySerializer(serializers.ModelSerializer):
    party = PartyRetrieveSerializer(many=False)

    class Meta:
        model = Participant
        fields = ["party"]

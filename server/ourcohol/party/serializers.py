from rest_framework import serializers
from .models import Party, Participant
from accounts.serializers import UserSerializer, Base64Encoding

class PartyRetrieveSerializer(serializers.ModelSerializer):
    image_memory = serializers.SerializerMethodField()
    participants = serializers.StringRelatedField(many=True)

    class Meta:
        model = Party
        # fields = ['id','name','place', 'image','participants','drank_beer','drank_soju','is_active', 'created_at']
        fields = '__all__'
    
    def get_image_memory(self, party: Party):
        return Base64Encoding.encoding_image(party)

class PartyPostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Party
        fields = '__all__'


class ParticipantSerializer(serializers.ModelSerializer):
    user =  serializers.StringRelatedField(many=False)
    party = PartyRetrieveSerializer(many=False)

    class Meta:
        model = Participant
        fields = '__all__'

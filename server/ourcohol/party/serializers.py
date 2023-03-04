from rest_framework import serializers
from .models import Party, Participant
from accounts.serializers import UserSerializer, Base64Encoding

class PartySerializer(serializers.ModelSerializer):
    image_memory = serializers.SerializerMethodField()
    participants = serializers.StringRelatedField(many=True)

    class Meta:
        model = Party
        # fields = ['id','name','place', 'image','participants','drank_beer','drank_soju','is_active']
        fields = '__all__'
    
    def get_image_memory(self, party: Party):
        return Base64Encoding.encoding_image(party)
        


class ParticipantSerializer(serializers.ModelSerializer):
    user =  serializers.StringRelatedField(many=False)
    party = serializers.StringRelatedField(many=False)

    class Meta:
        model = Participant
        fields = ['user', 'party', 'drank_beer','drank_soju', 'amount_alcohol']


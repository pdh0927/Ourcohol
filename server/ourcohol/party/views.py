from rest_framework import viewsets
from .models import Party
from .serializers import PartySerializer, ParticipantSerializer


class PartyViewSet(viewsets.ModelViewSet):
    queryset = Party.objects.all()
    serializer_class = PartySerializer
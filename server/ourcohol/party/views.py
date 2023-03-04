from rest_framework import viewsets
from .models import Party
from .serializers import PartyPostSerializer, PartyRetrieveSerializer


class PartyViewSet(viewsets.ModelViewSet):
    queryset = Party.objects.all()

    def get_serializer_class(self):
        if self.action == 'list' or self.action == 'retrieve':
            return PartyRetrieveSerializer
        return PartyPostSerializer
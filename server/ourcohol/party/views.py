from rest_framework import viewsets
from .models import Party, Participant
from .serializers import PartyPostSerializer, PartyRetrieveSerializer, ParticipantSerializer
from rest_framework.decorators import action
from rest_framework.response import Response


class PartyViewSet(viewsets.ModelViewSet):
    queryset = Party.objects.all()
    serializer_class = PartyPostSerializer

    def get_serializer_class(self):
        if self.action == 'list' or self.action == 'retrieve':
            return PartyRetrieveSerializer
        return PartyPostSerializer


class ParticipantViewSet(viewsets.ModelViewSet):
    queryset = Participant.objects.all()
    serializer_class = ParticipantSerializer

    @action(detail=False, methods=['get'], url_path=r'list/(?P<pk>\d+)')
    def mylist(self, request,pk):
        qs = self.get_queryset().filter(user=pk)
        print(qs)
        serializer = ParticipantSerializer(qs, many=True)

        return Response(serializer.data)
    
    @action(detail=False, methods=['get'], url_path=r'active/(?P<pk>\d+)')
    def active_party(self, request,pk):
        qs = self.get_queryset().filter(user=pk)
        resultQs =[]
        resultQs.append(qs[len(qs)-1]) 
        print(resultQs)
        serializer = ParticipantSerializer(resultQs, many=True)

        return Response(serializer.data)
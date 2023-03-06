from rest_framework import viewsets
from .models import Party, Participant
from .serializers import PartyPostSerializer, PartyRetrieveSerializer, ParticipantSerializer
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated, AllowAny
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
    # authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    # permission_classes = [AllowAny]


    # participant를 통해서 party 목록 불러오기
    @action(detail=False, methods=['get'], url_path=r'list/(?P<pk>\d+)')
    def mylist(self, request,pk):
        qs = self.get_queryset().filter(user=pk)
        serializer = ParticipantSerializer(qs, many=True)

        return Response(serializer.data)
    
    # participant를 통해서 가장 최근 party 불러오기
    @action(detail=False, methods=['get'], url_path=r'recent/(?P<pk>\d+)')
    def recent_party(self, request,pk):
        qs = self.get_queryset().filter(user=pk)
        resultQs =[]
        resultQs.append(qs[len(qs)-1]) 
        print(resultQs)
        serializer = ParticipantSerializer(resultQs, many=True)

        return Response(serializer.data)
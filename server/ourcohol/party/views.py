from rest_framework import viewsets
from .models import Party, Participant
from .serializers import PartyPostSerializer, PartyRetrieveSerializer, ParticipantSerializer, ParticipantPartySerializer,PartyRetrieveSerializer
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.decorators import action
from rest_framework.response import Response
from datetime import date


class PartyViewSet(viewsets.ModelViewSet):
    queryset = Party.objects.all()
    serializer_class = PartyPostSerializer
    permission_classes = [IsAuthenticated]

    def get_serializer_class(self):
        if self.action == 'list' or self.action == 'retrieve':
            return PartyRetrieveSerializer
        return PartyPostSerializer

    # active party 불러오기
    @action(detail=False, methods=['get'], url_path=r'active/(?P<pk>\d+)')
    def recent_party(self, request, pk):
        qs = self.get_queryset().filter(id=pk)
        resultQs = []
        if len(qs) > 0:
            resultQs.append(qs[len(qs)-1])
        serializer = PartyRetrieveSerializer( resultQs, many=True)

        return Response(serializer.data)



class ParticipantViewSet(viewsets.ModelViewSet):
    queryset = Participant.objects.all()
    serializer_class = ParticipantSerializer
    permission_classes = [IsAuthenticated]

    # 소주 1잔 추가
    @action(detail=False, methods=['get'], url_path=r'add/soju/(?P<pk>\d+)')
    def addSoju(self, request, pk):
        
        instance = self.get_object()
        instance.drank_soju += 1
        instance.save()

        return Response(instance.drank_soju)
    
    # 소주 1잔 빼기
    @action(detail=False, methods=['get'], url_path=r'minus/soju/(?P<pk>\d+)')
    def minusSoju(self, request, pk):
        
        instance = self.get_object()
        instance.drank_soju -= 1
        instance.save()

        return Response(instance.drank_soju)
    
    # 맥주 1잔 추가
    @action(detail=False, methods=['get'], url_path=r'add/beer/(?P<pk>\d+)')
    def addBeer(self, request, pk):
        
        instance = self.get_object()
        instance.drank_beer += 1
        instance.save()

        return Response(instance.drank_beer)
    
    # 맥주 1잔 뺴기
    @action(detail=False, methods=['get'], url_path=r'minus/beer/(?P<pk>\d+)')
    def minusBeer(self, request, pk):
        
        instance = self.get_object()
        instance.drank_beer -= 1
        instance.save()

        return Response(instance.drank_beer)
    
    # participant를 통해서 party 목록 불러오기
    @action(detail=False, methods=['get'], url_path=r'list/(?P<pk>\d+)/(?P<year>\d+)/(?P<month>\d+)')
    def mylist(self, request, pk, year, month):
        qs = self.get_queryset().filter(user=pk)
        
        resultQs = []
        for source in qs:
            if str(source.party.created_at.year) == year and str(source.party.created_at.month) == month:   # 같은년 같은달 
                resultQs.append(source)
            if (int(month) - 1) == 0 :  # 이전년 이전달
                if source.party.created_at.year == (int(year) - 1) and source.party.created_at.month == 12:
                    resultQs.append(source)
            else:   # 같은년 이전달
                if str(source.party.created_at.year) == year and source.party.created_at.month == int(month)-1:
                    resultQs.append(source)
            if (int(month) + 1) == 13 : # 다음년 다음달
                if source.party.created_at.year == int(year) +1 and source.party.created_at.month == 1:
                    resultQs.append(source)
            else:   # 같은년 다음달
                if str(source.party.created_at.year) == year and source.party.created_at.month == int(month)+1:
                    resultQs.append(source)

        serializer = ParticipantPartySerializer(resultQs, many=True)

        return Response(serializer.data)
    
    
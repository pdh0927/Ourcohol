from rest_framework import viewsets
from .models import Party
from .serializers import (
    PartyPostSerializer,
    PartyRetrieveSerializer,
    PartyRetrieveSerializer,
)
from rest_framework import status
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
        if self.action == "list" or self.action == "retrieve":
            return PartyRetrieveSerializer
        return PartyPostSerializer

    # active party 불러오기
    # todo : user.partys().1개로 불러오기로 수정
    @action(detail=False, methods=["get"], url_path=r"active/(?P<pk>\d+)")
    def recent_party(self, request, pk):
        print(pk)
        qs = self.get_queryset().filter(id=pk)
        resultQs = []
        if len(qs) > 0:
            resultQs.append(qs[len(qs) - 1])
        serializer = PartyRetrieveSerializer(resultQs, many=True)

        return Response(serializer.data)

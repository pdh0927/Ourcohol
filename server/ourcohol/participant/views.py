from datetime import timezone
import datetime
from django.shortcuts import render
from requests import Response
from rest_framework import viewsets
from .models import Party, Participant
from .serializers import (
    ParticipantCreateSerializer,
    ParticipantSerializer,
    ParticipantPartySerializer,
)

from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import status
from django.utils import timezone


class ParticipantViewSet(viewsets.ModelViewSet):
    queryset = Participant.objects.all()
    serializer_class = ParticipantSerializer
    permission_classes = [IsAuthenticated]

    def get_serializer_class(self):
        if self.action == "create":
            return ParticipantCreateSerializer
        return ParticipantSerializer

    def create(self, request, *args, **kwargs):
        instance = (
            self.get_queryset()
            .filter(party=request.data.get("party"))
            .filter(user=request.data.get("user"))
        )
        if instance.count() > 0:
            return Response(
                {"message": "already enrolled user"},
                status=status.HTTP_208_ALREADY_REPORTED,
            )

        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)

        serializer = ParticipantSerializer(instance, many=True)
        headers = self.get_success_headers(serializer.data)
        return Response(
            serializer.data, status=status.HTTP_201_CREATED, headers=headers
        )

    # 소주 1잔 추가
    @action(detail=False, methods=["get"], url_path=r"add/soju/(?P<pk>\d+)")
    def addSoju(self, request, pk):
        instance = self.get_object()
        instance.drank_soju += 1
        instance.save()

        return Response(instance.drank_soju)

    # 소주 1잔 빼기
    @action(detail=False, methods=["get"], url_path=r"minus/soju/(?P<pk>\d+)")
    def minusSoju(self, request, pk):
        instance = self.get_object()
        instance.drank_soju -= 1
        instance.save()

        return Response(instance.drank_soju)

    # 맥주 1잔 추가
    @action(detail=False, methods=["get"], url_path=r"add/beer/(?P<pk>\d+)")
    def addBeer(self, request, pk):
        print(pk)
        instance = self.get_object()
        instance.drank_beer += 1
        instance.save()

        return Response(instance.drank_beer)

    # 맥주 1잔 뺴기
    @action(detail=False, methods=["get"], url_path=r"minus/beer/(?P<pk>\d+)")
    def minusBeer(self, request, pk):
        instance = self.get_object()
        instance.drank_beer -= 1
        instance.save()

        return Response(instance.drank_beer)

    # participant를 통해서 party 목록 불러오기
    # todo : user.partys()로 불러오기로 수정
    @action(
        detail=False,
        methods=["get"],
        url_path=r"list/(?P<pk>\d+)/(?P<year>\d+)/(?P<month>\d+)",
    )
    def mylist(self, request, pk, year, month):
        qs = self.get_queryset().filter(user=pk)

        resultQs = []
        for source in qs:
            if (
                str(source.party.created_at.year) == year
                and str(source.party.created_at.month) == month
            ):  # 같은년 같은달
                resultQs.append(source)
            if (int(month) - 1) == 0:  # 이전년 이전달
                if (
                    source.party.created_at.year == (int(year) - 1)
                    and source.party.created_at.month == 12
                ):
                    resultQs.append(source)
            else:  # 같은년 이전달
                if (
                    str(source.party.created_at.year) == year
                    and source.party.created_at.month == int(month) - 1
                ):
                    resultQs.append(source)
            if (int(month) + 1) == 13:  # 다음년 다음달
                if (
                    source.party.created_at.year == int(year) + 1
                    and source.party.created_at.month == 1
                ):
                    resultQs.append(source)
            else:  # 같은년 다음달
                if (
                    str(source.party.created_at.year) == year
                    and source.party.created_at.month == int(month) + 1
                ):
                    resultQs.append(source)

        serializer = ParticipantPartySerializer(resultQs, many=True)

        return Response(serializer.data)

    # participant를 통해서 가장 최근 party 불러오기
    @action(detail=False, methods=["get"], url_path=r"recent/(?P<pk>\d+)")
    def recent_party(self, request, pk):
        qs = self.get_queryset().filter(user=pk)
        resultQs = []
        if len(qs) > 0:
            resultQs.append(qs[len(qs) - 1])
        serializer = ParticipantPartySerializer(resultQs, many=True)

        return Response(serializer.data)

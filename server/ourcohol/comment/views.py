from django.shortcuts import render

from server.ourcohol.comment.serializers import CommentSerializer
from .models import Comment
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets


class CommentViewSet(viewsets.ModelViewSet):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer
    permission_classes = [IsAuthenticated]

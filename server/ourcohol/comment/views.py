from django.shortcuts import render

from comment.serializers import CommentSerializer,CommentRegisterSerializer
from .models import Comment
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets


class CommentViewSet(viewsets.ModelViewSet):
    queryset = Comment.objects.all()
    permission_classes = [IsAuthenticated]

    def get_serializer_class(self):
        if self.action == 'create':
            return CommentRegisterSerializer
        return CommentSerializer

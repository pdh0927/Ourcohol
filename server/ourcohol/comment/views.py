from django.shortcuts import render
from .models import Comment
from rest_framework.permissions import IsAuthenticated, AllowAny

class CommentViewSet(viewsets.ModelViewSet):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer
    permission_classes = [IsAuthenticated]

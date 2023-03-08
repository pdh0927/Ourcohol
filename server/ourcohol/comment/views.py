from django.shortcuts import render

class CommentViewSet(viewsets.ModelViewSet):
    queryset = Comment.objects.all()
    serializer_class = CommentPostSerializer
    permission_classes = [IsAuthenticated]

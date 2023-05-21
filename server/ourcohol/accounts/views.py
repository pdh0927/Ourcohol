from django.http import HttpResponseRedirect
from django.shortcuts import render
from rest_framework.response import Response  # Here is the change
from rest_framework import viewsets, status
from .models import User
from .serializers import UserSerializer
from rest_framework.permissions import  AllowAny
from allauth.account.models import EmailConfirmation, EmailConfirmationHMAC
from rest_framework.views import APIView
from django.core.exceptions import ValidationError
from django.core.validators import validate_email
from rest_framework.decorators import action

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]

    @action(detail=False, methods=["post"], url_path=r"check-email")
    def check_email(self, request, *args, **kwargs):
        email = request.data.get('email', '')

        # 입력받은 이메일이 유효한지 체크
        try:
            validate_email(email)
        except ValidationError:
            return Response({'error': 'Invalid email', 'duplicate': False}, status=status.HTTP_400_BAD_REQUEST)

        if User.objects.filter(email=email).exists():
            return Response({'email': email, 'duplicate': True}, status=status.HTTP_200_OK)

        return Response({'email': email, 'duplicate': False}, status=status.HTTP_200_OK)

class ConfirmEmailView(APIView):
    permission_classes = [AllowAny]

    def get(self, *args, **kwargs):
        self.object = confirmation = self.get_object()
        confirmation.confirm(self.request)
        return render(self.request, "account/email/email_verity_success.html")

    def get_object(self, queryset=None):
        key = self.kwargs["key"]
        email_confirmation = EmailConfirmationHMAC.from_key(key)
        if not email_confirmation:
            if queryset is None:
                queryset = self.get_queryset()
            try:
                email_confirmation = queryset.get(key=key.lower())
            except EmailConfirmation.DoesNotExist:
                # A React Router Route will handle the failure scenario
                return HttpResponseRedirect("/")  # 인증실패
        return email_confirmation

    def get_queryset(self):
        qs = EmailConfirmation.objects.all_valid()
        qs = qs.select_related("email_address__user")
        return qs


from django.http import HttpResponseRedirect
from django.shortcuts import render
from rest_framework import viewsets
from .models import User
from .serializers import UserSerializer
from rest_framework.decorators import action    
from rest_framework.permissions import IsAuthenticated, AllowAny     
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer    
from rest_framework.response import Response       
from rest_framework import status    
from django.contrib.auth import authenticate, login  
from allauth.account.models import EmailConfirmation, EmailConfirmationHMAC
from rest_framework.views import APIView

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]

    # def create(self, request):
    #     serializer = UserSerializer(data=request.data)
    #     if serializer.is_valid():
    #         user = serializer.save()
    #         # jwt token 접근해주기
    #         token = TokenObtainPairSerializer.get_token(user)
    #         refresh_token = str(token)
    #         access_token = str(token.access_token)
    #         res = Response(
    #             {
    #                 "user": serializer.data,
    #                 "message": "register successs",
    #                 "token": {
    #                     "access_token": access_token,
    #                     "refresh_token": refresh_token,
    #                 },
    #             },
    #             status=status.HTTP_200_OK,
    #         )
    #         res.set_cookie("access", access_token, httponly=True)
    #         res.set_cookie("refresh", refresh_token, httponly=True)
    #         return res
    #     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    # @action(methods=['POST'], detail=False)
    # def login(self, request):
    #     user = authenticate(
    #         email=request.data.get("email"), password=request.data.get("password")
    #     )
    #     if user is not None:
    #         serializer = UserSerializer(user)
    #         token = TokenObtainPairSerializer.get_token(user)
    #         refresh_token = str(token)
    #         access_token = str(token.access_token)
    #         res = Response(
    #             {
    #                 "user": serializer.data,
    #                 "message": "login success",
    #                 "token": {
    #                     "access": access_token,
    #                     "refresh": refresh_token,
    #                 },
    #             },
    #             status=status.HTTP_200_OK,
    #         )
    #         return res
    #     else:
    #         return Response(status=status.HTTP_400_BAD_REQUEST)
        
    # def get_permissions(self):
    #     if self.action == 'login' or self.action == 'create':
    #         return [AllowAny() ]
    #     return super(UserViewSet, self).get_permissions()
    
    
class ConfirmEmailView(APIView):
    permission_classes = [AllowAny]

    def get(self, *args, **kwargs):
        self.object = confirmation = self.get_object()
        confirmation.confirm(self.request)
        # A React Router Route will handle the failure scenario
        # return HttpResponseRedirect('/') # 인증성공
        return render(self.request,'account/email/email_verity_success.html')

    def get_object(self, queryset=None):
        key = self.kwargs['key']
        email_confirmation = EmailConfirmationHMAC.from_key(key)
        if not email_confirmation:
            if queryset is None:
                queryset = self.get_queryset()
            try:
                email_confirmation = queryset.get(key=key.lower())
            except EmailConfirmation.DoesNotExist:
                # A React Router Route will handle the failure scenario
                return HttpResponseRedirect('/') # 인증실패
        return email_confirmation

    def get_queryset(self):
        qs = EmailConfirmation.objects.all_valid()
        qs = qs.select_related("email_address__user")
        return qs



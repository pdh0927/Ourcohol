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
from django.core.files.uploadedfile import InMemoryUploadedFile
import boto3
from botocore.exceptions import NoCredentialsError
from django.core.files.storage import default_storage
from django.conf import settings

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
    
    
    def partial_update(self, request, pk=None):

        user = self.get_object()
        image_file = request.FILES.get('image')

        if image_file and isinstance(image_file, InMemoryUploadedFile):
            # 이미지를 S3에 업로드

            s3 = boto3.client('s3')
            bucket_name = settings.AWS_STORAGE_BUCKET_NAME
            file_name = f'{image_file.name}'  # S3에 저장할 파일 경로와 이름
            try:
                s3.upload_fileobj(image_file, bucket_name, file_name)
            except NoCredentialsError:
                return Response({'error': 'Failed to upload image to S3'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            # 기존 이미지 삭제
            if user.image :
                try:

                    # S3에서 기존 이미지 삭제
                    s3.delete_object(Bucket=bucket_name, Key=user.image.name)
                except NoCredentialsError:

                    return Response({'error': 'Failed to delete image from S3'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            # 업로드된 이미지 URL을 사용자 객체에 저장
            user.image = file_name
            user.save()

            serializer = UserSerializer(user)
            return Response(serializer.data, status=status.HTTP_200_OK)

        return super().partial_update(request, pk)

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


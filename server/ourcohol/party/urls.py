from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router1 = DefaultRouter()
router1.register('', views.PartyViewSet)

router2 = DefaultRouter()
router2.register(r'participant', views.ParticipantViewSet)

urlpatterns = [
    path('', include(router1.urls)),
    path('', include(router2.urls)),
]
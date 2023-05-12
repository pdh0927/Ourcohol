from django.contrib import admin
from django.urls import path, include
from ourcohol import views

urlpatterns = [
    path("", views.home),
    path("admin/", admin.site.urls),
    path("api/accounts/", include("accounts.urls")),
    path("api/party/", include("party.urls")),
    path("api/participant/", include("participant.urls")),
]

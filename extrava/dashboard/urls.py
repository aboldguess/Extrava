"""URL routing for the dashboard app."""

from django.urls import path
from . import views

urlpatterns = [
    # Landing page for logged-in users
    path('', views.home, name='home'),
    # Endpoint used by the JavaScript to upload selected activities
    path('upload/', views.upload_data, name='upload'),
]

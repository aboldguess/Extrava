"""App configuration for the dashboard Django app."""

from django.apps import AppConfig


class DashboardConfig(AppConfig):
    """Metadata for the app used by Django."""

    default_auto_field = "django.db.models.BigAutoField"
    name = "dashboard"

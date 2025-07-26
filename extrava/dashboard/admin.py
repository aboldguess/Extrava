"""Admin configuration for dashboard models."""

from django.contrib import admin

from .models import Activity


@admin.register(Activity)
class ActivityAdmin(admin.ModelAdmin):
    """Display helpful columns in the Django admin list view."""

    list_display = ("user", "activity_id", "distance", "duration")

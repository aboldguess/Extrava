from django.db import models
from django.contrib.auth.models import User


class Activity(models.Model):
    """Minimal representation of a Strava activity uploaded by a user."""

    # Owner of the activity
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    # The ID of the activity from the Strava export CSV
    activity_id = models.CharField(max_length=64)
    # Distance in kilometres
    distance = models.FloatField()
    # Duration stored in seconds
    duration = models.IntegerField(help_text="Duration in seconds")

    def __str__(self) -> str:
        """Friendly string representation for admin lists and debugging."""
        return f"{self.user.username} - {self.activity_id}"

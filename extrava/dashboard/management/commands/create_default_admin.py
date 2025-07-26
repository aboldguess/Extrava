"""Management command to provision the default admin account."""

from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model


class Command(BaseCommand):
    """Create a default admin user if one doesn't already exist."""

    def handle(self, *args, **options):
        User = get_user_model()
        # Check if the account is already present
        if not User.objects.filter(username="philadmin").exists():
            # Create superuser with the predefined credentials
            User.objects.create_superuser(
                "philadmin",
                "admin@example.com",
                "Admin12345",
            )
            self.stdout.write(self.style.SUCCESS("Created admin user 'philadmin'"))
        else:
            self.stdout.write("Admin user already exists")

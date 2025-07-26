"""Views for the dashboard app."""

from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.shortcuts import render
from django.views.decorators.http import require_POST

from .models import Activity


@login_required
def home(request):
    """Render the dashboard home page with the user's uploaded activities."""

    # Fetch previously uploaded activities so we can show them in a table
    activities = Activity.objects.filter(user=request.user)
    # Render the template passing the activities for display
    return render(request, "dashboard/home.html", {"activities": activities})


@login_required
@require_POST
def upload_data(request):
    """Receive selected activity data from the client and store it."""

    # The browser sends JSON entries via a POST form field called "entries"
    entries = request.POST.get("entries")
    if not entries:
        return JsonResponse({"error": "No data provided"}, status=400)

    try:
        import json

        data = json.loads(entries)
    except Exception as exc:  # noqa: BLE001
        return JsonResponse({"error": str(exc)}, status=400)

    # Persist each uploaded activity for later analysis
    for row in data:
        try:
            Activity.objects.create(
                user=request.user,
                activity_id=row.get("id", ""),
                distance=float(row.get("distance", 0)),
                duration=int(row.get("duration", 0)),
            )
        except (TypeError, ValueError) as exc:
            # If any row cannot be parsed, inform the client so they can fix the data
            return JsonResponse({"error": str(exc)}, status=400)

    return JsonResponse({"status": "ok"})

from django.urls import include
from django.urls import path
from rest_framework.routers import DefaultRouter

from .views import GraphViewSet

router = DefaultRouter()
router.register(r"graph", GraphViewSet)

app_name = "graph"
urlpatterns = [
    path("", include(router.urls)),
]

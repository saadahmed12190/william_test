from io import StringIO

import pytest
from django.core.management import call_command

from templatebackend.users.models import User


@pytest.mark.django_db()
class TestUserManager:
    def test_create_user(self):
        user = User.objects.create_user(
            email="john@mirari-dev-env.xyz",
            password="something-r@nd0m!",  # noqa: S106
        )
        assert user.email == "john@mirari-dev-env.xyz"
        assert not user.is_staff
        assert not user.is_superuser
        assert user.check_password("something-r@nd0m!")
        assert user.username is None

    def test_create_superuser(self):
        user = User.objects.create_superuser(
            email="admin@mirari-dev-env.xyz",
            password="something-r@nd0m!",  # noqa: S106
        )
        assert user.email == "admin@mirari-dev-env.xyz"
        assert user.is_staff
        assert user.is_superuser
        assert user.username is None

    def test_create_superuser_username_ignored(self):
        user = User.objects.create_superuser(
            email="test@mirari-dev-env.xyz",
            password="something-r@nd0m!",  # noqa: S106
        )
        assert user.username is None


@pytest.mark.django_db()
def test_createsuperuser_command():
    """Ensure createsuperuser command works with our custom manager."""
    out = StringIO()
    command_result = call_command(
        "createsuperuser",
        "--email",
        "henry@mirari-dev-env.xyz",
        interactive=False,
        stdout=out,
    )

    assert command_result is None
    assert out.getvalue() == "Superuser created successfully.\n"
    user = User.objects.get(email="henry@mirari-dev-env.xyz")
    assert not user.has_usable_password()

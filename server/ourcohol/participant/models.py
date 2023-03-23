from django.db import models
from accounts.models import User
from party.models import Party


class Participant(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="connected_party"
    )
    party = models.ForeignKey(
        Party, on_delete=models.CASCADE, related_name="participants"
    )
    drank_beer = models.IntegerField(default=0)
    drank_soju = models.IntegerField(default=0)
    amount_alcohol = models.IntegerField(default=1)
    is_host = models.BooleanField(default=False)

    def __str__(self):
        return self.user.email
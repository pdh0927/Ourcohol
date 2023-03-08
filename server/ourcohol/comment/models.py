from django.db import models
from party.models import Party
from accounts.models import User

class Comment(models.Model):
    id = models.AutoField(primary_key=True)
    content = models.CharField(max_length = 255)
    party =  models.ForeignKey(Party, on_delete=models.CASCADE, related_name='comments')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='comment', null=True)
    
    def __str__(self):
        return self.content

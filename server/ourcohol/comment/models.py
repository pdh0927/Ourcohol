from django.db import models
from party.models import Party, Participant

class Comment(models.Model):
    id = models.AutoField(primary_key=True)
    content = models.CharField(max_length = 255)
    party =  models.ForeignKey(Party, on_delete=models.CASCADE, related_name='comments')
    participant = models.ForeignKey(Participant, on_delete=models.CASCADE, related_name='comment')
    
    def __str__(self):
        return self.content

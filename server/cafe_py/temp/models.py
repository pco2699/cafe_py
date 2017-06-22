from django.db import models

# Create your models here.


class Temp(models.Model):
    """ 温湿度 """
    temp = models.DecimalField('温度', max_digits=5, decimal_places=2)
    humid = models.DecimalField('湿度', max_digits=5, decimal_places=2)
    creation_date = models.DateTimeField('生成日付', auto_now_add=True)

    def __str__(self):
        return str(self.id)

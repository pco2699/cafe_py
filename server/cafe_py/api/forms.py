from django.forms import ModelForm
from temp.models import Temp

class TempForm(ModelForm):
    """ 温湿度のフォーム """
    class Meta:
        model = Temp
        fields = ('temp', 'humid',)

from django.shortcuts import render
import json
from collections import OrderedDict
from temp.models import Temp
import decimal
import datetime
from django.http import HttpResponse

# Create your views here.


def render_json_response(request, data, status=None):
    """ responseをJSONで返却 """
    json_str = json.dumps(data, ensure_ascii=False, indent=2, cls=DecimalEncoder)
    callback = request.GET.get('callback')

    if not callback:
        callback = request.POST.get('callback')
    if callback:
        json_str = "%s(%s)" % (callback, json_str)
        response = HttpResponse(json_str, content_type='application/javascript; charset=UTF-8', status=status)
    else:
        response = HttpResponse(json_str, content_type='application/json; charset=UTF-8', status=status)
    return response


def temp_list(request):
    temps = []
    for temp in Temp.objects.all().order_by('id'):
        temp_dict = OrderedDict([
            ('id', temp.id),
            ('temp', temp.temp),
            ('humid', temp.humid),
            ('creation_date', temp.creation_date)
        ])
        temps.append(temp_dict)
    data = OrderedDict([('temps', temps)])
    return render_json_response(request, data)


class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            return float(o)
        if isinstance(o, datetime.datetime):
            return str(o)
        return super(DecimalEncoder, self).default(o)

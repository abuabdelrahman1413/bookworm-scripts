#!/usr/bin/env python3
from hijri_converter import convert
from datetime import datetime
#
# today = convert.Gregorian.today().to_hijri()
# print(type(today))
#
#
# تعريف قائمة بأسماء الأشهر الهجرية
months = [
    "Muharram", "Safar", "Rabi'al-Awwal", "Rabi'al-Thani", "Jumada al-Awwal", "Jumada al-Thani",
    "Rajab", "Sha'ban", "Ramadan", "Shawwal", "Dhu al-Qi'dah", "Dhu al-Hijjah"
]
def hijri_date():
    today = datetime.today()
    hijri = convert.Gregorian(today.year, today.month, today.day).to_hijri()
    month_name = months[hijri.month - 1]
    return f"Hijri: {hijri.year}/{month_name}/{hijri.day}"

#!/usr/bin/python3

# Source: https://gist.github.com/kraftwerk28/b1639cd42d218e2b221980d855afe9c2

import requests
import os
import sys

def get_response(app_id, location=None):
    url = "https://api.openweathermap.org/data/2.5/weather"
    params = {"appid": app_id, "units": "metric"}
    params["q"] = location
    return requests.get(url, params=params)

def get_weather_string(app_id, location=None):
    resp = get_response(app_id, location)
    data = resp.json()
    if data["cod"] != 200:
        exit(1)
        print("Error with data")
        print(data)
    temperature = int(data["main"]["temp"])
    if temperature > 0:
        temperature = f"+{temperature}"
    else:
        temperature = f"{temperature}"
    condition = data["weather"][0]["main"]
    location_icon = "\uf450 " if location is None else ""
    return f"{location_icon}{temperature}°C, {condition}"


def get_browser_url(app_id, location=None):
    json = get_response(app_id, location).json()
    id = json["id"]
    return f"https://openweathermap.org/city/{id}"

if __name__ == "__main__":
    if (app_id := os.getenv("OPENWEATHER_APP_ID")) is None:
        print("OPENWEATHER_APP_ID is not defined")
        sys.exit(1)

    location = os.getenv("OPENWEATHER_LOCATION")
    if location == "":
        sys.exit(2)
    if len(sys.argv) >= 2 and sys.argv[1] == "open":
        os.system(f"xdg-open {get_browser_url(app_id, location)}")
    else:
        print(get_weather_string(app_id, location))

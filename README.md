# TimeZoneConverter

![screenshot](img/time-zone.gif)

A small gem that prints out the time in other locations.
It supports a multiple cities, but it may be a bit slow in that case.
Any ideas how to make it faster are highly welcomed.

Inspired by:
https://www.timeanddate.com/worldclock/converter.html

It uses cities data extracted from cities gem: 
https://github.com/joecorcoran/cities

For nearest time zone calculation (based on city's coordinates) it uses another gem: https://rubygems.org/gems/nearest_time_zone

## Usage:

### 'c' command: current time in other cities
```
time_zone_converter c Warszawa Bangkok
```

### 'ct' command: given time in other cities (formant 'HH:MM' 24-hour)
```
time_zone_converter ct 'Chiang Mai' Skopje '19:00'
```

### 'ctu' command: given UTC+0 time in other cities
```
time_zone_converter ctu Bangkok Warszawa '10:00'
```


### Output:

```
[["Warszawa", 2019-10-04 10:00:00 +0200], ["Bangkok", Fri, 04 Oct 2019 15:00:00 +07 +07:00]]
```

### Help:

```
time_zone_converter
time_zone_converter help c
```

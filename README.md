# TimeZoneConverter

![screenshot](img/time-zone.gif)

A small gem, that can be used as a Command Line Interface. Inspired by:

- https://www.timeanddate.com/worldclock/converter.html
- https://stackoverflow.com/questions/8349817/ruby-gem-for-finding-timezone-of-location

In a few words, it prints out the time in other cities. Cities are passed as arguments.

## Usage:

### 'c' command: current time in other cities
```
time_zone_converter c Warszawa Bangkok
```
Output:
```
[
  ["Warszawa", Tue, 22 Oct 2019 13:30:02 CEST +02:00],
  ["Bangkok", Tue, 22 Oct 2019 18:30:02 +07 +07:00]
]
```

### 'ct' command: given time in other cities (formant 'HH:MM' 24-hour)
```
time_zone_converter ct 'Chiang Mai' Skopje '19:00'
```
Output:
```
[
  ["Chiang Mai", 2019-10-22 19:00:00 +0700], 
  ["Skopje", Tue, 22 Oct 2019 14:00:00 CEST +02:00]
]
```

### 'ctu' command: given UTC+0 time in other cities
```
time_zone_converter ctu Bangkok Warszawa '10:00'
```
Output:
```
[
  ["Bangkok", Tue, 22 Oct 2019 17:00:00 +07 +07:00], 
  ["Warszawa", Tue, 22 Oct 2019 12:00:00 CEST +02:00]
]
```

### Help:

```
time_zone_converter
time_zone_converter help c

### More

It supports multiple cities, however, it may be a bit slow in that case.
Any ideas how to make it faster are highly welcomed :)

Technically, this gem uses other gems under the hood:
`cities` gem, see here:
https://github.com/joecorcoran/cities
which provides latitude and longitude for all cities around the world.

The code responsible for extracting json data is placed in `json_data_transformer.rb` file.

For nearest time zone calculation it uses another gem called `nearest_tine_zone`:
https://rubygems.org/gems/nearest_time_zone

Summing up, it does not use any external API, just pure Ruby with ActiveSupport dependency.

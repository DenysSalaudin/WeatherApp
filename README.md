# WeatherApp
This is my second app that I created on my own. It's a weather app written in SwiftUI. In this app, I used CoreLocation, UserDefaults, Async/Await, Combine, MVVM, and OpenWeather API to retrieve weather data and obtain the locations of other cities.

To start using this app, it will ask for permission to access your location. The app consists of three screens.

The first screen always displays the name of your current location and the weather forecast for the current day and the next 7 days. If you tap on the view for the next 7 days, it will display the second view, which shows the hourly forecast for the next 48 hours. I divided the forecast into two parts: the first 24 hours and the second 24 hours.

Additionally, on the first screen, you can see a search bar. Tapping on the search bar will bring up the keyboard, allowing you to type the name of the city for which you want to check the weather. To access the third view, you need to select a city from the search results. This will display the same weather forecast as in the first view, but for the selected city.

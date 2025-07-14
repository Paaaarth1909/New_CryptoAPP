# CryptoX App

A Flutter cryptocurrency tracking application with real-time price updates, candlestick charts, and market analytics.

## Setup Instructions

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/cryptox_app.git
cd cryptox_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure API Keys:
   - Locate the template file at `lib/config/api_config.template.dart`
   - Create a new file `lib/config/api_config.dart`
   - Copy the contents from the template file
   - Replace the placeholder values with your actual API credentials:
     ```dart
     class ApiConfig {
       static const String baseUrl = 'YOUR_ACTUAL_API_BASE_URL';
       static const String apiKey = 'YOUR_ACTUAL_API_KEY';
     }
     ```

4. Run the app:
```bash
flutter run
```

## Features

- Real-time cryptocurrency price tracking
- Interactive candlestick charts
- Market overview and trends
- Portfolio management
- Price alerts and notifications

## Security Note

The `api_config.dart` file containing your actual API keys is automatically ignored by git to prevent accidentally committing sensitive information. Never commit this file to version control.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

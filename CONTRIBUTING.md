# Contributing to AmneziaWG-V2

Thank you for your interest in contributing! 🎉

## Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest features
- 📖 Improve documentation
- 🔧 Submit pull requests

## Development Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/awg-v2.git
cd awg-v2

# Create .env from example
cp .env.example .env

# Build and test
docker-compose up -d --build
```

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your fork (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Code Style

- Use clear, descriptive variable names
- Comment complex logic
- Follow existing code patterns
- Test your changes

## Testing

Before submitting:

```bash
# Test build
docker-compose build

# Test start/stop
docker-compose up -d
docker-compose down

# Check logs for errors
docker-compose logs
```

## Reporting Bugs

Include:
- Description of the bug
- Steps to reproduce
- Expected behavior
- Actual behavior
- Environment (OS, Docker version, etc.)
- Logs if applicable

## Questions?

Feel free to open an issue for discussion!

Thank you for contributing! 🙏

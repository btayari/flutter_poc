#!/bin/bash

# Tactical Lineup Editor - Quick Setup Script

echo "🚀 Setting up Tactical Lineup Editor..."

# Create assets directories
echo "📁 Creating assets directories..."
mkdir -p assets/players
echo "✓ Created assets/players/"

# Install Flutter packages
echo "📦 Installing Flutter packages..."
flutter pub get

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Download player images and place them in assets/players/"
echo "   Required files:"
echo "   - ederson.jpg, gvardiol.jpg, dias.jpg, akanji.jpg, walker.jpg"
echo "   - kovacic.jpg, rodri.jpg, bernardo.jpg"
echo "   - doku.jpg, haaland.jpg, foden.jpg"
echo ""
echo "2. (Optional) Add pitch texture: assets/pitch_pattern.png"
echo ""
echo "3. Run the app: flutter run"
echo ""
echo "📖 See SETUP.md for detailed instructions and asset sources"

#!/bin/bash

# Download placeholder player images for testing
# This script downloads 11 avatar images from pravatar.cc

echo "🖼️  Downloading placeholder player images..."
echo ""

# Create directory if it doesn't exist
mkdir -p assets/players

# Change to assets/players directory
cd assets/players

# Download images
echo "⬇️  Downloading images..."

curl -s -o ederson.jpg "https://i.pravatar.cc/300?img=1" && echo "✓ ederson.jpg"
curl -s -o gvardiol.jpg "https://i.pravatar.cc/300?img=2" && echo "✓ gvardiol.jpg"
curl -s -o dias.jpg "https://i.pravatar.cc/300?img=3" && echo "✓ dias.jpg"
curl -s -o akanji.jpg "https://i.pravatar.cc/300?img=4" && echo "✓ akanji.jpg"
curl -s -o walker.jpg "https://i.pravatar.cc/300?img=5" && echo "✓ walker.jpg"
curl -s -o kovacic.jpg "https://i.pravatar.cc/300?img=6" && echo "✓ kovacic.jpg"
curl -s -o rodri.jpg "https://i.pravatar.cc/300?img=7" && echo "✓ rodri.jpg"
curl -s -o bernardo.jpg "https://i.pravatar.cc/300?img=8" && echo "✓ bernardo.jpg"
curl -s -o doku.jpg "https://i.pravatar.cc/300?img=9" && echo "✓ doku.jpg"
curl -s -o haaland.jpg "https://i.pravatar.cc/300?img=10" && echo "✓ haaland.jpg"
curl -s -o foden.jpg "https://i.pravatar.cc/300?img=11" && echo "✓ foden.jpg"

echo ""
echo "✅ Downloaded 11 placeholder images to assets/players/"
echo ""
echo "💡 These are placeholder avatars for testing."
echo "   Replace with real player images for production."

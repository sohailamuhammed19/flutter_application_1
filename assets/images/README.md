# Images Folder Structure

This folder contains images for all landmarks in the Egypt Explorer app.

## Folder Structure

```
assets/images/
├── ancient_egyptian/    # Images for ancient Egyptian sites
│   ├── giza_pyramids.jpg
│   ├── karnak_temple.jpg
│   ├── valley_of_kings.jpg
│   └── abu_simbel.jpg
│
├── museums/             # Images for museums
│   ├── egyptian_museum.jpg
│   └── grand_egyptian_museum.jpg
│
├── islamic/             # Images for Islamic sites
│   ├── ibn_tulun_mosque.jpg
│   └── al_azhar_mosque.jpg
│
├── christian/           # Images for Christian sites
│   └── hanging_church.jpg
│
└── jewish/              # Images for Jewish sites
    └── ben_ezra_synagogue.jpg
```

## How to Add Images

1. **Download or save your images** with descriptive names
2. **Place them in the appropriate folder** based on the landmark category
3. **Recommended naming convention:**
   - Use lowercase letters
   - Separate words with underscores
   - Use .jpg, .jpeg, or .png format
   - Example: `giza_pyramids.jpg`

## Image Recommendations

- **Format:** JPG or PNG
- **Size:** Recommended 800x600px or larger (will be optimized by Flutter)
- **Aspect Ratio:** 4:3 or 16:9 works best for cards
- **File Size:** Keep under 1MB per image for better performance

## Using Images in the App

After adding images, update the `landmarks_data.dart` file to reference them:

```dart
imageUrl: 'assets/images/ancient_egyptian/giza_pyramids.jpg',
```

Or use them with `AssetImage`:

```dart
Image.asset('assets/images/ancient_egyptian/giza_pyramids.jpg')
```

## Current Landmarks Needing Images

- Giza Pyramid Complex
- The Egyptian Museum
- Karnak Temple Complex
- Mosque of Ibn Tulun
- Grand Egyptian Museum
- Valley of the Kings
- Abu Simbel Temples
- Al-Azhar Mosque
- Hanging Church
- Ben Ezra Synagogue


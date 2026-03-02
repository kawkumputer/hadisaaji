"""
Resize iPhone screenshots for App Store Connect submission.
Generates required sizes:
- iPhone 6.7" (1290 x 2796)
- iPhone 6.5" (1242 x 2688)  
- iPhone 5.5" (1242 x 2208)
"""

import os
from PIL import Image

SIZES = {
    "6.7inch": (1290, 2796),
    "6.5inch": (1242, 2688),
    "5.5inch": (1242, 2208),
}

INPUT_DIR = os.path.dirname(os.path.abspath(__file__))
SUPPORTED_EXTENSIONS = ('.png', '.jpg', '.jpeg', '.PNG', '.JPG', '.JPEG')

def resize_screenshot(img_path, target_size, output_path):
    """Resize image to target size, adding padding if needed to maintain aspect ratio."""
    img = Image.open(img_path)
    target_w, target_h = target_size
    
    # Calculate scale to fill the target size
    img_ratio = img.width / img.height
    target_ratio = target_w / target_h
    
    if img_ratio > target_ratio:
        # Image is wider, fit by height
        new_h = target_h
        new_w = int(img.width * (target_h / img.height))
    else:
        # Image is taller, fit by width
        new_w = target_w
        new_h = int(img.height * (target_w / img.width))
    
    img_resized = img.resize((new_w, new_h), Image.LANCZOS)
    
    # Create canvas and paste centered
    canvas = Image.new('RGB', (target_w, target_h), (255, 255, 255))
    x_offset = (target_w - new_w) // 2
    y_offset = (target_h - new_h) // 2
    
    # Handle RGBA images
    if img_resized.mode == 'RGBA':
        canvas.paste(img_resized, (x_offset, y_offset), img_resized)
    else:
        canvas.paste(img_resized, (x_offset, y_offset))
    
    canvas.save(output_path, 'PNG', quality=95)
    print(f"  -> {output_path} ({target_w}x{target_h})")

def main():
    # Find all screenshots
    screenshots = sorted([
        f for f in os.listdir(INPUT_DIR)
        if f.endswith(SUPPORTED_EXTENSIONS) and not f.startswith('resized_')
    ])
    
    if not screenshots:
        print("No screenshots found! Place your iPhone screenshots in this folder.")
        return
    
    print(f"Found {len(screenshots)} screenshots")
    
    for size_name, size in SIZES.items():
        output_dir = os.path.join(INPUT_DIR, size_name)
        os.makedirs(output_dir, exist_ok=True)
        print(f"\nGenerating {size_name} ({size[0]}x{size[1]}):")
        
        for i, filename in enumerate(screenshots, 1):
            img_path = os.path.join(INPUT_DIR, filename)
            output_path = os.path.join(output_dir, f"screenshot_{i}.png")
            resize_screenshot(img_path, size, output_path)
    
    print(f"\nDone! Upload the screenshots from each folder to App Store Connect.")

if __name__ == "__main__":
    main()

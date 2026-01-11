from PIL import Image
import numpy as np

def remove_background(input_path, output_path):
    img = Image.open(input_path).convert("RGBA")
    datas = img.getdata()

    newData = []
    # Approx color of the dark blue background based on the image provided
    # The image has a rounded square border.
    # A simple threshold might work if we pick the corner color.
    
    # Let's simple check the top-left pixel color
    bg_color = img.getpixel((5, 5))
    
    # Tolerance
    tol = 30 

    for item in datas:
        # Check if pixel is close to background color
        if abs(item[0] - bg_color[0]) < tol and abs(item[1] - bg_color[1]) < tol and abs(item[2] - bg_color[2]) < tol:
            newData.append((255, 255, 255, 0)) # Transparent
        else:
            newData.append(item)

    img.putdata(newData)
    
    # Resize to icon size (e.g., 64x64 or 128x128) just to be safe for favicon
    # But for Navbar we want high res.
    # Let's save a "logo.png" (high res) and "icon.png" (32x32)
    
    img.save(output_path, "PNG")
    
    # Create favicon
    icon = img.resize((32, 32), Image.Resampling.LANCZOS)
    icon.save("public/icon.png", "PNG")

remove_background("public/logo.jpg", "public/logo.png")

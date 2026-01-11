from PIL import Image

def get_bg_color(image_path):
    img = Image.open(image_path).convert("RGB")
    # Get top-left pixel
    bg_color = img.getpixel((0, 0))
    print(f"HEX: #{bg_color[0]:02x}{bg_color[1]:02x}{bg_color[2]:02x}")
    print(f"RGB: {bg_color}")

get_bg_color("public/sequences/ezgif-frame-001.jpg")

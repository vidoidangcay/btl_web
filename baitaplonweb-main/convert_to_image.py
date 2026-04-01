#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
from PIL import Image, ImageDraw, ImageFont

# Create a new image with white background
width, height = 900, 700
image = Image.new('RGB', (width, height), color='white')
draw = ImageDraw.Draw(image)

# Try to use a better font if available, otherwise use default
try:
    title_font = ImageFont.truetype("arial.ttf", 28)
    bold_font = ImageFont.truetype("arial.ttf", 14)
    text_font = ImageFont.truetype("arial.ttf", 12)
    small_font = ImageFont.truetype("arial.ttf", 11)
except:
    title_font = ImageFont.load_default()
    bold_font = ImageFont.load_default()
    text_font = ImageFont.load_default()
    small_font = ImageFont.load_default()

# Title
draw.text((450, 30), "Khóa Mã hóa", fill='#333333', font=title_font, anchor="mm")

# Draw central element (circle with key symbol)
draw.ellipse([100, 140, 200, 260], outline='#4CAF50', width=2)
draw.line([150, 130, 150, 270], fill='#4CAF50', width=4)
draw.line([120, 200, 180, 200], fill='#4CAF50', width=4)

# Left branch - Public key
draw.line([200, 200, 280, 120], fill='#666666', width=2)
draw.ellipse([260, 80, 340, 140], outline='#FF9800', width=2)
draw.text((300, 110), "🔓", fill='#FF9800', font=title_font, anchor="mm")
draw.text((300, 155), "Khóa Công khai", fill='#333333', font=bold_font, anchor="mm")

# Top branch - Encryption key
draw.line([200, 200, 350, 100], fill='#666666', width=2)
draw.ellipse([375, 55, 465, 115], outline='#2196F3', width=2)
draw.text((420, 85), "🔐", fill='#2196F3', font=title_font, anchor="mm")
draw.text((420, 135), "Khóa mã hóa sẽ", fill='#333333', font=small_font, anchor="mm")
draw.text((420, 150), "thay đổi mỗi lần,", fill='#333333', font=small_font, anchor="mm")

# Right top branch
draw.line([200, 200, 500, 100], fill='#666666', width=2)
draw.ellipse([525, 55, 615, 115], outline='#9C27B0', width=2)
draw.text((570, 85), "🔐", fill='#9C27B0', font=title_font, anchor="mm")
draw.text((570, 135), "nhưng cùng khóa", fill='#333333', font=small_font, anchor="mm")
draw.text((570, 150), "công khai được", fill='#333333', font=small_font, anchor="mm")
draw.text((570, 165), "dùng cho giai đoạn", fill='#333333', font=small_font, anchor="mm")

# Bottom text
draw.text((450, 280), "Khi sử dụng RSA, DH,", fill='#666666', font=text_font, anchor="mm")
draw.text((450, 300), "RSA hoặc ECDH_RSA", fill='#666666', font=text_font, anchor="mm")

# Info box
draw.rectangle([40, 340, 860, 680], outline='#CCCCCC', width=1)

# Legend title
draw.text((60, 360), "📋 Giải thích:", fill='#333333', font=bold_font)

# Legend items
y_pos = 390
items = [
    "• Khóa Công khai (Public Key): Khóa được chia sẻ công khai, dùng để mã hóa dữ liệu",
    "• Khóa Mã hóa (Encryption Key): Mỗi phiên giao tiếp sẽ tạo một khóa mã",
    "  hóa khác nhau",
    "• Giao thức RSA/DH/ECDH_RSA: Các thuật toán dùng để thiết lập khóa",
    "  an toàn giữa hai bên",
    "• Quy trình: Khóa công khai trao đổi, sau đó tạo khóa mã hóa riêng cho",
    "  mỗi phiên"
]

for item in items:
    draw.text((60, y_pos), item, fill='#555555', font=small_font)
    y_pos += 22

# Save the image
output_path = os.path.join(os.path.dirname(__file__), 'encryption_diagram_vi.png')
image.save(output_path, 'PNG')
print(f"✓ Ảnh đã được tạo: {output_path}")

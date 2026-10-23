"""Render original geometric logo/brand concepts, no film imagery or AI edits."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent
BG, FG, MUTED, AMBER = "#171B20", "#F1E9DA", "#7B858D", "#E9AA53"
FONT = "C:/Windows/Fonts/msyh.ttc"


def font(size):
    return ImageFont.truetype(FONT, size)


def avatar(size):
    scale = size / 1024
    image = Image.new("RGB", (size, size), BG)
    draw = ImageDraw.Draw(image)
    def box(values):
        return tuple(round(v * scale) for v in values)
    draw.rounded_rectangle(box((192, 232, 768, 616)), radius=round(30*scale), outline=MUTED, width=max(1,round(28*scale)))
    draw.rounded_rectangle(box((272, 328, 848, 712)), radius=round(30*scale), fill=BG, outline=FG, width=max(1,round(28*scale)))
    draw.line(box((680,392,784,392,784,496)), fill=AMBER, width=max(2,round(30*scale)))
    draw.ellipse(box((532,492,588,548)), fill=AMBER)
    return image


avatar(1024).save(ROOT / "avatar-concept.png")
avatar(48).save(ROOT / "avatar-48.png")
board = Image.new("RGB", (1600, 1050), BG)
d = ImageDraw.Draw(board)
d.text((72,48), "再看一幕", font=font(66), fill=FG)
d.text((74,140), "频道视觉方向 / CONCEPT 01", font=font(24), fill=MUTED)
board.paste(avatar(360), (72,220))
d.text((510,240), "好电影，值得再看一幕。", font=font(40), fill=FG)
d.text((510,310), "深灰底色  ·  暖白文字  ·  琥珀色观察标记", font=font(26), fill=MUTED)
d.text((510,372), "两层画框表示重看，小亮点指向被忽略的细节。", font=font(25), fill=FG)
d.text((510,420), "头像不放细小文字，适配圆形裁切与小尺寸显示。", font=font(25), fill=FG)
for i, color in enumerate((BG, FG, AMBER)):
    x=510+i*205
    d.rounded_rectangle((x,492,x+170,550),radius=8,fill=color,outline=MUTED,width=1)
    d.text((x,563),color,font=font(21),fill=MUTED)
d.line((72,640,1528,640),fill="#343A41",width=2)
d.text((72,680), "统一片头的四个静态关键画面",font=font(28),fill=FG)
labels=["01  画框进入","02  回看叠帧","03  观察点亮起","04  名称出现"]
for i,label in enumerate(labels):
    x=72+i*380
    d.rounded_rectangle((x,745,x+350,940),radius=12,fill="#232931")
    dd=ImageDraw.Draw(board)
    if i==0:
        dd.rectangle((x+70,790,x+280,900),outline=FG,width=3)
    else:
        dd.rectangle((x+52,770,x+255,870),outline=MUTED,width=3)
        dd.rectangle((x+76,794,x+280,894),fill="#232931",outline=FG,width=3)
    if i==2:
        dd.ellipse((x+170,834,x+184,848),fill=AMBER)
    if i==3:
        dd.ellipse((x+252,805,x+266,819),fill=AMBER)
        dd.text((x+95,815),"再看一幕",font=font(30),fill=FG)
    dd.text((x,968),label,font=font(22),fill=MUTED)
board.save(ROOT / "brand-direction.png")
print("Saved avatar-concept.svg, avatar-concept.png, avatar-48.png, brand-direction.png")

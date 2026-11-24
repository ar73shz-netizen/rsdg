import os
from PIL import Image, ImageDraw
src = Image.open('assets/icon-only.png').convert('RGB')
res = 'android/app/src/main/res'
for d, sz in {'mdpi':48,'hdpi':72,'xhdpi':96,'xxhdpi':144,'xxxhdpi':192}.items():
    p = f'{res}/mipmap-{d}'
    os.makedirs(p, exist_ok=True)
    im = src.resize((sz, sz), Image.LANCZOS)
    im.save(f'{p}/ic_launcher.png'); im.save(f'{p}/ic_launcher_foreground.png')
    m = Image.new('L', (sz*4, sz*4), 0)
    ImageDraw.Draw(m).ellipse((0, 0, sz*4-1, sz*4-1), fill=255)
    r = im.convert('RGBA'); r.putalpha(m.resize((sz, sz), Image.LANCZOS))
    r.save(f'{p}/ic_launcher_round.png')
for f in ('ic_launcher.xml', 'ic_launcher_round.xml'):
    q = f'{res}/mipmap-anydpi-v26/{f}'
    if os.path.exists(q): os.remove(q)
print('icons ok')

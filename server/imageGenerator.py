from PIL import Image
import requests
from io import BytesIO
from io import StringIO
import numpy as np
import urllib.request


def generateImage(tokenId, background_color, head, eyes, mouth, accessory, weapon):

    response = urllib.request.urlopen(
        f'https://ik.imagekit.io/98sb9awea/background_color/{background_color}.png')
    img1 = Image.open(response).convert("RGBA")

    response2 = urllib.request.urlopen(
        f'https://ik.imagekit.io/98sb9awea/head/{head}.png')
    img2 = Image.open(response2).convert("RGBA")
    print(img2.mode)

    intermediate1 = Image.alpha_composite(img1, img2)

    response3 = urllib.request.urlopen(
        f'https://ik.imagekit.io/98sb9awea/eyes/{eyes}.png')
    img3 = Image.open(response3).convert("RGBA")

    response4 = urllib.request.urlopen(
        f'https://ik.imagekit.io/98sb9awea/mouth/{mouth}.png')
    img4 = Image.open(response4).convert("RGBA")

    intermediate2 = Image.alpha_composite(img3, img4)

    intermediate3 = Image.alpha_composite(intermediate1, intermediate2)

    response5 = urllib.request.urlopen(
        f'https://ik.imagekit.io/98sb9awea/necklace/{accessory}.png')
    img5 = Image.open(response5).convert("RGBA")

    response6 = urllib.request.urlopen(
        f'https://ik.imagekit.io/98sb9awea/weapons/{weapon}.png')
    img6 = Image.open(response6).convert("RGBA")

    intermediate4 = Image.alpha_composite(img5, img6)

    final = Image.alpha_composite(intermediate3, intermediate4)
    final.save(f'{tokenId}.png')

    combined = background_color + head + eyes + mouth + accessory + weapon
    print(type(combined))
    # return combined
    return final

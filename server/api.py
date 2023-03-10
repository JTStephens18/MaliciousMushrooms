from fastapi import FastAPI
import imageGenerator as ig
from fastapi.responses import FileResponse
from fastapi.responses import Response
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

origins = [
    "http://localhost:3000",
    "localhost:3000",
    "https://maliciousmushrooms.com",
    "maliciousmushrooms.com"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)


@app.get("/test")
def root():
    return {"message": "Hello World"}


@app.get("/images/{tokenId}/{background}/{head}/{eyes}/{mouth}/{accessory}/{weapon}")
async def test(tokenId: int, background: str, head: str, eyes: str, mouth: str, accessory: str, weapon: str):
    testing = ig.generateImage(
        tokenId, background, head, eyes, mouth, accessory, weapon)
    # return Response(content=testing, media_type="image/png")
    return FileResponse(f'{tokenId}.png', media_type='image/png')
    return {"msg": f"{testing}"}
    # return {"message": f"{background} {head} {eyes} {mouth} {accessory} {weapon}"}

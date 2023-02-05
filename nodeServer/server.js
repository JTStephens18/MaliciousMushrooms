const fs = require('fs');
const { createCanvas, loadImage } = require('canvas');
const { flushSync } = require('react-dom');
var express = require('express');
var app = express();

const host = 'localhost';
const port = 5000;

const width = 1200;
const height = 600;

const canvas = createCanvas(width, height);
const context = canvas.getContext('2d');

app.listen(port, () => console.log("listening on port " + port + " at " + host + "..."));

app.get("/a", function(req, res) {
    res.json({"message": "Hello World"});
})

app.get("/test", function(req, res) {
    loadImage('https://i.imgur.com/uuidEb.png').then((image) => {
    context.drawImage(image, 340, 515, 70, 70);
    const buffer = canvas.toBuffer('image/png');
    fs.writeFileSync('test.png', buffer);
    // res.send(buffer)
    console.log("test");
});
})

// var server = app.listen(8081, function () {
//     var host = server.address().address
//     var port = server.address().port
//     console.log("Example app listening at http://%s:%s", host, port)
//  })
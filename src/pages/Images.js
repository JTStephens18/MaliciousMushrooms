import { Router, useParams } from "react-router-dom";
import "./Images.css";
import { useState, useEffect, useRef } from "react";
import cat from "../utils/photos/cat.png"

const Images = ({ids}) => {

    const [dataURI, setDataURI] = useState(null);
    const routeParams = useParams();

    console.log("routeParams: ", routeParams);

    var canvas = document.createElement('canvas');
    canvas.width = 350;
    canvas.height = 350;

    var urls = "https://maliciousmushrooms.com/#/images/Green/Oval-Red/Concerned/Creeper/Necklace/Scythe/Chestplate.png"
    var urlss= `https://maliciousmushrooms.com/#/images/${routeParams.backgroundColor}/${routeParams.head}/${routeParams.eyes}/${routeParams.mouth}/${routeParams.accessory}/${routeParams.weapon}/${routeParams.armor}`
    // var url = canvas.toDataURL(urls);
    // console.log("url: ", url);
    // document.getElementById('img1').src = url;
    // window.open(url)
    // var newTab = window.open('about:blank', 'image from canvas');
    // newTab.document.write("<img src='" + url + "' alt='from canvas'/>");

    const firstRender = useRef(true);
    useEffect(() => {
        firstRender.current = false;
        drawCanvas();
    },[]);

    // useEffect(() => {
    //     if(firstRender.current === false) {
    //         drawCanvas();
    //     }
    // }, [firstRender.current]);

    useEffect(() => {
        if(dataURI !== null) {
            console.log("send uri", dataURI);
            showDocument(dataURI, 'image/png');
        }
    }, [dataURI]);

    const drawCanvas = async () => {
        var ctx = document.getElementById('myCanvas').getContext('2d');
        var img = new Image();
        img.src = `https://ik.imagekit.io/98sb9awea/background_color/${routeParams.backgroundColor}.png`;
        img.crossOrigin = "Anonymous";
        img.onload = function() {
            ctx.drawImage(img, 0, 0, 350, 350);
            var img2 = new Image();
            img2.src = "https://ik.imagekit.io/98sb9awea/skin/_0121_Skin.png?ik-sdk-version=javascript-1.4.3&updatedAt=1673195645649";
            img2.crossOrigin = "Anonymous";
            img2.onload = function() {
                ctx.drawImage(img2, 0, 0, 350, 350);
                var img3 = new Image();
                img3.src = `https://ik.imagekit.io/98sb9awea/head/${routeParams.head}.png`;
                img3.crossOrigin = "Anonymous";
                img3.onload = function() {
                    ctx.drawImage(img3, 0, 0, 350, 350);
                    var img4 = new Image();
                    img4.src = `https://ik.imagekit.io/98sb9awea/eyes/${routeParams.eyes}.png`;
                    img4.crossOrigin = "Anonymous";
                    img4.onload = function() {
                        ctx.drawImage(img4, 0, 0, 350, 350);
                        var img5 = new Image();
                        img5.src = `https://ik.imagekit.io/98sb9awea/mouth/${routeParams.mouth}.png`;
                        img5.crossOrigin = "Anonymous";
                        img5.onload = function() {
                            ctx.drawImage(img5, 0, 0, 350, 350);
                            var img6 = new Image();
                            img6.src = `https://ik.imagekit.io/98sb9awea/necklace/${routeParams.accessory}.png`;
                            img6.crossOrigin = "Anonymous";
                            img6.onload = function() {
                                ctx.drawImage(img6, 0, 0, 350, 350);
                                var img7 = new Image();
                                img7.src = `https://ik.imagekit.io/98sb9awea/weapons/${routeParams.weapon}.png`;
                                img7.crossOrigin = "Anonymous";
                                img7.onload = function() {
                                    ctx.drawImage(img7, 0, 0, 350, 350);
                                    // var img8 = new Image();
                                    // img8.src = `https://ik.imagekit.io/98sb9awea/armor/${routeParams.armor}.png`;
                                    // img8.crossOrigin = "Anonymous";
                                    // img8.onload = function() {
                                    //     ctx.drawImage(img8, 0, 0, 350, 350);
                                    // }
                                }
                            }
                        }
                    }
                }
            }
        }
        const dataURIReturn = await makeDataURI();
        setDataURI(dataURIReturn);
    };

    const makeDataURI = async () => {
        const dataURI = document.getElementById('myCanvas').toDataURL();
        console.log("dataURI: ", dataURI);
        return dataURI;
    }

    const draw2 = () => {
        var ctx = document.getElementById('myCanvas').getContext('2d');
        ctx.font = "30px Arial";
        ctx.fillStyle = "red";
        ctx.fillText("Hello World", 10, 50);

        var img = new Image();
        img.src = `https://ik.imagekit.io/98sb9awea/background_color/${routeParams.backgroundColor}.png`;
        img.crossOrigin = "Anonymous";
        img.onload = function() {
            ctx.drawImage(img, 0, 0, 350, 350);
        }

        const dataURI = document.getElementById('myCanvas').toDataURL();
        console.log("dataURI: ", dataURI);
        setDataURI(dataURI);
    };

    const openWindow = () => {
        // let w = window.open(dataURI, "_blank");
        // let img = new Image();
        // img.src = dataURI;
        // w.document.write(img.outerHTML);
        // window.location.href = dataURI;
        let win = window.open();
        win.document.write('<iframe src="' + dataURI + '" frameborder="0" style="border:0; top:0px; left:0px; bottom:0px; right:0px; width:100%; height:100%;" allowfullscreen></iframe>');
    };

    function base64ToArrayBuffer(_base64Str) {
        var binaryString = window.atob(_base64Str);
        var binaryLen = binaryString.length;
        var bytes = new Uint8Array(binaryLen);
        for (var i = 0; i < binaryLen; i++) {
              var ascii = binaryString.charCodeAt(i);
              bytes[i] = ascii;
       }
       return bytes;
  }
  
  function showDocument(_base64Str, _contentType) {
        // var byte = base64ToArrayBuffer(_base64Str);
        var blob = dataURItoBlob(_base64Str);
        window.open(URL.createObjectURL(blob), "_blank");
  }

    function dataURItoBlob(dataURI) {
        var byteStr;
        if (dataURI.split(',')[0].indexOf('base64') >= 0)
            byteStr = atob(dataURI.split(',')[1]);
        else
            byteStr = unescape(dataURI.split(',')[1]);
    
        var mimeStr = dataURI.split(',')[0].split(':')[1].split(';')[0];
    
        var arr= new Uint8Array(byteStr.length);
        for (var i = 0; i < byteStr.length; i++) {
            arr[i] = byteStr.charCodeAt(i);
        }
    
        return new Blob([arr], {type:mimeStr});
    }

    const test = () => {
        let blob = dataURItoBlob(dataURI);

        const a = document.createElement("a");
        a.href = URL.createObjectURL(blob);
        a.download = "test.png";

        a.click();
    }

    return (
        <div>
            <svg width="350" height="350">
                <image width="350" height="350" href={dataURI}></image>
            </svg>
            {/* <h1>Images</h1>
            <h2>{routeParams.id}</h2> */}
            {/* <div className="image-div">
                <svg>
                    <img src={`https://ik.imagekit.io/98sb9awea/background_color/${routeParams.backgroundColor}.png`}></img>
                    <img src="https://ik.imagekit.io/98sb9awea/skin/_0121_Skin.png?ik-sdk-version=javascript-1.4.3&updatedAt=1673195645649" alt="skin"></img>
                    <img src={`https://ik.imagekit.io/98sb9awea/head/${routeParams.head}.png`} alt="head"></img>
                    <img src={`https://ik.imagekit.io/98sb9awea/eyes/${routeParams.eyes}.png`} alt="eyes"></img>
                    <img src={`https://ik.imagekit.io/98sb9awea/mouth/${routeParams.mouth}.png`} alt="mouth"></img>
                    <img src={`https://ik.imagekit.io/98sb9awea/necklace/${routeParams.accessory}.png`} alt="necklace"></img>
                    <img src={`https://ik.imagekit.io/98sb9awea/weapons/${routeParams.weapon}.png`} alt="weapon"></img>
                </svg>
            </div> */}

            {/* <svg> */}
            <canvas id="myCanvas" width="350" height="350"></canvas>
            {/* </svg> */}
{/* 
            <button onClick={() => drawCanvas()}>Draw</button>
            <button onClick={() => draw2()}>Draw2</button>
            <button onClick={() => openWindow()}>Open</button>
            <button onClick={() => test()}>Test</button> */}
        </div>
    );
}

export default Images;
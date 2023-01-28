import { Router, useParams } from "react-router-dom";
import "./Images.css";

const Images = ({ids}) => {

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

    const drawCanvas = () => {
        var ctx = canvas.getContext('2d');
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
        const dataURI = document.getElementById('myCanvas').toDataURL();
        console.log("dataURI: ", dataURI);
    };

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
    }

    return (
        <div>
            {/* <h1>Images</h1>
            <h2>{routeParams.id}</h2> */}
            <img 
                id="img1"
                src="test"
            />
            {/* <a href={`https://maliciousmushrooms.com/#/images/${routeParams.backgroundColor}/${routeParams.head}/${routeParams.eyes}/${routeParams.mouth}/${routeParams.accessory}/${routeParams.weapon}/${routeParams.armor}`}>
            <div className="image-div">
                    <img src={`https://ik.imagekit.io/98sb9awea/background_color/${routeParams.backgroundColor}.png`}></img>
                    <img src="https://ik.imagekit.io/98sb9awea/skin/_0121_Skin.png?ik-sdk-version=javascript-1.4.3&updatedAt=1673195645649" alt="skin"></img>
                    <img src={`https://ik.imagekit.io/98sb9awea/head/${routeParams.head}.png`} alt="head"></img>
                    <img src={`https://ik.imagekit.io/98sb9awea/eyes/${routeParams.eyes}.png`} alt="eyes"></img>
                    <img src={`https://ik.imagekit.io/98sb9awea/mouth/${routeParams.mouth}.png`} alt="mouth"></img>
                    <img src={`https://ik.imagekit.io/98sb9awea/necklace/${routeParams.accessory}.png`} alt="necklace"></img>
                    <img src={`https://ik.imagekit.io/98sb9awea/weapons/${routeParams.weapon}.png`} alt="weapon"></img>
            </div>
            </a> */}


            <canvas id="myCanvas" width="350" height="350"></canvas>

            <button onClick={() => drawCanvas()}>Draw</button>
            <button onClick={() => draw2()}>Draw2</button>

        </div>
    );
}

export default Images;
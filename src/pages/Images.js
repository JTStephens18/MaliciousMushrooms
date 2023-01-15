import { Router, useParams } from "react-router-dom";
import "./Images.css";

const Images = ({ids}) => {

    const routeParams = useParams();

    console.log("routeParams: ", routeParams);
    return (
        <div>
            <h1>Images</h1>
            <h2>{routeParams.id}</h2>
            <div className="image-div">
                <img src={`https://ik.imagekit.io/98sb9awea/background_color/${routeParams.backgroundColor}.png`}></img>
                {/* <img src="https://ik.imagekit.io/98sb9awea/skin/Skin.png?ik-sdk-version=javascript-1.4.3&updatedAt=1673121923922" alt="skin"></img> */}
                <img src="https://ik.imagekit.io/98sb9awea/skin/_0121_Skin.png?ik-sdk-version=javascript-1.4.3&updatedAt=1673195645649" alt="skin"></img>
                <img src={`https://ik.imagekit.io/98sb9awea/head/${routeParams.head}.png`} alt="head"></img>
                <img src={`https://ik.imagekit.io/98sb9awea/eyes/${routeParams.eyes}.png`} alt="eyes"></img>
                <img src={`https://ik.imagekit.io/98sb9awea/mouth/${routeParams.mouth}.png`} alt="mouth"></img>
                <img src={`https://ik.imagekit.io/98sb9awea/necklace/${routeParams.accessory}.png`} alt="necklace"></img>
                <img src={`https://ik.imagekit.io/98sb9awea/weapons/${routeParams.weapon}.png`} alt="weapon"></img>
            </div>
        </div>
    );
}

export default Images;
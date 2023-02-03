import { Router, useParams } from "react-router-dom";
import cat from "../utils/photos/cat.png"
const Test = ({routeParamsss}) => {
    const routeParams = useParams();
    return (
        <div>
            <h1>Test {routeParams.id}</h1>
            <a href={cat}>
            {/* <img 
            src={cat}
            /> */}
            </a>
        </div>
    )
}

export default Test;
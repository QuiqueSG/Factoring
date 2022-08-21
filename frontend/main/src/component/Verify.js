import React from "react";
import { verifyDocument } from "../util/interact";
import { denyDocument } from "../util/interact";


const Verify = () => {


    return (
        <div class="btn-group-vertical m-3">
            <button type="button" class="btn btn-success" onClick={verifyDocument}>Trust</button>
            <button type="button" class="btn btn-danger" onClick={denyDocument}>Deny</button>

        </div>
    );

}

export default Verify;
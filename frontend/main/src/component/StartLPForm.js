import React from "react";
import { useState } from "react";
import { startLP } from "../util/interact";

const StartLPForm = () => {

    const [values, setValues] = useState({
        ethPool: "",
        tokenPool: "",
    });

    const [submitted, setSubmitted] = useState(false);

    const handleEthPoolInputChange = (event) => {
        setValues({...values, ethPool: event.target.value || ""});
    }

    const handleTokenPoolInputChange = (event) => {
        setValues({...values, tokenPool: event.target.value || ""});
    }

    const handleSubmit = (event) => {
        event.preventDefault();
        setSubmitted(true);
        startLP(values.tokenPool, values.ethPool);
    }
    //UI

    return (
        <div className="form-container">
            <h5> Start Liquidity Pool </h5>
            <form className="register-form" onSubmit={handleSubmit}>
            {submitted ? <div className="success-message">Sended!</div> : null}
                <input
                    onChange={handleEthPoolInputChange}
                    value={values.ethPool}
                    className="form-field"
                    type="number"
                    placeholder="1 ETH"
                    name="ethPool">
                </input>
                <input
                    onChange={handleTokenPoolInputChange}
                    value={values.tokenPool}
                    className="form-field"
                    type="number"
                    placeholder="1000 TFAs"
                    name="tokenPool">
                        
                </input>
                <button
                    className="form-field"
                    type="submit">
                        Start
                </button>

            </form>

        </div>
    );
};

export default StartLPForm;
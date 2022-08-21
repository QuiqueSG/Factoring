import React from "react";
import { useState } from "react";
import { newDocument } from "../util/interact";


const NewDocForm = () => {

    const [values, setValues] = useState({
        nombreDoc: "",
        precio: "",
        expDays: "",
    });

    const [submitted, setSubmitted] = useState(false);

    const handleFirstNameInputChange = (event) => {
        setValues({...values, nombreDoc: event.target.value || ""});
    }

    const handleLastNameInputChange = (event) => {
        setValues({...values, precio: event.target.value || ""});
    }

    const handleEmailInputChange = (event) => {
        setValues({...values, expDays: event.target.value || ""});
    }

    const handleSubmit = (event) => {
        event.preventDefault();
        setSubmitted(true);
        newDocument(values.nombreDoc, values.precio, values.expDays);
    }
    //UI

    return (
        <div className="form-container">
            <h5> New Document </h5>
            <form className="register-form" onSubmit={handleSubmit}>
            {submitted ? <div className="success-message">Sended!</div> : null}
                <input
                    onChange={handleFirstNameInputChange}
                    value={values.nombreDoc}
                    className="form-field"
                    placeholder="Filename"
                    name="filename">
                </input>
                <input
                    onChange={handleLastNameInputChange}
                    value={values.precio}
                    className="form-field"
                    type="number"
                    placeholder={1000}
                    name="precio">
                </input>
                <input
                    onChange={handleEmailInputChange}
                    value={values.expDays}
                    className="form-field"
                    type="number"
                    placeholder={30}
                    name="days">
                </input>
                <button
                    className="form-field"
                    type="submit">
                        Save
                </button>

            </form>

        </div>
    );
};

export default NewDocForm;
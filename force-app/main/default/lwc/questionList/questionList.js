import { api, LightningElement } from "lwc";
import getCurrentChecklistId from "@salesforce/apex/ShipmentController.getCurrentChecklistId";
import getChecklistValues from "@salesforce/apex/ShipmentController.getChecklistValues";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

function checklistSetup(fields) {
    getCurrentChecklistId({ recordId: this.recordId })
        .then((resp) => {
            if (resp.isSuccess) {
                this.currentChecklistId = resp.responseObj;
            } else {
                const idError = new ShowToastEvent({
                    title: "Checklist Id error",
                    variant: "error",
                    message: resp.responseObj
                });
                this.dispatchEvent(idError);
            }
            // 2
            getChecklistValues({
                currentChecklistId: resp.responseObj,
                fields: fields
            })
                .then((response) => {
                    if (response.isSuccess) {
                        this.values = response.responseObj;
                    } else {
                        const valuesError = new ShowToastEvent({
                            title: "Checklist values error",
                            variant: "error",
                            message: response.responseObj
                        });
                        this.dispatchEvent(valuesError);
                    }
                })
                .catch((errorOnValues) => {
                    const onValues = new ShowToastEvent({
                        title: "Checklist setup error",
                        variant: "error",
                        message: "Error: " + errorOnValues.body.message
                    });
                    this.dispatchEvent(onValues);
                });
        })
        .catch((errorOnId) => {
            const onId = new ShowToastEvent({
                title: "Checklist setup error",
                variant: "error",
                message: "Error: " + errorOnId.body.message
            });
            this.dispatchEvent(onId);
        });
}

export default class QuestionList extends LightningElement {
    @api recordId;
    @api questions;
    @api fields;
    currentChecklistId;
    values;

    connectedCallback() {
        checklistSetup.call(this, this.fields);
    }
}

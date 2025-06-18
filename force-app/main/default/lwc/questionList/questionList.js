import { api, LightningElement } from "lwc";
import getCurrentChecklistId from "@salesforce/apex/ShipmentController.getCurrentChecklistId";
import getChecklistValues from "@salesforce/apex/ShipmentController.getChecklistValues";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class QuestionList extends LightningElement {
    @api recordId;
    @api questions;
    @api fields;
    currentChecklistId;
    values;

    connectedCallback() {
        this.checklistSetup(this.recordId, this.fields);
    }

    checklistSetup(recordId, fields) {
        getCurrentChecklistId({ recordId }).then((resp) => {
            const currentChecklistId = resp.responseObj;
            getChecklistValues({
                currentChecklistId,
                fields
            }).then((resp) => {
                if (!resp.isSuccess) {
                    throw new Error(
                        "Checklist values error: " + resp.responseObj
                    );
                }
                this.currentChecklistId = currentChecklistId;
                this.values = resp.responseObj;
            });
        });
    }
    handleSave() {
        this.dispatchEvent(new CustomEvent("save"));
    }
}

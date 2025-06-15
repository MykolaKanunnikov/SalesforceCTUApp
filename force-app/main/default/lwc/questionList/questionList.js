import { api, LightningElement } from "lwc";
import getCurrentChecklistId from "@salesforce/apex/ShipmentController.getCurrentChecklistId";
import getChecklistValues from "@salesforce/apex/ShipmentController.getChecklistValues";
import updateChecklistValues from "@salesforce/apex/ShipmentController.updateChecklistValues";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class QuestionList extends LightningElement {
    @api recordId;
    @api questions;
    @api fields;
    currentChecklistId;
    values;
    temporaryValues;

    async connectedCallback() {
        try {
            const { currentChecklistId, values } = await this.checklistSetup(
                this.recordId,
                this.fields
            );
            this.currentChecklistId = currentChecklistId;
            this.values = values;
            this.temporaryValues = values;
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Checklist setup error",
                    variant: "error",
                    message: error.message
                })
            );
        }
    }
    async checklistSetup(recordId, fields) {
        try {
            const idResp = await getCurrentChecklistId({ recordId });
            if (!idResp.isSuccess) {
                throw new Error("Checklist Id error: " + idResp.responseObj);
            }
            const currentChecklistId = idResp.responseObj;
            const valuesResp = await getChecklistValues({
                currentChecklistId,
                fields
            });
            if (!valuesResp.isSuccess) {
                throw new Error(
                    "Checklist values error: " + valuesResp.responseObj
                );
            }
            return {
                currentChecklistId,
                values: valuesResp.responseObj
            };
        } catch (error) {
            throw new Error(
                "Checklist setup failed: " +
                    (error.body?.message || error.message)
            );
        }
    }

    handleChange(event) {
        const { value, fieldWithPrefix } = event.detail;
        this.temporaryValues = {
            ...this.temporaryValues,
            [fieldWithPrefix]: value
        };
    }


handleSave() {
 updateChecklistValues({ currentChecklistId: this.currentChecklistId, values: this.temporaryValues })
        .then((resp) => {
            if (resp.isSuccess) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Checklist saved successfully',
                        variant: 'success',
                    })
                );
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: resp.responseObj || 'Unknown error',
                        variant: 'error',
                    })
                );
            }
        })
        .catch((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error saving checklist',
                    message: error.body ? error.body.message : error.message,
                    variant: 'error',
                })
            );
        });
}

}

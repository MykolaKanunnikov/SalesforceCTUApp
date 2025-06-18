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

    async connectedCallback() {
        try {
            const { currentChecklistId, values } = await this.checklistSetup(
                this.recordId,
                this.fields
            );
            this.currentChecklistId = currentChecklistId;
            this.values = values;
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
}

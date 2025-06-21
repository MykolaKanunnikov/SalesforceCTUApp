import { api, LightningElement } from "lwc";
import getCurrentChecklistId from "@salesforce/apex/ShipmentController.getCurrentChecklistId";
import getChecklistValues from "@salesforce/apex/ShipmentController.getChecklistValues";

export default class QuestionList extends LightningElement {
    @api recordId;
    @api questions;
    @api fields;
    currentChecklistId;
    values;
    newValues;
    icons = {
        warning: "utility:warning",
        success: "utility:success"
    };

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
                this.newValues = resp.responseObj;
            });
        });
    }

    changeAnswer(fieldReference, newFieldValue) {
        const data = Object.fromEntries(
            Object.entries(this.newValues).map(([key, value]) => {
                if (key === fieldReference) {
                    return [key, newFieldValue];
                }
                return [key, value];
            })
        );
        return data;
    }

    checkAnswers() {
        return Object.entries(this.newValues)
            .filter(([key]) => key !== "Id")
            .every(([, value]) => value === "YES" || value === "N/A");
    }
    handleSave(event) {
        this.newValues = this.changeAnswer(
            event.detail.fieldReference,
            event.detail.newValue
        );
        const answer = this.checkAnswers();
        if (answer) {
            this.dispatchEvent(
                new CustomEvent("icon", {
                    detail: { section: this.fields, icon: this.icons.success }
                })
            );
        } else {
            this.dispatchEvent(
                new CustomEvent("icon", {
                    detail: { section: this.fields, icon: this.icons.warning }
                })
            );
        }
    }
}

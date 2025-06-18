import updateRadioValue from "@salesforce/apex/ShipmentController.updateRadioValue";
import { api, LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const prefix = "ctuapptest__";

export default class QuestionAnswer extends LightningElement {
    @api checklist;
    @api title;
    @api fieldValue;
    @api fieldPath;
    @api values;
    currentValue;

    options = [
        { label: "YES", value: "YES" },
        { label: "NO", value: "NO" },
        { label: "N/A", value: "N/A" }
    ];

    handleChange(event) {
        const fieldReference = prefix + this.fieldPath;
        this.radioChange(fieldReference, event.target.value, this.checklist);
    }

    connectedCallback() {
        const fieldReferenceToGetValue = prefix + this.fieldPath;
        this.currentValue = this.values[fieldReferenceToGetValue];
    }

    radioChange(fieldReference, newValue, id) {
        updateRadioValue({ currentChecklistId: id, valueId: fieldReference, value: newValue })
            .then(resp => {
                if (resp.isSuccess) {
                    this.dispatchEvent(new CustomEvent("save", {
                        bubbles: true,
                        composed: true
                    }));
                }
            })
            .catch(error => {
                const noResponseEvent = new ShowToastEvent({
                    title: 'Save error',
                    variant: 'error',
                    message: 'No response / saving: ' + (error.body?.message || error.message)
                });
                this.dispatchEvent(noResponseEvent);
            });
    }
}

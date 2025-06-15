import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateRadioValue from "@salesforce/apex/ShipmentController.updateRadioValue";

export default class PackingArea1to7 extends NavigationMixin(LightningElement) {
    @api question;
    @api values;
    @api recordId;
    @api checklist;

    handleChange(event) {
        updateRadioValue({
            currentChecklistId: this.checklist,
            valueId: event.detail.fieldWithPrefix,
            value: event.detail.value
        })
            .then((resp) => {
                if (!resp.isSuccess) {
                    const errorEvent = new ShowToastEvent({
                        title: "Save error",
                        variant: "error",
                        message: resp.responseObj
                    });
                    this.dispatchEvent(errorEvent);
                }
            })
            .catch((error) => {
                const noResponseEvent = new ShowToastEvent({
                    title: "Save error",
                    variant: "error",
                    message: "No response / saving: " + error.body.message
                });
                this.dispatchEvent(noResponseEvent);
            });
    }
}

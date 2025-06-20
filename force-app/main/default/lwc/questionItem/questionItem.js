import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class QuestionItem extends NavigationMixin(LightningElement) {
    @api question;
    @api values;
    @api recordId;
    @api checklist;

    handleSave(event) {
        this.dispatchEvent(
            new CustomEvent("save", {
                detail: {
                    newValue: event.detail.newValue,
                    fieldReference: event.detail.fieldReference
                }
            })
        );
    }
}

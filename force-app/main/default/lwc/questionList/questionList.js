import { checklistSetup } from "c/radioGroupButtonAndHelp";
import { api, LightningElement } from "lwc";

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

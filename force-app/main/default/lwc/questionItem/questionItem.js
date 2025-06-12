import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import {
    radioChange,
} from "c/radioGroupButtonAndHelp";

export default class PackingArea1to7 extends NavigationMixin(LightningElement) {
    @api question;
    @api values;
    @api recordId;
    @api checklist;
    
    
    handleChange(event) {
        this.currentChecklistId = this.checklist;
        event.target.value = event.detail.value;
        event.target.dataset.id = event.detail.field;
        radioChange.call(this, event);
    }
}

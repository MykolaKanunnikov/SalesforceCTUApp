import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class PackingArea1to7 extends NavigationMixin(LightningElement) {
    @api question;
    @api values;
    @api recordId;
    @api checklist;
}
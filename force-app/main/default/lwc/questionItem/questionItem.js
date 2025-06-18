import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class QuestionItem extends NavigationMixin(LightningElement) {
    @api question;
    @api values;
    @api recordId;
    @api checklist;
}

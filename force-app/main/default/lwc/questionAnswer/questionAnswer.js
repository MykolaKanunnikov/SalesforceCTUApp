import { api, LightningElement } from 'lwc';
import { options, checklistSetup,radioChange } from 'c/radioGroupButtonAndHelp';

export default class QuestionAnswer extends LightningElement {
    @api recordId
    @api title;
    @api fieldValue;
    @api fieldReference;
    options = options();

    // save values from a radio button to the 3database
    handleChange(event) {
        radioChange.call(this, event);
    }

    connectedCallback() {
        checklistSetup.call(this, 'packingArea');         
    }
    
}
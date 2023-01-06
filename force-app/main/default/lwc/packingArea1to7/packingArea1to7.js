import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'
import { openReference, radioChange, options, checklistSetup } from 'c/radioGroupButtonAndHelp';
import { packingAreaQuestions } from 'c/questions';

export default class PackingArea1to7 extends NavigationMixin(LightningElement) {

    @api recordId;

    currentChecklistId;

    packingAreaQuestions = packingAreaQuestions;

    values = '';

    // set values and currentChecklistId fields
    connectedCallback() {
        const fields = 'packingArea1__c, packingArea2__c, packingArea3__c, packingArea4__c, packingArea5__c, packingArea6__c, packingArea7__c';
        checklistSetup.call(this, fields);
    }

    // define radio group settings 
    options = options();

    // in the following code '.call' is needed to explicitly tell the  
    // imported utility function to use 'this' from the given component

    // display a relevant reference file.
    handleClick(event) {
        openReference.call(this, event);
    }

    // save values from a radio button to the database
    handleChange(event) {
        radioChange.call(this, event);
    }

}
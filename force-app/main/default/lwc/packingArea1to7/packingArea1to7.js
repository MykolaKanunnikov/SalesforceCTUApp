import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'
import { openReference, radioChange, options, checklistSetup } from 'c/radioGroupButtonAndHelp';
import { packingArea } from 'c/questions';

export default class PackingArea1to7 extends NavigationMixin(LightningElement) {

    @api recordId;

    currentChecklistId;

    packingArea = packingArea;

    values = '';

    // in the following code '.call' is needed to explicitly tell the  
    // imported utility function to use 'this' from the given component

    // set values and currentChecklistId fields
    connectedCallback() {
        const fields = 'ctuapptest__packingArea1__c, ctuapptest__packingArea2__c, ctuapptest__packingArea3__c, ctuapptest__packingArea4__c, ctuapptest__packingArea5__c, ctuapptest__packingArea6__c, ctuapptest__packingArea7__c';
        checklistSetup.call(this, fields);
    }

    // define radio group settings 
    options = options();

    // display a relevant reference file.
    handleClick(event) {
        openReference.call(this, event);
    }

    // save values from a radio button to the database
    handleChange(event) {
        radioChange.call(this, event);
    }

}
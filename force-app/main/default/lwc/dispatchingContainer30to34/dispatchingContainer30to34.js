import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'
import { openReference, radioChange, options, checklistSetup } from 'c/radioGroupButtonAndHelp';
import { dispatchingContainer } from 'c/questions';

export default class DispatchingContainer30to34 extends NavigationMixin(LightningElement) {
    @api recordId;

    currentChecklistId;

    dispatchingContainer = dispatchingContainer;

    values = '';

    // in the following code '.call' is needed to explicitly tell the  
    // imported utility function to use 'this' from the given component

    // set values and currentChecklistId fields
    connectedCallback() {
        const fields = 'ctuapptest__dispatchingContainer30__c, ctuapptest__dispatchingContainer31__c, ctuapptest__dispatchingContainer32__c, ctuapptest__dispatchingContainer33__c, ctuapptest__dispatchingContainer34__c';
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
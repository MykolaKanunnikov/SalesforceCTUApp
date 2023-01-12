import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'
import { openReference, radioChange, options, checklistSetup } from 'c/radioGroupButtonAndHelp';
import { containerCondition } from 'c/questions';

export default class ContainerCondition8to12 extends NavigationMixin(LightningElement)  {
    @api recordId;

    currentChecklistId;

    containerCondition = containerCondition;

    values = '';

    // in the following code '.call' is needed to explicitly tell the  
    // imported utility function to use 'this' from the given component

    // set values and currentChecklistId fields
    connectedCallback() {
        const fields = 'ctuapptest__containerCondition8__c, ctuapptest__containerCondition9__c, ctuapptest__containerCondition10__c, ctuapptest__containerCondition11__c, ctuapptest__containerCondition12__c';
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
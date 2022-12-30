import { LightningElement, api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
import getFileRecordId from '@salesforce/apex/FreightContainerController.getFileRecordId';
import getCurrentChecklistId from '@salesforce/apex/FreightContainerController.getCurrentChecklistId';
import updateRadioValue from '@salesforce/apex/FreightContainerController.updateRadioValue';

export default class PackingArea1to7 extends NavigationMixin(LightningElement) {

    @api recordId;
    
    currentChecklistId;

    value = '';

    // 1. define apropriate checklist when a component is inserted to the DOM
    // 2. retrieve already inserted values
    connectedCallback() {
        // 1
        if(!this.currentChecklistId){
            getCurrentChecklistId({recordId: this.recordId})
                .then(result =>{
                    this.currentChecklistId = result;
                });
        }

        //2
        
    }

    // define radio group settings 
    get options() {
        return [
            { label: 'YES', value: 'YES' },
            { label: 'NO', value: 'NO' },
            { label: 'N/A', value: 'N/A' },
        ];
    }

    // display a relevant reference file
    handleClick(event){
        let itemId = event.target.dataset.id;
        let itemTitle = `${itemId}.pdf`;
        getFileRecordId({title: itemTitle})
            .then(properPdfId => {                
                try{
                this[NavigationMixin.Navigate]({ 
                    type: "standard__namedPage",
                    attributes: {
                        pageName: 'filePreview' 
                    },
                    state:{
                        selectedRecordId: properPdfId
                    }
                });
                }catch(error){
                    console.error(error);
                }  
            });
    }

    // save values from a radio button to the database
    handleChange(event){
        let value = event.target.value;
        let valueId = event.target.dataset.id;
        if(this.currentChecklistId){
            updateRadioValue({currentChecklistId: this.currentChecklistId, valueId: valueId, value: value});
        }
    }

}
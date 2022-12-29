import { LightningElement, api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
import getFileRecordId from '@salesforce/apex/FreightContainerController.getFileRecordId';
import getCurrentChecklistId from '@salesforce/apex/FreightContainerController.getCurrentChecklistId';

export default class PackingArea1to7 extends NavigationMixin(LightningElement) {

    @api recordId;

    currentChecklistId;

    value = '';

    // It defines radio group settings 
    get options() {
        return [
            { label: 'YES', value: 'YES' },
            { label: 'NO', value: 'NO' },
            { label: 'N/A', value: 'N/A' },
        ];
    }

    // It displays a relevant reference file
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

    // It saves values from a radio button to the database
    handleChange(event){
        let value = event.target.value;
        let valueId = event.target.dataset.id;
        console.log('value: ' + value);
        console.log('id: ' + valueId);
        console.log('recordId: ' + this.recordId);
        console.log('currentChecklistId - 1 ' + this.currentChecklistId);
        //get id of the checklist if it is not undefined
        if(!this.currentChecklistId){
            getCurrentChecklistId({recordId: this.recordId})
                .then(result =>{
                this.currentChecklistId = result;
            });
            console.log('currentChecklistId - 2 ' + this.currentChecklistId);
        }
        // Not "else" as it should do insert right after the checklist id had gotten
        if(this.currentChecklistId){

        }

    }

}
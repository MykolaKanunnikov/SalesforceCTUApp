import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
import getFileRecordId from '@salesforce/apex/FreightContainerController.getFileRecordId';


export default class RadioGroupButtonAndHelp extends NavigationMixin(LightningElement) {
    value = '';

    get options() {
        return [
            { label: 'YES', value: 'YES' },
            { label: 'NO', value: 'NO' },
            { label: 'N/A', value: 'N/A' },
        ];
    }

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

}
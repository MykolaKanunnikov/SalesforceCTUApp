import { NavigationMixin } from 'lightning/navigation'
import getFileRecordId from '@salesforce/apex/ShipmentController.getFileRecordId';
import updateRadioValue from '@salesforce/apex/ShipmentController.updateRadioValue';

// define radio group 
const options = () => {
    return [
        { label: 'YES', value: 'YES' },
        { label: 'NO', value: 'NO' },
        { label: 'N/A', value: 'N/A' }
    ];
};

// display a relevant reference file.    
function openReference(event) {
    let itemId = event.target.dataset.id;
    let itemTitle = `${itemId}.pdf`;
    getFileRecordId({ title: itemTitle })
        .then(properPdfId => {
            try {
                this[NavigationMixin.Navigate]({
                    type: "standard__namedPage",
                    attributes: {
                        pageName: 'filePreview'
                    },
                    state: {
                        selectedRecordId: properPdfId
                    }
                });
            } catch (error) {
                console.error(error);
            }
        });
}

// save values from a radio button to the database
function radioChange(event) {
    let value = event.target.value;
    let valueId = event.target.dataset.id;
    if (this.currentChecklistId) {
        updateRadioValue({ currentChecklistId: this.currentChecklistId, valueId: valueId, value: value });
    }
}

export { openReference, radioChange, options };
import { LightningElement } from 'lwc';
import CTUref from '@salesforce/resourceUrl/CTUref';
import formFactorPropertyName from '@salesforce/client/formFactor'
import modalReference from 'c/modalReference';
import {NavigationMixin} from 'lightning/navigation'



export default class RadioGroupButtonAndHelp extends NavigationMixin(LightningElement) {
    value = '';
    refCTU = CTUref;
    largeFormFactor = formFactorPropertyName === 'Large';
    smallFormFactor = formFactorPropertyName === 'Small';


    get options() {
        return [
            { label: 'YES', value: 'YES' },
            { label: 'NO', value: 'NO' },
            { label: 'N/A', value: 'N/A' },
        ];
    }

    handleClick(){
     modalReference.open({
        size: 'large'
     })
    }
    handleMobileClick(){
        // itemId = event.target.dataset.id;
         this[NavigationMixin.Navigate]({
             "type": "standard__webPage",
             "attributes": {
                 "url": CTUref + '1' 
             }
         });
      
 
}
}
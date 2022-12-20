import { LightningElement } from 'lwc';
import CTUref from '@salesforce/resourceUrl/Ch7';
import formFactorPropertyName from '@salesforce/client/formFactor'
import modalReference from 'c/modalReference';


export default class RadioGroupButtonAndHelp extends LightningElement {
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

}
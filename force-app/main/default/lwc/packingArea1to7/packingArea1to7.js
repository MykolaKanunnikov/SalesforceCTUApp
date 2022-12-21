import { LightningElement } from 'lwc';
import formFactorPropertyName from '@salesforce/client/formFactor'
import modalReference from 'c/modalReference';

export default class PackingArea1to7 extends LightningElement {

    value = '';
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
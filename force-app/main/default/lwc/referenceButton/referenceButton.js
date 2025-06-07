import { api, LightningElement } from 'lwc';
import { openReference } from 'c/radioGroupButtonAndHelp';
import { NavigationMixin } from 'lightning/navigation';

export default class ReferenceButton extends  NavigationMixin(LightningElement) {
    @api reference
        handleClick(event) {
            openReference.call(this, event);
        }
}
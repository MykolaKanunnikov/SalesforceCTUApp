import { createElement } from 'lwc';
import ChecklistTabset from 'c/checklistTabset';
import getIconMapObject from '@salesforce/apex/ShipmentController.getIconMapObject';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const mockGetIconMapObject = require('./data/getIconMapObject.json');
const mockResponseFail = require('./data/responseFail.json');

// Sample error for imperative Apex call
const APEX_CONTACTS_ERROR = {
    body: { message: 'An internal server error has occurred' },
    ok: false,
    status: 400,
    statusText: 'Bad Request'
};

jest.mock(
    '@salesforce/apex/ShipmentController.getIconMapObject',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

// Helper function to wait until the microtask queue is empty. This is needed for promise
// timing when calling imperative Apex.
async function flushPromises() {
    return Promise.resolve();
}


describe('c-checklist-tabset', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        // Prevent data saved on mocks from leaking between tests
        jest.clearAllMocks();
    });

    it('populates the iconName property of the child tab component', async () => {
        // Assign mock value for resolved Apex promise
        getIconMapObject.mockResolvedValue(mockGetIconMapObject);

        // Arrange
        const element = createElement('c-checklist-tabset', {
            is: ChecklistTabset
        });

        // Act
        document.body.appendChild(element);

        // Wait for any asynchronous DOM updates
        await flushPromises();

        // Get the lightning-tab element
        const packingAreaTab = element.shadowRoot.querySelector('lightning-tab');

        // Assert
        expect(packingAreaTab.iconName).toBe(mockGetIconMapObject.responseObj.packingArea);
    });

    it('does not populate the iconName property of the child tab component', async () => {
        // Assign mock value for resolved Apex promise
        getIconMapObject.mockResolvedValue(mockResponseFail);

        // Arrange
        const element = createElement('c-checklist-tabset', {
            is: ChecklistTabset
        });

        // Act
        document.body.appendChild(element);

        // Wait for any asynchronous DOM updates
        await flushPromises();

        // Get the lightning-tab element
        const packingAreaTab = element.shadowRoot.querySelector('lightning-tab');

        // Assert
        expect(packingAreaTab.iconName).toBe(undefined);
    });
    
    it('shows toast on rejected promise', async () => {
        // Assign mock value for resolved Apex promise
        getIconMapObject.mockRejectedValue(APEX_CONTACTS_ERROR);

        // Arrange
        const element = createElement('c-checklist-tabset', {
            is: ChecklistTabset
        });

        // Act
        document.body.appendChild(element);

        // Wait for any asynchronous DOM updates
        await flushPromises();

        // Assert
        expect(ShowToastEvent).toBeCalled;
    });
    
    it('populates variant attribute as per form factor', async () => {
        // Assign mock value
        getIconMapObject.mockResolvedValue(mockGetIconMapObject);

        // Arrange
        const element = createElement('c-checklist-tabset', {
            is: ChecklistTabset
        });

        // Act
        document.body.appendChild(element);

        // Wait for any asynchronous DOM updates
        await flushPromises();

        // Get the lightning-tab element
        const tabset = element.shadowRoot.querySelector('lightning-tabset');

        // Assert
        expect(tabset.variant).toBe('standard');
    });

});
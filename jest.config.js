const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');

module.exports = {
    ...jestConfig,
    moduleNameMapper: {
        '^@salesforce/client/formFactor$': '<rootDir>/force-app/test/jest-mocks/c/formFactor.json',
        '^c/packingArea1to7$': '<rootDir>/force-app/test/jest-mocks/c/packingArea1to7',
        '^c/containerCondition8to12$': '<rootDir>/force-app/test/jest-mocks/c/packingArea1to7',
        '^c/packingContainer13to19$': '<rootDir>/force-app/test/jest-mocks/c/packingArea1to7',
        '^c/dangerousGoods20to23$': '<rootDir>/force-app/test/jest-mocks/c/packingArea1to7',
        '^c/afterPacking24to27$': '<rootDir>/force-app/test/jest-mocks/c/packingArea1to7',
        '^c/closingContainer28to29$': '<rootDir>/force-app/test/jest-mocks/c/packingArea1to7',
        '^c/dispatchingContainer30to34$': '<rootDir>/force-app/test/jest-mocks/c/packingArea1to7',
    },
    modulePathIgnorePatterns: ['<rootDir>/.localdevserver']
};

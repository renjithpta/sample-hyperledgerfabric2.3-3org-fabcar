'use strict';

import {Chaincode, StubHelper} from '@theledger/fabric-chaincode-utils';
import {CertificateHelper} from './certificateHelper';
import {FlightChainLogic} from './flightChainLogic';
import {AcrisFlight} from './acris-schema/AcrisFlight';
import {ChaincodeInterface} from 'fabric-shim';
import {IFlightChainData} from './IFlightChainData';
import deepmerge = require('deepmerge');

// import child_process = require('child_process');
// export const GIT_VERSION = child_process
//     .execSync('git rev-parse --short HEAD')
//     .toString().trim();

export const PACKAGE_VERSION = process.env.npm_package_version;

console.log(`Starting up - package version = ${PACKAGE_VERSION}`);

export class FlightChain extends Chaincode {

    certificateHelper = new CertificateHelper();

    /**
     * Must be defined, even if it is a NOOP
     *
     * @param {StubHelper} stubHelper
     * @param {string[]} args
     * @returns {Promise<void>}
     */
    async initLedger(stubHelper: StubHelper, args: string[]) {
        console.log('============= START : initLedger ===========');
        // GOTCHA - don't return anything from this initLedger method, or the chain
        // code cannot be instantiated.
    }

    /**
     * Return the version of this chaincode (read from package.json & git commit).
     *
     * @param stubHelper
     * @param args
     * @returns {Promise<string>}
     */
    async getVersion(stubHelper: StubHelper, args: string[]): Promise<string> {
        console.log('============= START : version ===========');
        return new Promise<string>((resolve, reject) => {
            resolve(PACKAGE_VERSION);
        });

    }

    /**
     * Return a single flight, as identified by the flight key.
     *
     * @param stubHelper
     * @param args
     * @returns {Promise<any>}
     */
    async getFlight(stubHelper: StubHelper, args: string[]): Promise<IFlightChainData> {
        console.log('============= START : getFlight ===========');

        if (args.length !== 1) {
            throw new Error('Incorrect number of arguments. Expecting FlightKey ex: 2018-07-22LHRBA0227');
        }
        const flightKey = args[0];
        const data = <IFlightChainData> await stubHelper.getStateAsObject(flightKey);
        if (!data) {
            console.log(`getFlight - cant find any data for ${flightKey}`);
        }
        return data;
    }

    /**
     * Return the history of updates for a single flight, as identified by the flight key.
     *
     * @param stubHelper
     * @param args
     * @returns {Promise<void>}
     */
    async getFlightHistory(stubHelper: StubHelper, args: string[]): Promise<any> {
        console.log('============= START : getFlightHistory ===========');

        if (args.length < 1) {
            throw new Error('Incorrect number of arguments. Expecting FlightKey ex: 2018-07-22LHRBA0227');
        }
        const flightKey = args[0];
        console.log('- start getFlightHistory: %s\n', flightKey);
        return await stubHelper.getHistoryForKeyAsList(flightKey);
    }
    
    
    async getOperatingAirlineDataByIataCode(stubHelper: StubHelper, args: string[]): Promise<any> {

        return await stubHelper.getQueryResultAsList({
            selector: {
                 "docType":"flight",
                  "flightData.operatingAirline.iataCode": args[0]
            }
        });

    }
    
     async getAllDataCode(stubHelper: StubHelper, args: string[]): Promise<any> {

        return await stubHelper.getQueryResultAsList({
            selector: {"docType":"flight"}
        });

    }
    
    
     async getResultByQuery(stubHelper: StubHelper, args: string[]): Promise<any> {
        return await stubHelper.getQueryResultAsList(args);

    }

    /**
     * Create a new flight on the network.
     *
     * @param stubHelper
     * @param args
     * @returns {Promise<void>}
     */
    async createFlight(stubHelper: StubHelper, args: string[]): Promise<any> {
        console.log('============= START : Create Flight ===========');
        // console.log('stub.getCreator', stubHelper.getClientIdentity());

        const iataCode = CertificateHelper.getIataCode(stubHelper.getClientIdentity());

        if (args.length !== 1) {
            throw new Error('Incorrect number of arguments. Expecting one argument containing ACRIS flight data.');
        }
        console.log(args[0]);
        const flight: any = JSON.parse(args[0]);

        if (!flight) {
            const msg = `No ACRIS flightdata passed in as arg[0] '${args[0]}'`;
            console.error(msg);
            throw new Error(msg);
        }

        FlightChainLogic.verifyValidACRIS(flight);
        FlightChainLogic.verifyAbleToCreateOrModifyFlight(iataCode, flight);

        const flightKey = FlightChainLogic.generateUniqueKey(flight);
        const existingFlight = await stubHelper.getStateAsObject(flightKey);
        if (existingFlight) {
            const msg = `A flight with this flight key '${flightKey}' already exists, this data will be merged.`;
            console.warn(msg);
            // throw new Error(msg);
            let flightData = args[0];
            args[0] = flightKey;
            args[1] = flightData;
            await this.updateFlight(stubHelper, args);
        } else {

            let flightToStore: IFlightChainData = <IFlightChainData> {};
            flightToStore.flightData = flight;
            flightToStore.flightKey = flightKey;

            flightToStore.docType = 'flight';

            // TODO: Is this best place to add these values ? The history doesn't seem to easily allow way to determine who updates.
            flightToStore.updaterId = iataCode;
            flightToStore.txId = stubHelper.getStub().getTxID();

            await stubHelper.putState(flightKey, flightToStore);
        }
        console.log('============= END : Create Flight ===========');
    }

    /**
     * Update an existing flight on the network.
     *
     * @param stubHelper
     * @param args
     * @returns {Promise<void>}
     */
    async updateFlight(stubHelper: StubHelper, args: string[]): Promise<any> {
        console.log(`============= START : updateFlight key ${args[0]} ===========`);
        if (args.length !== 2) {
            throw new Error('Incorrect number of arguments. Expecting 2 (flightKey & new ACRIS flight data)');
        }
        const iataCode = CertificateHelper.getIataCode(stubHelper.getClientIdentity());

        const flightKey = args[0];
        const flightDelta = JSON.parse(args[1]);

        // TODO: Verify that the flight already exists & return appropriate error 404 message if it does not exist
        const existingFlight = <IFlightChainData> await stubHelper.getStateAsObject(flightKey);
        console.log('existingFlight', existingFlight);
        if (!existingFlight) {
            const msg = `A flight with this flight key '${flightKey}' does not yet exist. It must be created first`;
            console.error(msg);
            throw new Error(msg);
        }

        FlightChainLogic.verifyAbleToCreateOrModifyFlight(iataCode, existingFlight.flightData);

        const mergedFlight: AcrisFlight = deepmerge(existingFlight.flightData, flightDelta);
        console.log('flightDelta', flightDelta);
        console.log('existingFlight', existingFlight.flightData);
        console.log('mergedFlight', mergedFlight);

        FlightChainLogic.verifyValidACRIS(mergedFlight);

        const mergedFlightKey = FlightChainLogic.generateUniqueKey(mergedFlight);
        if (mergedFlightKey !== flightKey) {
            const msg = `You cannot change data that will modify the flight key ` +
                        `(originDate, departureAirport, operatingAirline.iataCode or flightNumber.trackNumber)`;
            console.error(msg);
            throw new Error(msg);
        }

        // TODO: Is this best place to add these values ? The history doesn't seem to easily allow way to determine who updates.
        existingFlight.updaterId = iataCode;
        existingFlight.txId = stubHelper.getStub().getTxID();
        existingFlight.flightData = mergedFlight;
        await stubHelper.putState(flightKey, existingFlight);
        console.log('============= END : updateFlight ===========');
    }

}

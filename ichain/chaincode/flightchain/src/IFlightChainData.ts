
import {AcrisFlight} from './acris-schema/AcrisFlight';

/**
 * This is the data model stored on the blockchain.
 * Each ACRIS flight entry/update is stored with the transaction Id and
 * updater Id so it can conveniently be accessed by the client apps.
 */
export interface IFlightChainData {
    flightData: AcrisFlight;
    flightKey: string;
    // Which IATA entity updated the data.
    updaterId: string;
    txId: string;
    // TODO: Check if this docType needs to be set for couchDB. It is in the fabric-samples
    docType: string;
}

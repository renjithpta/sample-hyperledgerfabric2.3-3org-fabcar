import shim = require('fabric-shim');
import { FlightChain } from './flightChain';

// @ts-ignore
shim.start(new FlightChain());

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var shim = require("fabric-shim");
var flightChain_1 = require("./flightChain");
// @ts-ignore
shim.start(new flightChain_1.FlightChain());

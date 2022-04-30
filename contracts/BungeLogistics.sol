// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "hardhat/console.sol";

contract BungeLogistics {

    event ProductCheck(address indexed from, uint256 timestamp, string message);

    struct Product {
        uint256 id;
        string name;
        string pType;
        uint256 pes;
        uint256 weight;
        bool eco;
    }

    struct Location {
        uint256 id;
        string name;
        string lType;
        string lAddress;
        string city;
        string state;
        string zip;
        string country;
        string phone;
        string email;
        string website;
        address owner;
    }

    struct Route {
        Location location;
        uint256 receivedTimestamp;
    }

    struct LogisticLine {
        uint256 id;
        Product product;
        Location origin;
        Location destination;
        Route[] route;
        uint256 routeCount;
        uint256 creationTimestamp;
        uint256 lastUpdateTimestamp;
        uint256 completedTimestamp;
    }

    string[] pTypes;

    Product[] products;
    uint256 productsCount;

    Location[] locations;
    uint256 locationsCount;

    LogisticLine[] logisticLines;
    uint256 logisticLinesCount;

    Route[] routes;
    

    uint256 routesCount;

    mapping (string => uint256) LocationNameIndex;

    mapping (string => uint256) ProductNameIndex;

    mapping (uint256 => uint256) LogisticLineIDIndex;

    constructor() {
        console.log("We have been constructed!");
    }

    function addRoute () public {
        Route memory route = Route(locations[0],block.timestamp);
        routes.push(route);
        
    }

    // Product functions

    function addProduct (string memory name, string memory pType, uint256 pes, uint256 weight, bool eco) public {
        products.push(Product(productsCount, name, pType, pes, weight, eco));
        productsCount++;
        ProductNameIndex[name] = productsCount-1;
    }

    function deleteProduct (string memory name) public {
        delete products[ProductNameIndex[name]];
        delete ProductNameIndex[name];
        productsCount--;
    }
    
    function getProductType(string memory name) public view returns (string memory) {
        return products[ProductNameIndex[name]].pType;
    }
    
    function getAllProductsNames () public view returns (string[] memory) {
        string[] memory names;
        for (uint256 i = 0; i < productsCount; i++) {
            names[i] = products[i].name;
        }
        return names;
    }

    function getAllProducts () public view returns (Product[] memory) {
        return products;
    }

    // Types functions

    function addType(string memory pType) public {
        pTypes.push(pType);
    }

    function deleteType (string memory pType) public {
        uint256 index = 0;
        for (uint256 i = 0; i < pTypes.length; i++) {
            if (keccak256(abi.encodePacked(pTypes[i])) == keccak256(abi.encodePacked(pType))) {
                index = i;
            }
        }
        delete pTypes[index];
    }

    function getTypes() public view returns (string[] memory) {
        return pTypes;
    }

    // Location functions

    function addLocation (string memory name, string memory lType, string memory lAddress, string memory city, string memory state, string memory zip, string memory country, string memory phone, string memory email, string memory website) public {
        locations.push(Location(locationsCount, name, lType, lAddress, city, state, zip, country, phone, email, website, msg.sender));
        LocationNameIndex[name] = locationsCount-1;
        locationsCount++;
    }

    function deleteLocation (string memory name) public {
        require(
            msg.sender == locations[LocationNameIndex[name]].owner,
            "You're not the location owner"
        );
        delete locations[LocationNameIndex[name]]; 
        delete LocationNameIndex[name];
        locationsCount--;
    }

    function getAllLocationsNames () public view returns (string[] memory) {
        string[] memory names;
        for (uint256 i = 0; i < locationsCount; i++) {
            names[i] = locations[i].name;
        }
        return names;
    }

    function getAllLocations () public view returns (Location[] memory) {
        return locations;
    }

    // LogisticLine functions

    function addLogisticLine (string memory name, uint256 productIndex, uint256 originIndex, uint256 destinationIndex) public {
        Route[] memory _routes = routes; 

        logisticLines.push(LogisticLine(logisticLinesCount, products[productIndex], locations[originIndex], locations[destinationIndex], _routes, 0, block.timestamp, 0, 0));
        LogisticLineIDIndex[logisticLinesCount] = logisticLinesCount;
        logisticLinesCount++;
    }

    function deleteLogisticLine (uint256 id) public {
        delete logisticLines[id];
        delete LogisticLineIDIndex[id];
        logisticLinesCount--;
    }

    function getLogisticLine (uint256 id) public view returns (LogisticLine memory) {
        return logisticLines[LogisticLineIDIndex[id]];
    }

    function getAllLogisticLines () public view returns (LogisticLine[] memory) {
        return logisticLines;
    }

}

pragma solidity ^0.8.0;

import "/contracts/StructuredLinkedList.sol";

contract MyContract {
    using StructuredLinkedList for StructuredLinkedList.List;

    StructuredLinkedList.List list;
    
    function createInitialNode(uint val) public returns (bool success) {
        list.pushFront(val);
        return true;
    }
    
    function createNodeWithVal(uint val) public returns (bool success) {
        list.insertBefore(list.getSortedSpot(val), val);
        return true;
    }
    
    function getNode(uint val) public view returns (bool, uint256, uint256) {
        return list.getNode(val);
    }
    
    function getSortedSpot(uint val) public view returns (uint256) {
        return list.getSortedSpot(val);
    }

    function doesExist() public view returns (uint cool) {
        if (list.listExists()){
            return 1;
        }
        return 2;
    }
    
}
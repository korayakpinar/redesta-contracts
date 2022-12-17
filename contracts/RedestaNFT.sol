// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RedestaNFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string public ipfsaddress;
    uint public maxSupply;
    string nname;
    string shortname;
    
    constructor(string memory _ipfsaddr, uint _maxSupply, string memory _name, string memory _shortname) ERC721(nname, shortname) {
        ipfsaddress = _ipfsaddr;
        maxSupply = _maxSupply;
        _name = nname;
        _shortname = shortname;
    }

    function getIPFSaddress() public view returns(string memory){
        return ipfsaddress;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
}
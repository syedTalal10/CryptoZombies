// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.0;
import "./Ownable.sol";

contract ZombieFactory is Ownable{

    // Events
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // Zombie Structure 
    struct Zombie{
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }

    // Array of zombies structs
    Zombie[] public zombies;
    uint cooldownTime = 1 days;

    // Which zombie belongs to which owner
    mapping (uint => address) public zombieToOwner;

    // Owner owns how many zombies
    mapping (address => uint) ownerZombieCount;

    // Private Function to create Zombie
    function _createZombie( string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime)));
        uint id = zombies.length -1;
        // specific id zombie belongs to msg.sender address
        zombieToOwner[id] = msg.sender;
        // Increase zombie owns count of specific address
        ownerZombieCount[msg.sender]++;
        // emit Event
        emit NewZombie(id, _name, _dna); 
    }

    // Private Function to generate random dna from given string for zombie
    function _generateRandomDna( string memory _str) private view returns(uint){
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // Public function to create zombie with name and their unique dna
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "You have already created your Zombie");
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity 0.8.8; // this means any version of Solidity thats 0.8.7 or newer will work

// pragma solidity >=0.8.7 <0.9.0 Use this to specify a range of versions
// Use double forward slash for comments

// use contract to tell soliidity that the next section of code defines a contract

contract SimpleStorage {
    //Basic types of solidity: boolean, uint, int, address, bytes

    //bool hasFavoriteNumber = True;
    uint256 favoriteNumber; // not assigning it a value automatically intializes it as 0
    //People public person = People({favoriteNumber: 2, name = 'Josh'}) One instance of a person

    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    uint256 public favoriteNumbersList;
    People[] public people;

    // 4 visibility identifiers- public, private, internal, external

    //string favoriteNumberInText = "Five";
    //int256 favoriteInt = -5;
    //bytes32 favoriteBytes = "Cat"; //Strings can work as bytes v

    function store(uint256 _favoriteNumber) public virtual {
        //virtual makes the functino overwritable in other contracts
        favoriteNumber = _favoriteNumber;
    }

    //view functions and pure functions don't modify the blockchain, so they don't cost any gas
    //however if a gas costing function calls a pure or view function it will cost gas
    //view function
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    //calldata, memory, storage
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
    //calldata- temporary data that can be overwritten
    //memory - temproray data that can't be overwritten
    //storage - permanent and can be overwritten
}

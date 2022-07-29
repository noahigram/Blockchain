//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// need interface to work with
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

//Get funds from users
//Withdraw funds
// Set a minimum funding value in USD

error FundMe__NotOwner();

/** @title A contract for crowd funding
 * @author Noah Igram
 * @notice This contract was made to demo a sample funding contract
 * @dev This implements price feeds as our library
 */
contract FundMe {
    // Type declarations
    using PriceConverter for uint256;

    // State variables
    mapping(address => uint256) public addressToAmountFunded;
    uint256 public constant MINIMUM_USD = 5 * 10**18;
    address[] public funders;
    address public immutable i_owner;
    AggregatorV3Interface public priceFeed;

    // Modifiers
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        } //uses less gas than require
        _; //this line runs tells the function to execute the original code of the function
    }

    // Functions in this order: constructor, receive, fallback, external, public, internal, private, view / pure

    // Constructor gets called immediately when the contract is deployed
    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress); // sets priceFeed to AggregatorV3interface corresponding to priceFeedAdress
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function fund() public payable {
        // Want to be able to set a minimum funding value
        // How do we send ETH to this contract? Contracts can hold tokens
        require(
            msg.value.getConversionRate(priceFeed) >= MINIMUM_USD,
            "Didn't send enough!"
        ); //requires the amount to be greater than 1e18 (measured in Wei)
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;

        // What is reverting?
        // Undoes any action before, and send remaining gas back
    }

    function withdraw() public onlyOwner {
        //for loop
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);

        //actually withdraw the funds

        //transfer- capped at 2300 gas, automatically reverts if gas is over limit
        // msg.sender is an address
        // payable(msg.sender) is a payable address
        payable(msg.sender).transfer(address(this).balance);

        //send- capped at 2300 gas, doesn't automaticaly revert
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }
}

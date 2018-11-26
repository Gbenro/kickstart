pragma solidity ^0.4.20;

/// @title Kickstart factory contract
/// @author Gbenro Adesoye
/// @notice A factory contract for the main Campaign contract
contract CampaignFactory {
    address[] public deployedCampaigns;

  
    /// @notice This function creates campaign by calling constructor of campaign
    /// @param minimum The minimun amount that can be donated to this campaign
    function createCampaign (uint minimum) public{
        address newCampaign = new Campaign (minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }


    /// @notice gets the addresses that are already deployed
    /// @return the array of addresses that is deployed by this contract
    function getDeployedCampaigns() public view returns (address[]){

        return deployedCampaigns;
    }


}


///@title Kickstart
///@author Gbenro Adesoye
///@notice A Dapp version for Kickstarter. Learnt through Ethereum course on Udemy
contract Campaign{
    struct Request{
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping (address => bool) approvals;// people that approves the Request
    }
    Request[] public requests;
    address public manager;
    uint public minContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;

    ///@notice to restict access to only address that is manager of campaign
    modifier restricted(){
        require( 
            msg.sender == manager,
            "Sender not authorized."
        );
        _;

    }

    ///@notice contructor to campaign contract
    ///@param minimum the minimum amount of ether that can be contributed to the campaign
    ///@param creator the address of the manager of the campaign
    constructor (uint minimum, address creator) public{
        manager = creator;
        minContribution = minimum;

    }

    ///@notice payable funtion, contribute ether to the campaign
    function contribute() public payable{
        // msg.value is the amount in wei
        require(
            msg.value > minContribution,
            "amount Less than minimum contribution"
            );

        approvers[msg.sender] = true;//adds a new key of the address and gives it a mapping of true
        approversCount++;
    }

    ///@notice creates request for money in the campaign, maybe manager needs to buy something need for project
    ///@dev should only be called by the manager
    ///@param description the purpose of the request
    ///@param value amount of ether requested for
    ///@param address the address of the recipient of the requested fund, should be third part ideally
    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest = Request ({
            description:description,
            value:value,
            recipient:recipient,
            complete: false,
            approvalCount: 0

        }) ;
     // Request(description,value,recipient, false); this is another way to initialize a struct
        requests.push(newRequest);
    }
    ///@notice approvers i.e people that has contributed to this campaign can should to approve request or not
    ///@dev request must point to the storage request
    ///@param index the index of request in the array of request for a campaign
    function approveRequest (uint index) public{
        Request storage request = requests[index];
        // checking if he/she is a contributor
        require(
            approvers[msg.sender],
            "Address not a contributor"
            );
            // if they havent voted on this before
        require(
            !request.approvals[msg.sender],
            "Address havent voted on this request yet"
            );

        request.approvals[msg.sender] = true;
        request.approvalCount++;

    }

    ///@notice finalize request if more than 50% of contributors approve request, restricted to only campaign manager
    ///@dev request must point to the storage request
    ///@param index the index of request in the array of request for a campaign
    function finalizeRequest(uint index) public restricted{
        Request storage request = requests[index];// must point to the request in the storage
        require(
            !request.complete,
            "Request is Already Finalized"
            );
        require(
            request.approvalCount > (approversCount/2),
            "Need more than 50% of approvers to Finalize Request"
            );

        request.recipient.transfer(request.value);
        request.complete = true;

    }
    ///@notice show all info about a campaign
    ///@return uint the minimum contribution for the campaign
    ///@return uint the balance of the campaign
    ///@return uint the numbers of requests in the campaign
    ///@return address campaign's manager address
    function getSummary() public view returns (
        uint, uint, uint, uint, address
      ){

        return (

            minContribution,
            address(this).balance,
            requests.length,
            approversCount,
            manager
        );
    }

    ///@notice gets the number of request made by manager to the campaign
    ///@return the amount of request for a campaign
    function getRequestsCount() public view returns (uint){

        return requests.length;
    }
}

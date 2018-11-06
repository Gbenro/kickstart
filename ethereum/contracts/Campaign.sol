pragma solidity ^0.4.20;


contract CampaignFactory {
    address [] public deployedCampaigns;

    function createCampaign (uint minimum) public{
      address newCampaign =   new Campaign (minimum, msg.sender);
      deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[]){

        return deployedCampaigns;
    }


}



contract Campaign{
    struct Request{
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping (address => bool) approvals;// people that approves the Request
    }

      address public manager;
      uint public minContribution;
      mapping(address => bool) public approvers;
      Request[] public requests;
      uint public approversCount;


       modifier restricted(){
        require(msg.sender == manager);
        _;

    }

    constructor (uint minimum, address creator) public{
       manager = creator;
       minContribution= minimum;

    }

    function contribute() public payable{
        require(msg.value > minContribution);// msg.value is the amount in wei
       approvers[msg.sender]= true;//adds a new key of the address and gives ita mapping of true
        approversCount++;
    }


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

    function approveRequest (uint index) public{
    Request storage request = requests[index];
        require(approvers[msg.sender]);// checking if he is a contributor
        require(!request.approvals[msg.sender]);// if they havent voted on this before

        request.approvals[msg.sender]= true;
        request.approvalCount++;

    }
    function finalizeRequest(uint index) public restricted{
         Request storage request = requests[index];
        require(!request.complete);
        require(request.approvalCount > (approversCount/2));

        request.recipient.transfer(request.value);
        request.complete = true;

    }

    function getSummary() public view returns (
      uint, uint, uint, uint, address
      ){

        return (

          minContribution,
          this.balance,
          requests.length,
          approversCount,
          manager
          );
    }


    function getRequestsCount() public view returns (uint){

        return requests.length;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract VotingSystem {

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool hasVoted;
        uint candidateId;
        bool isRegistered;
    }

    address public owner;
    uint public candidateCount;
    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
    }

    function registerVoter(address _voter) public onlyOwner {
        require(!voters[_voter].isRegistered, "Voter is already registered");
        voters[_voter] = Voter(false, 0, true);
    }

    function vote(uint _candidateId) public {
        require(voters[msg.sender].isRegistered, "Voter is not registered");
        require(!voters[msg.sender].hasVoted, "Voter has already voted");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].candidateId = _candidateId;

        candidates[_candidateId].voteCount++;
    }

    function getCandidate(uint _candidateId) public view returns (string memory name, uint voteCount) {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.name, candidate.voteCount);
    }
}

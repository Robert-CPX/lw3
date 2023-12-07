// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    address public chairPerson;
    
    mapping(address => Voter) public voters;
    
    Proposal[] public proposals;

    constructor(bytes32[] memory proposalNames) {
        chairPerson = msg.sender;
        voters[chairPerson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // function giveRightToVote(address voter) external {
    //     require(
    //         msg.sender == chairPerson
    //     );
    //     require(!voters[voter].voted);
    //     require(voters[voter].weight == 0);
    //     voters[voter].weight = 1;
    // }

    function giveRightToVote(address[] calldata newVoters) external {
        require(
            msg.sender == chairPerson,
            "Only chairperson can give right to vote."
        );
        for (uint256 i = 0; i < newVoters.length; i++) {
            require(
                !voters[newVoters[i]].voted,
                "The voter already voted"
            );
            require(voters[newVoters[i]].weight == 0);
            voters[newVoters[i]].weight = 1;
        }
    }

    function delegate(address to) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote");
        require(!sender.voted, "You have already voted");

        require(to != msg.sender, "Self-delegation is disallowed");

        while(voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Found loop in delegation.");
        }

        Voter storage delegate_ = voters[to];

        require(delegate_.weight >= 1);

        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    // function winningProposal() public view returns (uint winningProposal_) {
    //     uint winningVoteCount = 0;
    //     for (uint p = 0; p < proposals.length; p++) {
    //         if (proposals[p].voteCount > winningVoteCount) {
    //             winningVoteCount = proposals[p].voteCount;
    //             winningProposal_ = p;
    //         }
    //     }
    // }

    function winningProposals() public view returns (uint[] memory) {
        uint length = 0;
        uint winningVoteCount = 0;
        uint[] memory winningProposals_ = new uint[](proposals.length);

        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                length = 0;
                winningProposals_ = new uint[](proposals.length);
            }
            if (proposals[p].voteCount >= winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposals_[length] = p;
                length++;
            }
        }

        uint[] memory trimmedResult_ = new uint[](length);
        for (uint j = 0; j < trimmedResult_.length; j++) {
            trimmedResult_[j] = winningProposals_[j];
        }
        return trimmedResult_;
    }

    // function winnerName() external view returns (bytes32 winnerName_) {
    //     winnerName_ = proposals[winningProposal()].name;
    // }

    function winnerNames() external view returns (bytes32[] memory) {
        uint[] memory winningProposals_ = winningProposals();
        bytes32[] memory winnerNames_ = new bytes32[](winningProposals_.length);

        for (uint256 i = 0; i < winningProposals_.length; i++) {
            winnerNames_[i] = proposals[winningProposals_[i]].name;   
        }
        return winnerNames_;
    }
}
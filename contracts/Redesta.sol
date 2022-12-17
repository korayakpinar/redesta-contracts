// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./RedestaToken.sol";
import "./RedestaNFT.sol";

contract Redesta  {
    
    RedestaToken public immutable ourToken;
    RedestaNFT public redestanft;

    uint cutPercentage = 5;
    uint projectID = 0;
    uint decimalss = 10**18;
    uint rewardPool = 0;
    uint allVotes = 0;

    mapping(uint => Comments[]) idToComments;
    mapping(address => uint) commentCount;
    Projects[] public allProjects;
    mapping(address => Profile) profiles;
    mapping(address => mapping(uint => bool)) addrOwnedNFTbool;
    mapping(uint => Projects[]) categoryToProjects;
    
    constructor(address tokenAddress) {
        ourToken = RedestaToken(tokenAddress);
    }

    struct Profile {
        string username;
        uint donateAmount;
        uint[] supporting;
        Projects[] projects;
        uint nftCount;
    }

    struct ProjectStatus {
        uint current;
        uint goal;
        bool isDone;
    }

    struct Attributes{
        string roadmapImgAddr;
        string projectImgAddr;
        string mainDescription;
    }
    
    struct NFTinfo{
        uint nftThreshold;
        uint maxSupply;
        uint owned;
    }

    struct VoteInfo{
        uint voteCount;
        uint supporters;
    }

    struct Requestss{
        string bodyText;
        uint amount;
        uint upvote;
        uint downvote;
        uint rvoteCount;
        bool isActive;
        uint endtimestamp;
    }
    
    struct Projects {
        address projectOwner;
        address contractAddr;
        string title;
        Attributes attributes;
        uint id;
        uint commentCount;
        uint[] category;
        NFTinfo nftinfo;
        uint timestamp;
        uint supporters;
        ProjectStatus status;
        VoteInfo voteinfo;
        Requestss requestInfo;
    }

     struct Comments {
        uint projectID;
        address author;
        string comment;
        uint likeCount;
        uint dislikeCount;
        uint index;
    }

    function deployProject(
        string memory _roadmapImgAddr,
        string memory _projectImgAddr,
        string memory _title,
        string memory _mainDescription,
        uint[] memory _category,
        uint _nftThreshold,
        uint _maxSupply,
        uint _goal,
        string memory _NFTimageAddr,
        string memory _shortname
    ) public {

        RedestaNFT newNFTcontract = new RedestaNFT(_NFTimageAddr, _maxSupply, _title, _shortname);

        Projects memory tempProject = Projects(
                msg.sender,
                address(newNFTcontract),
                _title,
                Attributes(_roadmapImgAddr,
                _projectImgAddr,
                _mainDescription),
                projectID,
                0,
                _category,
                NFTinfo(_nftThreshold, _maxSupply, 0),
                block.timestamp,
                0,
                ProjectStatus(0, _goal, false),
                VoteInfo(0,0),
                Requestss("", 0, 0, 0, 0, false, 0)
        );

        allProjects.push(tempProject);
        for(uint i = 0; i<_category.length; i++){
            categoryToProjects[_category[i]].push(tempProject);
        }

        profiles[msg.sender].projects.push(tempProject);
        projectID++;
    }

    function addComment(string memory _comment, uint _id) public {
        uint index = idToComments[_id].length;
        idToComments[_id].push(Comments(_id, msg.sender, _comment, 0, 0, index));
        allProjects[_id].commentCount++;
    }

    function getComments(uint _id) public view returns(Comments[] memory){
        return idToComments[_id];
    }

    function getProject(uint _id) public view returns(Projects memory){
        return allProjects[_id];
    }

    function getFeed() public view returns(Projects[] memory){
        return allProjects;
    }

    function likeComment(uint _projectID, uint _comIndex, bool _LD) public {
        if(_LD) {
            idToComments[_projectID][_comIndex].likeCount++;
        } else {
            idToComments[_projectID][_comIndex].likeCount++;
        }
    }

    function donateProject(uint _projectID, uint amount) public {
        require(ourToken.balanceOf(msg.sender) >= amount * decimalss);
        ourToken.approve(msg.sender, amount * decimalss);
        ourToken.transferFrom(msg.sender, address(this), amount * decimalss);

        allProjects[_projectID].status.current += amount * decimalss * (100-cutPercentage) / 100;

        profiles[msg.sender].donateAmount += amount * decimalss;
        profiles[msg.sender].supporting.push(_projectID);
        rewardPool += amount * decimalss * cutPercentage / 100;
        allProjects[_projectID].supporters++;
        
        if(amount >= allProjects[_projectID].nftinfo.nftThreshold && allProjects[_projectID].nftinfo.owned < allProjects[_projectID].nftinfo.maxSupply && addrOwnedNFTbool[msg.sender][_projectID] == false){
            RedestaNFT(allProjects[_projectID].contractAddr).safeMint(msg.sender);
            allProjects[_projectID].nftinfo.owned++;
            profiles[msg.sender].nftCount++;
            addrOwnedNFTbool[msg.sender][_projectID] = true;
        } else {
            revert("");
        }
    }

    function getProjectsByCategory(uint _category) public view returns(Projects[] memory){
        return categoryToProjects[_category];
    }

    function getProfileInfo(address _address) public view returns(Profile memory){
        return profiles[_address];
    }

    function changeUsername(string memory _username) public {
        profiles[msg.sender].username = _username;
    }

    function getCategories(uint _id) public view returns(uint[] memory){
        return allProjects[_id].category;
    }

    function vote(uint _id) public {
        if(addrOwnedNFTbool[msg.sender][_id] == true){
            revert("");
        } else if (profiles[msg.sender].nftCount <= 0){
            revert("");
        } else {
            allProjects[_id].voteinfo.voteCount++;
            allProjects[_id].voteinfo.supporters++;
            allVotes++;
            profiles[msg.sender].nftCount = 0;
            addrOwnedNFTbool[msg.sender][_id] = true;
        }
    }

    function getVoteInfo(uint _id) public view returns(VoteInfo memory){
        return allProjects[_id].voteinfo;
    }

    function calculatePayback(uint _id) public view returns(uint){
        return rewardPool/allVotes*allProjects[_id].voteinfo.voteCount/allProjects[_id].nftinfo.owned;
    }

    function createRequest(string memory _bodyText, uint _amount, uint _id) public {
        require(allProjects[_id].projectOwner == msg.sender, "");
        if(allProjects[_id].requestInfo.isActive == true){
            revert("");
        } else {
            allProjects[_id].requestInfo.isActive = true;
            allProjects[_id].requestInfo.bodyText = _bodyText;
            allProjects[_id].requestInfo.amount = _amount;
            allProjects[_id].requestInfo.endtimestamp = block.timestamp + 1814400;
            allProjects[_id].requestInfo.isActive = true;
        }
    }

    function voteRequest(uint _id, uint _vote) public { // 0 -> evet, 1 -> hayır
        require(allProjects[_id].requestInfo.isActive, "");
        if(addrOwnedNFTbool[msg.sender][_id] == true){
            if(_vote == 0){
            allProjects[_id].requestInfo.upvote++;
            allProjects[_id].requestInfo.rvoteCount++;
        }} else if (_vote == 1) {
            allProjects[_id].requestInfo.downvote++;
            allProjects[_id].requestInfo.rvoteCount++;
        }
    }

    function withdrawRequest(uint _id) public returns(uint) {
        require(allProjects[_id].projectOwner == msg.sender, "");
        if(block.timestamp < allProjects[_id].requestInfo.endtimestamp){
            return((allProjects[_id].requestInfo.endtimestamp-block.timestamp)/60);
        } else if (allProjects[_id].requestInfo.upvote > allProjects[_id].requestInfo.downvote){
            ourToken.transfer(allProjects[_id].projectOwner, allProjects[_id].requestInfo.amount * decimalss);
            allProjects[_id].requestInfo = Requestss("",0,0,0,0,false,0);
        }
        return 0;
    }

    function getReward(uint _id) public {
        ourToken.transfer(msg.sender, calculatePayback(_id));
        rewardPool -= calculatePayback(_id);
        allProjects[_id].voteinfo.voteCount--;
        profiles[msg.sender].nftCount = 1;
        addrOwnedNFTbool[msg.sender][_id] = false;
    }
}
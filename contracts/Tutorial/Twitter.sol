// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IProfile {
    struct UserProfile {
        string displayName;
        string bio;
    }

    function getProfile(address _user) external view returns (UserProfile memory);
}

contract Twitter is Ownable {

    uint16 public MAX_TWEET_LENGTH = 280;
    IProfile profileContract;

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping (address => Tweet[]) public tweets;

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);
    event TweetUnLiked(address unLiker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);

    modifier onlyRegistered() {
        IProfile.UserProfile memory user = profileContract.getProfile(msg.sender);
        require(bytes(user.displayName).length > 0, "User is not registered");
        _;
    }

    constructor(address _profileContract) Ownable(msg.sender) {
        profileContract = IProfile(_profileContract);
    }   

    function createTweet(string memory _tweet) public onlyRegistered {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Too long tweet");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function getTweet(uint256 _i) public view returns (Tweet memory){
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory){
        return tweets[_owner];
    }

    function changeTweetLength(uint16 _newTwwetLength) public onlyOwner {
        MAX_TWEET_LENGTH = _newTwwetLength;
    }

    function likeTweet(uint256 _tweetId, address _author) external onlyRegistered {
        require(tweets[_author][_tweetId].id == _tweetId, "Tweet does not exists");
        tweets[_author][_tweetId].likes++;

        emit TweetLiked(msg.sender, _author, _tweetId, tweets[_author][_tweetId].likes);
    }

    function unLikeTweet(uint256 _tweetId, address _author) external onlyRegistered {
        require(tweets[_author][_tweetId].id == _tweetId, "Tweet does not exists");
        require(tweets[_author][_tweetId].likes > 0, "This tweet don't have likes");
        tweets[_author][_tweetId].likes--;

        emit TweetUnLiked(msg.sender, _author, _tweetId, tweets[_author][_tweetId].likes);
    }

    function getTotalLikes(address _author) external view returns (uint256) {
        Tweet[] memory allUserTweets = tweets[_author];
        uint256 likesCounter;
        for (uint256 i; i < allUserTweets.length; i++) {
            likesCounter += allUserTweets[i].likes;
        }
        return likesCounter;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address owner) external view returns (uint balance);

    function ownerOf(uint tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function approve(address spender, uint tokenId) external returns (bool success);

    function getApproved(uint tokenId) external view returns (address operator);

    function setApprovalForAll(address spender, bool approved) external;

    function isApprovedForAll(address owner, address operator)
        external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 is IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(address indexed owner, address indexed approved, uint indexed id);
    event ApprovalForAll(
        address indexed owner,
        address indexed oprator,
        bool approved
    );

    // nft id to user
    mapping(uint => address) internal _ownerOf;
    // user to nft's count
    mapping(address => uint) internal _balanceOf;
    // transfer the id to another user
    mapping(uint => address) internal _approvals;
    // user can give permission to another user to use his nft
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function balanceOf(address owner) external view returns (uint balance) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balanceOf[owner];
    }

    function ownerOf(uint tokenId) external view returns (address owner) {
        owner = _ownerOf[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent");
    }

    function setApprovalForAll(address spender, bool approved) external {
        isApprovedForAll[msg.sender][spender] = approved;
        emit ApprovalForAll(msg.sender, spender, approved);
    }

    function approve(address spender, uint tokenId) external returns (bool success) {
        address owner = _ownerOf[tokenId];
        require(
            msg.sender == owner || isApprovedForAll[owner][msg.sender],
            "not authrorized"
        );

        _approvals[tokenId] = spender;

        emit Approval(owner, spender, tokenId);
    }

    function getApproved(uint tokenId) external view returns (address operator) {
        require(_ownerOf[tokenId] != address(0), "token does not exist");
        return _approvals[tokenId];
    }

    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint tokenId
    ) internal view returns (bool) {
        return (
            spender == owner ||
            isApprovedForAll[owner][spender] ||
            spender == _approvals[tokenId]
        );
    }

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) public {
        require(from == _ownerOf[tokenId], "not authorized");
        require(to != address(0), "to = zero address");
        require(_isApprovedOrOwner(from, msg.sender, tokenId), "not authorized");

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[tokenId] = to;
        _approvals[tokenId] = from;

        delete _approvals[tokenId];

        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from, 
        address to, 
        uint tokenId
    ) external  {
        transferFrom(from, to, tokenId);

        require(
            to.code.length == 0 || 
                IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, "") == 
                IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external {
        transferFrom(from, to, tokenId);

        require(
            to.code.length == 0 || 
                IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) == 
                IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    function _min(address to, uint tokenId) internal {
        require(to != address(0), "to = zero address");
        require(_ownerOf[tokenId] == address(0), "token exists");

        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint tokenId) internal {
        address owner = _ownerOf[tokenId];
        require(owner != address(0), "token does not exist");

        _balanceOf[owner]--;
        delete _approvals[tokenId];
        delete _ownerOf[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }
}

contract MyNFT is ERC721 {
    function mint(address to, uint tokenId) external {
        _min(to, tokenId);
    }

    function burn(uint tokenId) external {
        require(msg.sender == _ownerOf[tokenId], "not owner");
        _burn(tokenId);
    }
}
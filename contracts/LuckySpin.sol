//SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./abstracts/LuckyGame.sol";
import "./interfaces/ILuckyTreasury.sol";

contract LuckySpin is LuckyGame, VRFConsumerBase {
    using SafeERC20 for IERC20;

    event RegisterSegment(Risk risk, uint16 segment);
    event UnregisterSegment(Risk risk, uint16 segment);
    event RequestPlay(
        address indexed player,
        address indexed token,
        bytes32 indexed requestId,
        uint256 amount
    );
    event FullfillPlay(
        address indexed player,
        address indexed token,
        bytes32 indexed requestId,
        uint256 playAmount,
        uint256 resultAmount
    );

    enum Risk {
        Low,
        Medium,
        High
    }

    struct PlayInfo {
        address player;
        address token;
        uint64 playTime;
        uint256 amount;
        Risk risk;
        uint16 segment;
    }

    uint32 constant DECIMALS = 1e6;

    uint256 public linkFee;
    bytes32 public keyHash;

    mapping(Risk => mapping(uint16 => mapping(uint16 => uint32)))
        public segmentsInfo;
    mapping(Risk => mapping(uint16 => bool)) public segmentExist;

    mapping(bytes32 => PlayInfo) public playInfos;

    modifier onlyRegisteredSegment(Risk risk, uint16 segment) {
        require(segmentExist[risk][segment], "not registered!");
        _;
    }

    constructor(
        address treasury_,
        address vrfCoordinator_,
        address link_,
        uint256 linkFee_,
        bytes32 keyHash_
    ) LuckyGame(treasury_) VRFConsumerBase(vrfCoordinator_, link_) {
        linkFee = linkFee_;
        keyHash = keyHash_;
    }

    function registerSegment(Risk risk, uint16 segment) external onlyOwner {
        require(!segmentExist[risk][segment], "registered!");
        segmentExist[risk][segment] = true;

        emit RegisterSegment(risk, segment);
    }

    function unregisterSegment(Risk risk, uint16 segment) external onlyOwner {
        require(segmentExist[risk][segment], "not registered!");
        segmentExist[risk][segment] = false;

        emit UnregisterSegment(risk, segment);
    }

    function setSegments(
        Risk risk,
        uint16 segment,
        uint16[] calldata indexes,
        uint32[] calldata rates
    ) external onlyRegisteredSegment(risk, segment) onlyOwner {
        require(
            indexes.length > 0 &&
                indexes.length <= segment &&
                indexes.length == rates.length,
            "invalid length"
        );
        uint256 length = indexes.length;
        for (uint256 i = 0; i < length; i += 1) {
            segmentsInfo[risk][segment][indexes[i]] = rates[i];
        }
    }

    function play(
        address token,
        uint256 amount,
        Risk risk,
        uint16 segment
    )
        external
        onlyRegisteredSegment(risk, segment)
        onlyWhitelistedToken(token)
    {
        IERC20(token).safeTransferFrom(_msgSender(), treasury, amount);
        bytes32 requestId = requestRandomness(keyHash, linkFee);

        require(playInfos[requestId].amount == 0, "already requested!");

        playInfos[requestId] = PlayInfo({
            player: _msgSender(),
            token: token,
            playTime: uint64(block.timestamp),
            amount: amount,
            risk: risk,
            segment: segment
        });

        emit RequestPlay(_msgSender(), token, requestId, amount);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        PlayInfo storage playInfo = playInfos[requestId];
        require(playInfo.amount > 0, "no request!");

        uint16 selectedSegment = uint16(randomness % playInfo.segment);
        uint32 rate = segmentsInfo[playInfo.risk][playInfo.segment][
            selectedSegment
        ];
        if (rate > 0) {
            uint256 resultAmount = (playInfo.amount * rate) / DECIMALS;
            ILuckyTreasury(treasury).transferToken(
                playInfo.token,
                resultAmount,
                playInfo.player
            );
            emit FullfillPlay(
                playInfo.player,
                playInfo.token,
                requestId,
                playInfo.amount,
                resultAmount
            );
        } else {
            emit FullfillPlay(
                playInfo.player,
                playInfo.token,
                requestId,
                playInfo.amount,
                0
            );
        }
    }
}

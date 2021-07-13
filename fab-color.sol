// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract ColorAuction {

    // bids
    //    {...bids}
    //     {address: ‘0x...’,
    //        note: str
    //        color: ‘d01ec6ff’,
    //        bid_size: 24
    //        }

    // influence
    //      Influence: 
    // { address: 
    //  influence_score: (0->1)
    // }
    event fabulousColorChanged(Color color);

    struct Color {
        bytes3 webhex;
        uint amount;
    }
    
    // The color that is currently "winning" with the highest cumulative bid value
    Color public fabulousColor;
    // uint public fabulousBid; // is now an attribute of fabColor

    struct User{
        bytes3 latestColorWebhex;        
        uint amount;
        uint influence;
    }
    // Allowed withdrawals of previous bids
    mapping(address => User) users;
    mapping(bytes3 => Color) colorScoreboard;

    //Implementing the order object
    mapping(bytes3 => bytes3) betterColors; //here, each color points to the color better than it.
    mapping(bytes3 => bytes3) worseColors; //here, each color points to the color worse than it.

    function getBetterColor(Color memory color) public {
        return colorScoreboard[betterColors[color.webhex]];
    }

    function getWorseColor(Color memory color) public {
        return colorScoreboard[worseColors[color.webhex]];
    }

    function insertColor(Color memory color, Color memory worseColor, Color memory betterColor) public { //insert the color between the worseColor and betterColor
      // mutate the mapping to reorder the list
      // if the better color was the fab color, this is now the fab color
    }

    // Recursively updates the color orders and determines if there is a new fabulousColor
    function cascadeUp(Color memory changedColor, Color memory comparisonColor) public { // the starting color should initially be the color better than the changedColor
            
        // if the changedColorWebhex is now more valuable than the betterColor, it needs to swap with changedColorWebhex
        if (changedColor.amount > comparisonColor.amount) {
            // if the better colour's better colour is greater than the change color amount
            if (getBetterColor(comparisonColor).amount < changedColor.amount) {
                insertColor(changedColor, comparisonColor, getBetterColor(comparisonColor));
                return;
            }
            cascadeUp(changedColor, getBetterColor(comparisonColor));
        }
    }
    
    function cascadeDown(Color memory changedColor, Color memory comparisonColor) public { 
        if (changedColor.amount < comparisonColor.amount) {
            // if the better colour's better colour is greater than the change color amount
            if (getBetterColor(comparisonColor).amount > changedColor.amount) {
                insertColor(changedColor, getWorseColor(comparisonColor), comparisonColor);
                return;
            }
            cascadeDown(changedColor, getWorseColor(comparisonColor));
        }
    }


    function update_color(bytes3 webhex) public payable {
    
        Color memory currentColor = colorScoreboard[webhex];
        //If the color doesn't exist, initialize it
        if (currentColor.webhex == 0) {
            colorScoreboard[webhex] = Color(,,,); //TODO fix this
        }
    
        // if the user did not already vote
        if (users[msg.sender].latestColorWebhex == 0) {
                // add their bid to that color
                //and register the new user.
                // Add the bid amount to this color, (array is init as 0)
                users[msg.sender].amount += msg.value;
                users[msg.sender].latestColorWebhex = webhex;
                colorScoreboard[webhex].amount += msg.value;
                cascade(webhex);

        // case 2: User already voted, update their vote and move any existing bid to their newly selected color (or add to existing color)
        } else {
            // remove the existing bid based on the user's existing color
            colorScoreboard[users[msg.sender].latestColorWebhex].amount -= users[msg.sender].amount;
            cascade(users[msg.sender].latestColorWebhex);

            // update the user's color, add any amount from this message to their user.
            users[msg.sender].latestColorWebhex = webhex;
            users[msg.sender].amount += msg.value;

            //add to the colorScoreboard
            colorScoreboard[webhex].amount += users[msg.sender].amount;
            cascade(webhex);
        }
        // to test, set fabulousColor to the webhex
        fabulousColor = Color(webhex, 0,0,100);
    }

    // general helper functions (should be interfaces?)
    /// Get the current Fabulous color webhex.
    //function get_fab_color() public {
    //    return fabulousColor;
    //}

    /// Get the full scoreboard/list of colors with bids
    //function get_color_ranking(bytes3 webhex, uint check) public {
    //    if (colorScoreboard[webhex] != 0) {
    //        if (colorScoreboard[webhex] == fabulousColor) {
    //            return 1;
    //        } 
    //    } 
    //    return 0;
    //    
    //}


    

    //mapping(address => uint) pendingReturns;
    
    // Set to true at the end, disallows any change.
    // By default initialized to `false`.
    //bool ended;

    // Events that will be emitted on changes.
    event AuctionEnded(address winner, uint amount);

    // Errors that describe failures.

    // The triple-slash comments are so-called natspec
    // comments. They will be shown when the user
    // is asked to confirm a transaction or
    // when an error is displayed.

    /// The auction has already ended.
    error AuctionAlreadyEnded();
    /// There is already a higher or equal bid.
    error BidNotHighEnough(uint highestBid);
    /// The auction has not ended yet.
    error AuctionNotYetEnded();
    /// The function auctionEnd has already been called.
    error AuctionEndAlreadyCalled();

    /// Create a simple auction with `_biddingTime`
    /// seconds bidding time on behalf of the
    /// beneficiary address `_beneficiary`.
    constructor(
        
    ) {

    }
}

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {TINIH} from "src/TINIH.sol";

contract TINIHTest is Test {
    using stdStorage for StdStorage;

    TINIH tinih;

    function setUp() external {
        tinih = new TINIH(1, 4);
    }

    function testSomeProbabilities() external {
        uint256 prob1 = tinih.getProbability(200*1e18, 100*1e18);
        // 1-Math.exp(-(0.5**4)) yields 0.06058693718652419
        // Keep 6 most significant digits
        uint256 expected_prob1 = 60586;
        assertEq(prob1 / 1e12, expected_prob1);

        // 1-Math.exp(-((400/200)**4)) yields 0.9999998874648253
        uint256 prob2 = tinih.getProbability(200*1e18, 400*1e18);
        uint256 expected_prob2 = 999999;
        assertEq(prob2 / 1e12, expected_prob2);
    }
}

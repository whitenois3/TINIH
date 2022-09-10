// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {wadExp} from "solmate/utils/SignedWadMath.sol";
import "solmate/utils/FixedPointMathLib.sol";

/// @title TINIH
/// @author exp.table <exptable@lindylabs.net>
/// @notice Computes probability given two a current quantity and a target quantity.
contract TINIH {

    /*/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\
                            TINIH PARAMETERS
    /|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\*/

    /// @notice The scale parameter of the distribution.
    /// @dev  Represented as an 0 decimal integer.
    uint256 public immutable scale;

    /// @notice The shape parameter of the distribution.
    /// @dev  Represented as an 0 decimal integer.
    uint256 public immutable shape;

    constructor(uint256 _scale, uint256 _shape) {
        scale = _scale;
        shape = _shape;
    }

    /*/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\
                            TINIH LOGIC
    /|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\/|\*/

    /// @notice Computes the probability.
    /// @param target The target quantity, scaled by 1e18.
    /// @param current The current quantity, scaled by 1e18.
    /// @return The probability, scaled by 1e18.
    function getProbability(uint256 target, uint256 current) public view returns (uint256) {
        return uint256(
            1e18 - wadExp(
                -int256(FixedPointMathLib.rpow(
                    FixedPointMathLib.divWadDown(
                        FixedPointMathLib.divWadDown(current, target),
                        scale * 1e18
                        ),
                        shape,
                        1e18
                    )
                )
            )
        );
    }
}
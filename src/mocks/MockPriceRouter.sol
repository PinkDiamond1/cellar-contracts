// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.16;

import { MockExchange } from "src/mocks/MockExchange.sol";
import { ERC20 } from "@solmate/tokens/ERC20.sol";
import { Math } from "src/utils/Math.sol";

contract MockPriceRouter {
    using Math for uint256;

    mapping(ERC20 => mapping(ERC20 => uint256)) public getExchangeRate;

    function setExchangeRate(
        ERC20 baseAsset,
        ERC20 quoteAsset,
        uint256 exchangeRate
    ) external {
        getExchangeRate[baseAsset][quoteAsset] = exchangeRate;
    }

    function getValues(
        ERC20[] memory baseAssets,
        uint256[] memory amounts,
        ERC20 quoteAsset
    ) external view returns (uint256 value) {
        for (uint256 i; i < baseAssets.length; i++) value += getValue(baseAssets[i], amounts[i], quoteAsset);
    }

    function getValue(
        ERC20 baseAsset,
        uint256 amount,
        ERC20 quoteAsset
    ) public view returns (uint256 value) {
        value = amount.mulDivDown(getExchangeRate[baseAsset][quoteAsset], 10**baseAsset.decimals());
    }
}

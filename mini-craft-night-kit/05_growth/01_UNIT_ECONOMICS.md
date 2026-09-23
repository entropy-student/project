# Mini Craft Night Kit — Unit Economics Template

GATE=K4_6_GROWTH_FOUNDATION_SPEC
TEMPLATE_ONLY=YES
NO_ASSUMED_VALUES=YES

All numeric inputs below are OWNER_INPUT_REQUIRED. Do not substitute the current local test price, stock, SKU, shipping setup, or Sandbox order data.

| Input / output | Value | Notes |
|---|---|---|
| Production Price | OWNER_INPUT_REQUIRED | Per-order product selling price; production currency also OWNER_INPUT_REQUIRED. |
| Product Cost | OWNER_INPUT_REQUIRED | Supplier-confirmed landed/unit cost basis. |
| Packaging | OWNER_INPUT_REQUIRED | Per-order packaging cost. |
| Payment Fee | OWNER_INPUT_REQUIRED | Actual provider rate and fixed component per order, if applicable. |
| Shipping Subsidy | OWNER_INPUT_REQUIRED | Merchant-borne shipping cost less customer shipping collected; define tax treatment. |
| Returns / Refund Allowance | OWNER_INPUT_REQUIRED | Expected per-order net return/refund cost using approved operational facts. |
| Creator / Affiliate Cost | OWNER_INPUT_REQUIRED | Per-order commission or consistently allocated acquisition/partner cost. |
| Contribution Margin Before CAC | OWNER_INPUT_REQUIRED | Calculated output; see formula below. |
| Target CAC | OWNER_INPUT_REQUIRED | Owner-approved maximum planned acquisition cost per new paid order. |
| Break-even CAC | OWNER_INPUT_REQUIRED | Calculated output; see formula below. |
| AOV | OWNER_INPUT_REQUIRED | Calculated from paid orders after the revenue basis is explicitly chosen. |

## Formulas

Contribution Margin Before CAC = Production Price − Product Cost − Packaging − Payment Fee − Shipping Subsidy − Returns / Refund Allowance − Creator / Affiliate Cost

Break-even CAC = Contribution Margin Before CAC. If contribution margin is zero or negative, there is no positive break-even acquisition allowance under this model.

Target CAC must be no greater than Break-even CAC; the Owner must choose any safety margin and approve the resulting target.

AOV = Sum of paid-order revenue under one consistently documented revenue basis ÷ count of paid orders. OWNER_INPUT_REQUIRED: decide whether discounts, shipping, tax, and refunds are included in that reporting basis before comparing periods.

## Required Owner inputs before calculation

Provide approved production price and currency, per-unit product/packaging costs, actual payment-fee basis, shipping subsidy, returns/refunds allowance, creator/affiliate cost treatment, and AOV revenue basis. Do not calculate with JPY 1 or other local test values.
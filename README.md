# Chinook SQL Project — Music Store Analysis

## Key Findings
- Sales stability overall with no strong monthly seasonality; year-over-year totals are steady.
- Rock leads as the top-selling genre in major markets (USA, Canada, Brazil, Germany); Latin shows growth. France skews toward Alternative & Punk. Classical barely appears in purchases.
- Customers prefer tracks over albums (behavioral preference consistent with à-la-carte buying).
- Iron Maiden emerges as the top revenue artist and also has deep inventory.
- Country mix: USA sits atop total spend; a few smaller countries (e.g., Czech Republic) can show high totals driven by very few customers—a concentration risk insight.

## Recommendations
- **Lean into tracks:** Offer credits/subscriptions that reward frequent track purchases; bundle album+track promos to nudge upsell.
- **Genre mix:** Prioritize Rock and growing Latin inventory/marketing. De-emphasize or discount Classical (especially in markets where it underperforms) to reduce overstock.
- **Geo targeting:** Focus end-of-year conversion campaigns where spend concentrates; watch small-market outliers that can distort totals.

## Notable Query Blocks
- Inventory density: Artists per genre; albums per artist
- Geo spend: Total and average spend by country; US state share of revenue
- Time series: Monthly and yearly totals
- Behavior: Track vs. album purchase classification via a CTE
- Genre by country: Most-purchased genre per country

## Limitations
- Synthetic dataset; popularity may not reflect real-world streaming era behavior
- No channel/price data (limits promo elasticity analysis and margin understanding)
- Sparse segments can overstate totals (e.g., a country with very few high-spend customers)
- No return/refund or campaign attribution tables

## Next Steps
- Add visuals (Tableau/Excel) for:
  - Genre mix by market
  - Track vs. album share over time
  - Top artists revenue leaderboard
  - US state revenue share map
- Enhance purchase classification (e.g., consider baskets that are “mostly album” vs. “single-track”).
- Add unit economics (if price or margin detail is added later).

# RE02 Session 5: CRE Key Metrics and Property Indices

Redesign of the lecture "CRE Key Metrics and Property Indices" for RE02 Real Estate Finance and Investment (Prof. Thies Lindenthal, Department of Land Economy, University of Cambridge). Full brief: `/home/thies/teaching/RE02/Lecture 5/Project Brief.md`.

**Guiding principle:** move index estimation outside the classroom and use classroom time to develop students' understanding of CRE investment metrics and their application to real investment decisions.

## Working process

- Work iteratively. Inspect the relevant files and source materials before changing anything.
- Do not make major structural or content changes without first showing the proposed approach and getting agreement.
- Once the structure is agreed, implement changes incrementally.
- Preserve the original material using Git so that changes can be reviewed and reversed.

## Style

- British English; academically rigorous but accessible, for Cambridge university students.
- Applied and interactive. Avoid excessive text and long lists of definitions.
- Introduce each metric through an investment question, then give its definition and formula, then apply it to the running example.
- Emphasise differences between similar metrics and the economic meaning of each calculation.
- Discuss limitations of metrics and assumptions where appropriate. The aim is to develop judgement about commercial property investments, not just to teach formulas.

## Project structure

Three separate, logically distinct Reveal.js documents, plus any required data, code, figures and supporting materials:

| File | Component | Duration |
|---|---|---|
| `index.html` | Live property-level CRE metrics lecture | 60 min, about 25–30 slides |
| `hedonic-index-estimation.html` | Pre-recorded Cambridge hedonic price index demonstration | 15–20 min |
| `reit-index-estimation.html` | Pre-recorded REIT total return index demonstration | 10–15 min |

- Pre-recorded material covers how real estate price and return indices are constructed. The live lecture covers how individual CRE investments are analysed, valued and evaluated.
- Students watch both demonstrations before attending the lecture (flipped classroom).

## Reveal.js conventions

- Follow the structure and conventions of `/home/thies/talks/talk-rem1-session3/`. Reveal.js is shared from `/home/thies/talks/reveal.js/`.
- Preserve the established theme and conventions unless there is a good reason to change them.
- Default slide layout: title, subtitle, then bullets. Depart from it only where a table or figure needs to.
- Do not use Reveal.js fragments: bullets, table rows and formulas appear at once. Where students should answer first, put the answer on the following slide.
- Inside bullets and table cells, write numerical calculations on one line with `\div` so numbers stay at text size; use `\frac` (not `\dfrac`) only for short symbolic definitions; definitions with word labels (e.g. Value = Annual NOI ÷ Required yield) also go on one line with `\div`. `\dfrac` only in display `.formula` paragraphs.
- Maths renders with MathJax 4 (pinned, jsdelivr) in the sans-serif `mathjax-fira` font, via Reveal's `RevealMath.MathJax4` plugin; only `\(…\)` delimiters, no `$…$`.
- Write formulas in proper LaTeX, not plain text with `÷`, `<sub>` or `<sup>`, and set multi-letter names upright (`\text{NOI}`). Ensure mathematical notation renders correctly.
- Centre figures, using `<div class="figure">`.
- Keep source files editable. Do not embed entire slides as images.
- Make charts reproducible where practical, with clear source information.
- Keep the lecture easy to update in future years.

## Source materials

- **Existing RE02 lecture:** `/home/thies/teaching/RE02/material-2025-2026/MT Materials/RE02 MT 2025 5.pdf` (24 slides, 11 November 2025). Retain selectively. Consider reusing the MSCI illustrations of income growth, capital growth, equivalent yield and total return (slides 17–20). International investment and currency hedging are not central.
- **REM1 Session 3:** `/home/thies/teaching/rem1/slides 2026/REM1-Session 3-Real Estate Indices & Measuring Performance.pdf` (45 slides, September 2026), with editable source in `/home/thies/talks/talk-rem1-session3/` (`index.html`, `tweaks.css`). Slides 25–45 are particularly important: the Cambridge Land Registry example (about 113,000 transactions, 1995–2021) in R, from descriptive statistics to quality-adjusted indices.
- **Geltner, D.M., Miller, N.G., Van De Minne, A., Eichholtz, P., Lindenthal, T., & Shen, L. (2026). *Commercial Real Estate Analysis for Investment, Finance, and Development* (4th ed.). Routledge:** `/home/thies/teaching/rem1/textbook/`. Chapter 1 is `9781041081197c01_p1-28_LS_AM.pdf`; Chapter 3 covers returns and IRR; Chapters 2–15 are also available. Attribute material to the specific supplied chapter used, and do not attribute formulas or material to chapters that have not been supplied. On the live lecture slides, do not cite the book in source notes or text; it appears only in Further reading.

## Demonstration 1: Cambridge hedonic price index

- Objective: demonstrate how to estimate a quality-adjusted residential property price index from Cambridge Land Registry data, using the REM1 presentation as the foundation.
- Cover the limitations of average and median sale prices, changing transaction composition, hedonic regression, time dummy variables, index construction and interpretation.
- Students should understand why composition changes can produce misleading changes in unadjusted average prices.
- Central specification, with characteristics controlled for and time dummies capturing quality-adjusted price change:

  $$\ln(P_{it})=\alpha+\sum_k\beta_k X_{ik}+\sum_t\gamma_tD_t+\varepsilon_{it}$$

- Index with base period 100, with the base-period coefficient normalised to zero:

  $$I_t=100\exp(\hat{\gamma}_t)$$

- Include a practical implementation in R, reusing the existing Cambridge example, data and code where possible. Do not assume scripts or datasets are available until they have been located in the project directory.
- Must suit screen capture, combining Reveal.js slides with a short R demonstration.

## Demonstration 2: REIT total return index

- Objective: demonstrate how to construct a total return index for US industrial and infrastructure REITs. This replaces the UK REITs in the original brief.
- Screen and save the company list in S&P Capital IQ, export each company's Total Market Return series and rebase it to 100.

- Explain the assumptions, particularly dividend timing and reinvestment.
- Make clear that a REIT total return index measures shareholder returns, reflecting leverage, corporate costs and stock market valuation effects. It is not equivalent to an unleveraged index of directly owned commercial properties.
- Verify Capital IQ access and the availability of data fields rather than assuming them.
- The final recording must use actual downloaded data.

## Live lecture

- Main reference: Geltner et al. Follow its property-level investment analysis framework.
- Teach what the principal CRE metrics measure, how to calculate them, when to use them and how to interpret them critically.
- Focus on the property level rather than institutional portfolio management. Do not spend substantial time on econometric estimation, portfolio attribution or advanced index construction.

| Section | Time | Content |
|---|---|---|
| 1. Measuring property investment performance | ~10 min | Income return, capital growth and total return; how property generates cash flow and appreciation; relevant MSCI illustrations; link to the index material already studied |
| 2. Property income and cash flow | ~12 min | Gross potential rental income, vacancy and collection losses, effective gross income, operating expenditure, NOI, capital expenditure, net cash flow; operating performance versus financing costs; numerical NOI calculation |
| 3. Property yields and valuation | ~15 min | Cap rates, net initial, equivalent and reversionary yields, yield spreads; income, values and required returns; UK versus US terminology; how changing yields affect values |
| 4. Financing and leverage | ~13 min | LTV, DSCR, debt yield, cash-on-cash return, leveraged versus unleveraged returns; numerical example of how borrowing changes equity returns and financial risk; property-level versus equity investor performance |
| 5. Investment performance | ~10 min | NPV, IRR, equity multiples; holding-period returns, cash flow timing and decisions; an example comparing alternative outcomes. Do not let this become a general corporate finance lecture |

## Running numerical example

- Use one hypothetical office investment in Hull throughout the live lecture.
- Start with acquisition price and passing rent, then progressively introduce market rent, vacancy, operating expenditure, capital expenditure, financing terms and terminal sale assumptions.
- Keep inputs consistent so students can calculate several metrics for the same building.
- Keep figures in £, realistic for a secondary regional office (Hull yields around 9–9.5%; base case has positive leverage, the exit-yield stress case negative leverage), and label them clearly as illustrative unless independently sourced.
- All running-example figures come from `running-example.R`; change its inputs and re-run to update the slides.
- Purchase costs are 6.8% (illustrative). The UK yield slide uses them; the cash flows, IRR and NPV currently exclude them.
- Lectures 2–4 already cover cap rate = NOI/value and the four-quadrant model (Weeks 2–3), required return build-up, DCF and terminal value, and appraisal smoothing (Week 3), and show AI-generated IRR/NPV/multiple output (Week 4). Treat these as brief recaps and refer back.
- Include occasional questions asking students to calculate or interpret a metric before the answer is revealed.

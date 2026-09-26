# Good Issue — Birthday Magazine Studio prototype

This is a browser-only prototype for the two steps being explored:

1. **Free preview:** enter a name and memory, upload up to six photos, and see a local cover/spread preview. This step makes no AI/model request and does not upload selected files.
2. **Paid production sample:** use the clearly marked checkout simulator, answer the post-purchase prompts, watch a simulated production sequence, review a proof, and open the browser's print dialog to save a visual sample as PDF.

## Open it

Open `index.html` directly in a modern browser. No build step, package install, account, or API key is required. An internet connection is needed to load the sample Unsplash photos.

## Prototype boundaries

- The checkout is a demo. It collects no payment details and charges nothing.
- The post-payment generation stages and sample copy are fixed browser-side demo content; no AI model or other generation API is called.
- Uploaded photos are shown using browser-local object URLs. The prototype does not transmit or store them.
- “Save sample as PDF” opens the browser print dialog. This is not a production PDF generator or an order-delivery system.
- There is no WordPress integration, order database, email delivery, account, or live payment connection yet.

## Sample photo sources

All demo photographs are real photos loaded from Unsplash, not generated images. The photos are placeholders for the customer's own images in a real order. Unsplash's current license allows free commercial use, subject to its terms; third-party publicity, trademark, or property rights can still apply to depicted people or content.

- [Vitaly Gariev — friends around a birthday cake](https://unsplash.com/photos/a-group-of-people-standing-around-a-cake-with-candles-on-it-E1qHLWspl-k)
- [Bave Pictures — group dinner](https://unsplash.com/photos/a-group-of-people-sitting-at-a-long-table-Uls9c-uDv2A)
- [Ufoma Ojo — friends laughing outdoors](https://unsplash.com/photos/group-of-friends-laughing-together-outdoors-FYq7zbi7iRE)
- [Unsplash License](https://unsplash.com/license)

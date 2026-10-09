# G1.5 Browser Load Dry Run

Goal: prove the packaged extension loads and the UI/queue works without submitting a real prompt.

Required:

- Chrome or Edge;
- same browser profile already signed in to ChatGPT;
- Live generation remains OFF.

Acceptance:

1. extension loads with no manifest error;
2. toolbar icon opens the side panel;
3. text and JSON/TXT import work;
4. queue persists after closing/reopening the side panel;
5. Live OFF prevents Start from submitting;
6. no image generation occurs;
7. no cookie/token/session export occurs.

Return only the observed error text/screenshot if any issue appears.

On PASS, proceed to G2 single real image Canary.

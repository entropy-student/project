# Story Image Runner — Current Capability Boundaries & Deferred Backlog

Last reviewed: 2026-09-22
Status: CURRENT / DEFERRED ITEMS NOT AUTHORIZED FOR IMPLEMENTATION

## 1. Current V0.1.3 capability boundary

The current plugin is designed around this unit of work:

```text
1 job
→ 1 prompt submission
→ detect 1 fresh generated image
→ download 1 result
```

Current queue behavior:

```text
MAX_QUEUE_JOBS = 500
CONCURRENCY = 1
```

The 500 limit is a plugin queue limit proven by local unit tests. It is **not** evidence that one ChatGPT account/browser session can successfully generate 500 images continuously. Long-run real throughput remains unverified and is constrained by ChatGPT availability, account limits, rate limits, browser runtime stability, and per-job failures.

V0.1.3 prompt import modes:

```text
single     = entire textarea is one prompt (default)
blankline  = prompts separated by blank lines
line       = every non-empty line is one prompt
```

## 2. Multiple images from one prompt

Current status:

`NOT_IMPLEMENTED`

A single job currently expects one generated image.

Desired future behavior discussed with Owner:

```text
prompt + copies=N
→ expand into N explicit child jobs
→ generate sequentially
→ deterministic filenames such as S001_01.png ... S001_N.png
```

Reason to prefer explicit child jobs over asking the page for many images in one opaque generation: easier cardinality checks, retry, download naming, interruption recovery, and auditability.

No implementation is authorized yet.

## 3. Repository / URL images as references

Current status:

`TEXT_URL_ONLY / NOT_A_REFERENCE_ATTACHMENT`

A URL placed inside a prompt is currently sent as text. The plugin does not currently fetch the referenced image and upload it to ChatGPT as an attachment.

Desired future capability:

```text
global reference images
+
per-job reference images
→ fetch/select approved image source
→ upload as actual browser attachment
→ submit prompt
```

A GitHub repository/raw-image URL could be one source, but URL text alone must not be documented as equivalent to a real image attachment.

No implementation is authorized yet.

## 4. Download location

Current intended path:

```text
<browser default Downloads>/
  StoryImageRunner/
    <Project ID>/
      S001.png
      S002.png
      ...
```

Example on a typical Windows profile:

```text
C:\Users\<user>\Downloads\StoryImageRunner\batch-001\S001.png
```

Exact browser download root depends on the user's Chrome/Edge download settings.

The extension does not currently promise arbitrary filesystem output such as an unrestricted D:\ project path.

## 5. Download format

Current behavior:

- deterministic output filename uses the `.png` extension;
- the current implementation does not yet prove/normalize the downloaded binary MIME format before naming it `.png`.

Therefore:

```text
FILE_EXTENSION=.png
TRUE_BINARY_FORMAT=NOT_YET_VERIFIED
FORMAT_NORMALIZATION=NOT_IMPLEMENTED
```

Desired future hardening:

```text
inspect MIME / decoded image
→ validate actual format
→ optionally normalize to true PNG
→ only then finalize .png filename
```

No implementation is authorized yet.

## 6. Interrupted / failed image behavior

Current conservative behavior:

```text
completed jobs stay completed
current job fails
submitted/ambiguous failure may pause the queue
remaining jobs stay pending
manual retry is available
```

The plugin intentionally avoids blindly resubmitting after an ambiguous post-submit timeout because ChatGPT may still finish the original image, creating duplicate generations.

Current recovery does **not** yet perform conversation reconciliation.

Desired future behavior:

```text
interruption
→ inspect original ChatGPT conversation
→ if expected image already exists: download/reconcile it
→ otherwise allow bounded retry
→ continue queue
```

No implementation is authorized yet.

## 7. Current verified / observed runtime evidence

Owner browser observations on 2026-09-22:

```text
extension side panel opens = YES
Live generation can be enabled = YES
background runtime self-test = 0.1.2 observed during test
Storage = PASS
queue write/read = WORKING
queue observed = 7 jobs / 6 pending
ChatGPT content-script = READY
automatic task navigation started = OBSERVED
final generated-image/download completion = NOT YET VERIFIED
```

The 7-job queue was created under the earlier per-line parsing behavior and is not valid evidence for intended V0.1.3 prompt grouping.

## 8. V0.1.3 local evidence

Current implementation adds:

```text
default import mode = entire textarea is one prompt
blank-line split mode
per-line split mode
import count preview
large per-line import confirmation
explicit queue cap = 500
```

Local tests:

```text
11 / 11 PASS
500 jobs accepted
501 jobs rejected
extension static check PASS
```

## 9. Deferred backlog

The following are recorded but explicitly deferred:

```text
D1  multiple images / copies per prompt
D2  real reference-image attachment from repository/URL/local source
D3  actual image MIME validation and optional true-PNG normalization
D4  interruption reconciliation before retry
D5  long-run batch stress validation (10 → 50 → 100+)
D6  optional more flexible output-location workflow
```

These items are not current scope and must not be treated as implemented or automatically authorized.

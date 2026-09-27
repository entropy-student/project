export const CONTENT_SCHEMA = {
  type: "object",
  additionalProperties: false,
  required: ["recipient", "tone", "stylePreset", "groundedFacts", "coverHeadlines", "openingNote", "profile", "featureMemory", "dynamicModules", "whyTheyMatter", "currentEra", "birthdayLetter", "backCoverLine", "captions", "photoPageAssignments"],
  properties: {
    recipient: {
      type: "object", additionalProperties: false, required: ["name", "age", "birthday", "relationship"],
      properties: { name: { type: "string" }, age: { type: "integer" }, birthday: { type: "string" }, relationship: { type: "string" } }
    },
    tone: { type: "string", enum: ["heartfelt", "playful", "balanced"] },
    stylePreset: { type: "string", enum: ["bold-editorial", "soft-warm", "retro-playful"] },
    groundedFacts: { type: "array", items: { $ref: "#/$defs/claim" } },
    coverHeadlines: { type: "array", minItems: 2, maxItems: 3, items: { $ref: "#/$defs/copy" } },
    openingNote: { $ref: "#/$defs/copy" }, profile: { $ref: "#/$defs/feature" }, featureMemory: { $ref: "#/$defs/feature" },
    dynamicModules: { type: "array", minItems: 2, maxItems: 2, items: { $ref: "#/$defs/module" } },
    whyTheyMatter: { $ref: "#/$defs/feature" }, currentEra: { $ref: "#/$defs/feature" }, birthdayLetter: { $ref: "#/$defs/feature" },
    backCoverLine: { $ref: "#/$defs/copy" },
    captions: { type: "array", minItems: 10, maxItems: 14, items: { $ref: "#/$defs/caption" } },
    photoPageAssignments: { type: "array", minItems: 10, maxItems: 14, items: { $ref: "#/$defs/photoAssignment" } },
  },
  $defs: {
    copy: { type: "object", additionalProperties: false, required: ["text", "sourceRefs"], properties: { text: { type: "string" }, sourceRefs: { type: "array", items: { type: "string" } } } },
    feature: { type: "object", additionalProperties: false, required: ["headline", "text", "sourceRefs"], properties: { headline: { type: "string" }, text: { type: "string" }, sourceRefs: { type: "array", items: { type: "string" } } } },
    module: { type: "object", additionalProperties: false, required: ["name", "headline", "text", "sourceRefs"], properties: { name: { type: "string", enum: ["The Lore / inside jokes", "Favorites", "Playlist", "Travel", "Then & Now", "Year in Review", "Current Obsessions", "Mini Timeline"] }, headline: { type: "string" }, text: { type: "string" }, sourceRefs: { type: "array", items: { type: "string" } } } },
    caption: { type: "object", additionalProperties: false, required: ["photoId", "text", "sourceRefs"], properties: { photoId: { type: "string" }, text: { type: "string" }, sourceRefs: { type: "array", items: { type: "string" } } } },
    photoAssignment: { type: "object", additionalProperties: false, required: ["page", "photoId"], properties: { page: { type: "integer", minimum: 1, maximum: 12 }, photoId: { type: "string" } } },
    claim: { type: "object", additionalProperties: false, required: ["text", "sourceRefs", "supportingQuotes"], properties: { text: { type: "string" }, sourceRefs: { type: "array", minItems: 1, items: { type: "string" } }, supportingQuotes: { type: "array", items: { type: "string" } } } }
  }
};

export class ContentProvider {
  async generateStructured(_request) {
    throw new Error("Implement generateStructured(request) in a provider adapter.");
  }
}

// Uses a configurable endpoint speaking the Chat Completions JSON Schema protocol.
// A different vendor can be added by implementing ContentProvider without changing the pipeline.
export class ChatCompletionsAdapter extends ContentProvider {
  constructor({ endpoint, model, apiKey, fetchImpl = fetch }) {
    super();
    if (!endpoint || !model || !apiKey) throw new Error("RETURN_AI_PROVIDER_CREDENTIAL_REQUIRED");
    this.endpoint = endpoint;
    this.model = model;
    this.apiKey = apiKey;
    this.fetchImpl = fetchImpl;
  }

  async generateStructured({ prompt, schema }) {
    const response = await this.fetchImpl(this.endpoint, {
      method: "POST",
      headers: { authorization: `Bearer ${this.apiKey}`, "content-type": "application/json" },
      body: JSON.stringify({
        model: this.model,
        messages: [{ role: "user", content: prompt }],
        response_format: { type: "json_schema", json_schema: { name: "birthday_magazine_content", strict: true, schema } }
      }),
      signal: AbortSignal.timeout(60_000)
    });
    if (!response.ok) throw new Error(`AI_PROVIDER_HTTP_${response.status}`);
    const payload = await response.json();
    const text = payload?.choices?.[0]?.message?.content;
    if (typeof text !== "string") throw new Error("AI_PROVIDER_STRUCTURED_RESPONSE_MISSING");
    return JSON.parse(text);
  }
}

export function providerPrompt(intake, photoSelection) {
  return [
    "Write editorial copy for one synthetic birthday magazine, grounded only in the supplied intake.",
    "Do not invent events, trips, dates, quotes, hobbies, achievements, relationships, or preferences.",
    "Choose exactly two distinct supported modules from the allowed schema enum.",
    "Return a groundedFacts entry for every factual claim, with sourceRefs and exact supportingQuotes excerpts.",
    "Do not generate or request images. Return only the schema-conforming JSON object.",
    `INTAKE_JSON=${JSON.stringify(intake)}`,
    `SELECTED_PHOTO_CANDIDATES=${JSON.stringify(photoSelection.map(photo => ({ id: photo.id, scene: photo.scene, tags: photo.tags, sourceField: photo.sourceField, pageHint: photo.pageHint })))}`,
    "For output photoPageAssignments, use each selected photo ID at its supplied pageHint exactly once; use only selected IDs."
  ].join("\n\n");
}

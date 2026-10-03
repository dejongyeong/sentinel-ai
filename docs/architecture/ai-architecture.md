# Sentinel AI — AI Architecture

**File:** `docs/architecture/ai-architecture.md`  
**Status:** Proposed  
**Authority:** AI architecture

## 1. AI Role

AI is an assistive capability.

AI may:

- interpret evidence;
- summarize findings;
- explain potential causes;
- propose remediation;
- assist investigation;
- retrieve relevant knowledge;
- assist bounded engineering workflows.

AI does not automatically become the authoritative source of truth.

## 2. Deterministic Before AI

Where deterministic analysis is available:

```text
Deterministic execution
        ↓
Evidence
        ↓
AI interpretation
        ↓
Validation
```

AI must not replace deterministic checks.

## 3. AI Trust Boundary

AI output is untrusted.

Structured AI output requires:

- schema validation;
- semantic/safety validation;
- applicable deterministic verification;
- provenance.

## 4. Standards vs Retrieval

The authoritative standards model is distinct from the retrieval corpus.

### Standards model

Contains normative information.

### Retrieval corpus

Contains retrievable documents and derived representations.

Retrieval must not override authoritative normative data.

## 5. Causality

AI explanations must distinguish:

- observed evidence;
- correlation;
- hypothesis;
- causal conclusion.

Unsupported causal language must not be presented as established fact.

## 6. Human Approval

Consequential AI-generated repository changes require human approval before merge or deployment.

## 7. Evaluation

AI quality is evaluated through explicit evaluation methodology, datasets, metrics, and regression tests.

Evaluation authority belongs under `docs/ai/`.

## 8. Provider Abstraction

LLM and embedding providers are deferred architectural decisions until the relevant phases and ADRs.

Provider-specific choices must not leak through domain boundaries.

# Sentinel AI — Product Roadmap

**File:** `docs/product/roadmap.md`  
**Status:** Proposed  
**Owner:** Product / Engineering  
**Authority:** Project phase sequence and intent

## 1. Roadmap

| Phase | Name                                     | Primary outcome                                    |
| ----- | ---------------------------------------- | -------------------------------------------------- |
| P0    | Product & Secure Engineering Foundation  | Governance and secure development foundation       |
| P1    | Repository & Engineering Foundation      | Repository and engineering baseline                |
| P2    | Containerisation & Local Infrastructure  | Reproducible local runtime                         |
| P3    | Database & API Foundation                | Durable data and API foundation                    |
| P4    | Identity, Authentication & Authorization | Identity and authorization                         |
| P5    | Redis, Idempotency & Rate Limiting       | Safe coordination and request controls             |
| P6    | Background Processing                    | Asynchronous execution                             |
| P7    | Observability                            | Logs, metrics, traces and diagnosis                |
| P8    | AI Platform Foundation                   | AI provider and execution foundation               |
| P9    | RAG & Retrieval                          | Retrieval infrastructure                           |
| P10   | Accessibility Engine                     | Browser and deterministic audit engine             |
| P11   | Standards & WCAG Mapping                 | Authoritative standards model                      |
| P12   | Findings & Evidence                      | Findings and evidence lifecycle                    |
| P13   | AI Accessibility Analysis                | AI-assisted interpretation                         |
| P14   | Remediation & Validation                 | Safe remediation and validation                    |
| P15   | Continuous Monitoring & Compliance       | Recurring monitoring and evidence workflows        |
| P16   | Data Quality Sentinel                    | Data quality domain                                |
| P17   | Incident Sentinel                        | Incident domain                                    |
| P18   | AI Evaluation & Safety                   | Evaluation and safety maturity                     |
| P19   | Security Hardening                       | Security review and hardening                      |
| P20   | Performance & Reliability                | Reliability and performance                        |
| P21   | Cloud Deployment                         | Cloud runtime                                      |
| P22   | CI/CD                                    | Automated delivery                                 |
| P23   | Documentation & Portfolio                | Technical documentation and portfolio presentation |
| P24   | Integration & Release Readiness          | Release validation                                 |

## 2. Governance

The roadmap defines project sequence and intent.

Detailed implementation is owned by phase documents.

The roadmap must not become a duplicate of every phase's task list.

## 3. Dependency Rule

The phase governance chain is sequential:

```text
P0 → P1 → P2 → ... → P24
```

A dependent phase may not enter `In Progress` until its governance prerequisite is `Complete`.

Technical dependencies may require additional documentation.

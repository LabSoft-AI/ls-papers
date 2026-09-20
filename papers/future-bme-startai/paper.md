---
title: "An AI Sales Chatbot as a Measurable Sales Channel: A Production Case Study in an SME"
author:
  - name: "Luka Vidaković"
    # ORCID: 0009-0003-6591-2254
    affiliation: "StartAI Technologies d.o.o., Novi Sad, Serbia"
    email: luka@startai.tech
  - name: "Momčilo Krunić"
    # ORCID: 0000-0002-8493-2512
    affiliation: "StartAI Technologies d.o.o., Novi Sad, Serbia"
    email: momo@startai.tech
date: "2026"
abstract: |
  Conversational agents built on large language models are now common in customer
  support and sales, but evidence of their business effect still comes mostly from
  controlled experiments, and SME production studies remain rare. This paper
  presents a case study of an AI sales chatbot deployed at an SME in Serbia
  (Atlas24h, roadside assistance), built as an engineering artifact on a managed
  agentic platform (AWS Bedrock AgentCore, Strands Agents SDK) with retrieval over
  a controlled knowledge base (RAG, FAISS) and a separate data platform that
  analyzes conversations automatically. In this paper, the measures (qualified
  lead, conversion, confirmed sale) are defined, their data sources are
  identified, and report production outcomes are presented over three months.
  Confirmed sales grew from 196 (May) to 558 (June) and 1,705 (July 2026), with
  revenue rising from 15,200 to 38,700 and 113,722 euros per month. In-conversation
  conversion rose from 43% to 61%, coinciding with the enablement of purchases
  within the chat; since the channel had previously generated no sales, the July
  figures were incremental, with no headcount increase. These results align with
  existing findings and state the limitations plainly: a conflict of interest (the
  author implemented the system), no control group, and reliance on a single case.
keywords: [AI chatbot, conversational agents, sales conversion, RAG, small and medium-sized enterprises, case study]
lang: en
mainfont: "DejaVu Serif"
bibliography: references.bib
numbersections: true
---

# Introduction {#sec:introduction}

Small and medium-sized enterprises (SMEs) are turning to conversational AI agents
to handle more inquiries without adding headcount. Evidence of their business
effect, though, still comes mostly from controlled settings [@luo2019;
@schanke2021], and reviews of AI adoption in SMEs describe a fragmented picture
calling for more applied studies [@oldemeyer2024; @schwaeke2024]. What an
experiment shows and what happens in a specific enterprise's production
environment are not the same, and this gap is the starting point of this paper.

The narrow question is defined: can an AI sales chatbot turn an unmonetized
informational channel into a measurable sales channel, and under what conditions?
After that, there is an in-depth, single-case approach with the cleanest outcome
measure available: a conversation that ends in a confirmed sale and recorded
revenue, each step logged through a production API. The case builds on the
authors' earlier work on multi-agent AI systems [@stojanovic2024telfor] and RAG
architecture on AWS [@stojanovic2025aws; @vidakovic2025docker].

The contribution of this paper is threefold: we describe the chatbot as an
engineering artifact, including the data platform that measures the business
figures; we define the measures (qualified lead, conversion, confirmed sale) and
their data source, making the results verifiable; and we report three months of
production outcomes in a real SME setting, interpreted against existing findings
with an explicit statement of limitations and conflict of interest.

# Related Work {#sec:related-work}

## Conversational AI Agents in Sales and Support {#sec:agents-sales-support}

Several field studies document how conversational agents affect customer behavior.
Undisclosed chatbots can match the performance of experienced human agents, but
disclosing the bot's identity sharply reduces the purchase rate [@luo2019].
Anthropomorphism increases chatbot acceptance, with trade-offs such as greater
price sensitivity [@schanke2021], and a systematic review maps the quality
dimensions behind chatbot user experience [@nicolescu2022]. These studies
establish the phenomenon, but under controlled conditions and short time frames.

## AI Adoption in Small and Medium-Sized Enterprises {#sec:ai-adoption-smes}

Reviews of AI adoption in SMEs point to barriers such as limited knowledge, cost,
and infrastructure [@oldemeyer2024], and a more recent synthesis calls for more
empirical, contextual studies of how SMEs actually use AI [@schwaeke2024]. For
resource-limited SMEs in the EU, an iterative framework that integrates
technology, organization, and environment within a resource-based view has been
proposed [@zuferi2026toerbv], relevant to our case: a deployment with no new
hires, relying on the team's existing capacity.

## Case Study Methodology and Gap {#sec:case-study-methodology}

To justify the design and address threats to validity transparently, the
guidelines for case studies in software engineering [@runeson2009] and business
research [@rashid2019] are followed, which call for an explicit statement of these
threats. In this case, the conflict of interest and the absence of a control group
(@sec:data-sources and @sec:limitations). The literature above does not offer an
applied, production study of an AI sales chatbot in a real SME setting with
measurable sales outcomes over an extended period. This paper fills that gap for a
single case, with its limitations stated explicitly.

# System and Architecture {#sec:system}

The chatbot is a multi-component system on AWS infrastructure, described here at
the component level so the production figures can be checked as an engineering
artifact rather than taken on faith; internal resource identifiers and access
credentials are not disclosed. The conversational agent runs on a managed agentic
platform, AWS Bedrock AgentCore [@awsbedrock], with the Strands Agents SDK, using
Amazon Nova [@awsnova] as the base model for structured output and function
calling, built on the Transformer architecture [@vaswani2017attention]. Requests
flow from the user conversation through session management, a fast path for
structured steps of the sales workflow, and, when needed, a full agentic step with
enterprise-specific tools (package selection, order creation, workflow
orchestration).

Answering draws on retrieval over a controlled knowledge base (RAG) [@lewis2020rag],
with relevant content found in a vector index built on a similarity search library
[@johnson2021faiss]. The knowledge base is built and versioned automatically from
the enterprise's content, keeping prices accurate and reducing the risk of wrong
answers, building on the same team's earlier comparative evaluation
[@stojanovic2025aws; @vidakovic2025docker].

Qualified leads and confirmations are sent to the team through an asynchronous
notification service. A separate data platform automatically analyzes
conversations (sentiment, topics, quality, outcome) using Amazon Nova with
structured output. It aggregates the metrics, the measurement instrument behind
this paper's figures, to define what a single conversation is and to classify its
outcome. @fig:arhitektura shows the system flow.

![Architecture of the AI sales chatbot and the data platform: a conversational agent on a managed platform with a RAG knowledge base, in-conversation purchasing through the sales API, and a separate data platform that analyzes conversations and aggregates metrics.](figures/arhitektura.png){#fig:arhitektura width=90%}

# Method {#sec:method}

The single-case study design is applied [@rashid2019; @runeson2009]. The unit of
analysis is the deployment of an AI sales chatbot at Atlas24h (roadside
assistance) for the observed period from May to July 2026.

## Metric Definitions {#sec:metric-definitions}

To make the results verifiable, the measures are explicitly defined:

- **Qualified lead**: a conversation in which the user expressed intent and
  provided the data needed to continue the sales workflow.
- **Conversion**: the share of qualified leads that result in a confirmed sale,
  expressed as a percentage.
- **Confirmed sale**: a transaction recorded through the enterprise's production
  sales API.
- **Resolved without human intervention**: a conversation in which the user
  obtained an answer or outcome solely through the AI agent, with no escalation or
  handoff to the human team, as classified by the data platform described in
  @sec:system.
- **Close rate**: for a given funnel branch, the share of conversations with
  direct purchase intent that end in a confirmed sale, expressed as a percentage.

## Data Sources and Conflict of Interest {#sec:data-sources}

The data come from two production sources: the enterprise's sales API (confirmed
sales and revenue) and the data platform described in @sec:system (outcome
classification and metric aggregation), with revenue expressed in euros as
verified in the internal case reports. The authors implemented the system under
study, and all data are the enterprise's own production data, without independent
audit or a control group; the same team performed outcome classification and
metric aggregation using instruments it developed. This is a conflict of interest
and a threat to validity that we state explicitly and elaborate on its
consequences for interpreting the results in @sec:limitations.

# Results {#sec:results}

Sales generated through the chatbot grew steadily over the three observed months,
in both transaction count and revenue (@tbl:rast).

| Month (2026) | Confirmed sales | Revenue (EUR) | Conversion |
|--------------|-----------------|---------------|------------|
| May          | 196             | 15,200        | 42.8%      |
| June         | 558             | 38,700        | 42.9%      |
| July         | 1,705           | 113,722       | 61.4%      |

: Growth of confirmed sales, revenue, and in-conversation conversion through the AI sales chatbot, May to July 2026. {#tbl:rast}

In-conversation conversion rose from 43% to 61% (1,705 of 2,776 qualified leads),
coinciding with the introduction of in-chat purchases, which shifted the channel
from informational to transactional. Conversion held at about 43% in both May and
June (@tbl:rast), and rose to 61.4% in July, after in-chat purchasing was enabled,
a May-to-July change rather than a steady month-over-month climb. Before the AI
agent, the channel was purely informational and generated no sales; in July it
produced 1,705 confirmed sales and 113,722 euros. Of these, 559 completed the
purchase within the chat and 1,146 converted through follow-up after leaving
contact details, while 63% of all conversations were resolved without human
intervention. The in-chat close rate was 72.5% (559 of 771 conversations with
direct purchase intent), well above the follow-up branch's 57% (1,146 of 2,005).
Human call center performance remained stable over the same period (-3.8% year
over year) with no increase in headcount, indicating that the chatbot's growth
represented additional capacity rather than a redistribution of existing human
output. Other AI channels within the enterprise, such as the sales voicebot, are
outside the scope of this paper and are the subject of future work.

# Discussion {#sec:discussion}

The jump in conversion from 43% to 61% coincides with enabling purchases in the
conversation, suggesting the key factor was removing the break between intent and
transaction, not conversation quality alone. The same pattern holds within the
July funnel: the in-chat branch closed at 72.5% (559 of 771), compared with 57%
(1,146 of 2,005) for the follow-up branch, which defers the transaction to a later
contact. Since both branches serve the same enterprise and period, the roughly
15-point gap is best explained by when the purchase is completed. At the same
time, expressing intent avoids the drop-off a deferred follow-up introduces. Both
patterns are consistent with experimental evidence that conversational agents
convert well when the interaction leads directly to a purchase [@luo2019] and that
interaction design shapes outcomes [@schanke2021]. However, our data come from
continuous production rather than a controlled experiment. The human team's stable
performance alongside the chatbot's growth supports the claim that such a system
can increase an SME's capacity without new hiring, directly addressing adoption
barriers identified in the literature [@oldemeyer2024; @schwaeke2024].

For other SMEs, the practical reading is narrow but concrete: the largest gain
came from letting the chatbot complete the transaction, not merely from its
presence, the informational channel produced no sales until that step was enabled.
Where the enterprise controls the point of purchase, placing it inside the
conversation is worth prioritizing over conversational refinements alone
[@schanke2021]. This reading rests on a single case without a control group
(@sec:limitations), so it should be treated as a hypothesis for other settings
rather than a general result.

## Limitations {#sec:limitations}

Several limitations should be considered. First, the author was involved in
developing and implementing the evaluated system, while the analysis relies on
production data without independent third-party verification, introducing a
potential risk of researcher bias. Second, the study lacks a control group, so the
observed growth cannot be attributed solely to the chatbot; seasonality, marketing
activities, and other factors may have contributed. Finally, this is a single case
in one business domain, which limits the generalizability of the findings
[@runeson2009].

# Conclusion {#sec:conclusion}

This paper reported a production case study of an AI sales chatbot at an SME in
Serbia: its architecture as an engineering artifact, explicit measure definitions,
and three months of production outcomes. Enabling purchases in the conversation
coincided with a rise in conversion from 43% to 61% and revenue reaching 113,722
euros per month, while human performance remained stable and no new hiring was
required. This is the first applied, production step in a research program that
has so far covered architecture and evaluation [@stojanovic2025aws;
@vidakovic2025docker]. The findings remain limited by the absence of a control
group and reliance on a single case. Future research should evaluate the approach
across multiple deployments and business contexts.

# References {-}

::: {#refs}
:::

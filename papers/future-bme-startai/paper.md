---
title: "An AI Sales Chatbot as a Measurable Sales Channel: A Production Case Study in an SME"
author:
  - name: "Luka Vidaković"
    affiliation: "University of Novi Sad, Faculty of Technical Sciences"
date: "2026"
abstract: |
  Conversational agents based on large language models are increasingly deployed
  in customer support and sales, yet evidence of their effect comes mostly from
  controlled experiments, while applied production studies in small and
  medium-sized enterprises remain scarce. This paper presents an in-depth case
  study of deploying an AI sales chatbot in an SME in Serbia
  (Atlas24h, roadside assistance). The chatbot was built as an engineering
  artifact on a managed agentic platform (AWS Bedrock AgentCore) with the Strands
  Agents SDK, using retrieval-based answering over a controlled knowledge base
  (RAG, FAISS) and a separate data platform for automated conversation analysis.
  We describe the system architecture, define the measures (qualified lead,
  conversion, confirmed sale) and the data source (a production API and the data
  platform), and then report production outcomes over three months. The number
  of confirmed sales grew from 196 (May) to 558 (June) and 1,705 (July 2026),
  with verified revenue rising from 15,200 to 113,722 euros per month.
  In-conversation conversion increased from 43% to 61%, coinciding with enabling
  purchases within the chat, and because the channel had previously been a purely
  informational bot with no sales, its 1,705 confirmed sales and 113,722 euros in
  July 2026 were incremental, without any increase in headcount and with a stable
  human team performance. We
  interpret the results against existing experimental findings and explicitly
  state the limitations, chiefly a conflict of interest (the author is the
  system's implementer), the absence of a control group, and reliance on a single
  case.
keywords: [AI chatbot, conversational agents, sales conversion, RAG, small and medium-sized enterprises, case study]
lang: en
mainfont: "DejaVu Serif"
bibliography: references.bib
numbersections: true
---

# Introduction {#sec:introduction}

Small and medium-sized enterprises (SMEs) increasingly consider conversational
AI agents as a way to serve a growing volume of inquiries without a proportional
increase in headcount. Despite the rapid spread of these systems, evidence of
their business effect still comes mostly from controlled or experimental settings
[@luo2019; @schanke2021], while literature reviews on AI adoption in SMEs report
fragmented findings and call for more applied, contextual studies
[@schwaeke2024; @oldemeyer2024]. The result is a gap between what has been shown
in an experiment and what happens when such a system runs in the production
environment of a specific enterprise.

This paper addresses one narrow but practically important question: can an AI
sales chatbot turn a previously unmonetized informational channel into a
measurable sales channel, and under what conditions. Rather than comparing
several heterogeneous cases, we choose an in-depth approach to a single case with
the cleanest outcome measure: a conversation leads to a confirmed sale and
revenue, with each step recorded through a production API. The study draws on the
same research team's experience at the Faculty of Technical Sciences in Novi Sad
in developing multi-agent AI systems [@stojanovic2024telfor].

The contribution is threefold. First, we describe the AI sales chatbot as an
engineering artifact: the agentic architecture, retrieval-based answering over a
controlled knowledge base, and the data platform that serves as the measurement
instrument behind the business figures. Second, we define the measures (qualified
lead, conversion, confirmed sale) and their data source, making the results
verifiable. Third, we report production outcomes over three months in a real SME
setting in Serbia and interpret them against existing findings, with an explicit
statement of limitations and conflict of interest. The paper is framed by
guidelines for case studies in software engineering [@runeson2009; @rashid2019].

# Related Work {#sec:related-work}

## Conversational AI agents in sales and support {#sec:agents-sales-support}

The effects of conversational agents on customer behavior have been documented in
several field studies. Luo and colleagues show that undisclosed chatbots can be
as effective as experienced human agents, but that disclosing the bot's identity
before a conversation significantly reduces the purchase rate [@luo2019]. Schanke
and colleagues examine chatbot anthropomorphism and find that it increases
acceptance, though with trade-offs such as greater price sensitivity
[@schanke2021]. A systematic review of user experience with support chatbots maps
the quality dimensions and acceptance factors [@nicolescu2022]. These works
establish the phenomenon and its design variables, but they measure effects under
controlled conditions and over short time frames.

## AI adoption in small and medium-sized enterprises {#sec:ai-adoption-smes}

Reviews of AI adoption in SMEs single out barriers such as a lack of knowledge,
cost, and inadequate infrastructure [@oldemeyer2024], and a more recent synthesis
describes the literature as fragmented and calls for more empirical, contextual
studies of how SMEs actually use AI [@schwaeke2024]. As a theoretical framework
for introducing AI in resource-constrained SMEs in the EU, an iterative approach
has been proposed that combines the technology, organization, and environment
perspectives with a resource-based view [@zuferi2026toerbv]. This context is
relevant to our case: a deployment without new hires, relying on the team's
existing technical capacity.

## Case study methodology {#sec:case-study-methodology}

To justify the design and to treat threats to validity transparently, we rely on
guidelines for conducting and reporting case studies in software engineering
[@runeson2009] and on a step-by-step guide to case studies in business research
[@rashid2019]. These guidelines require an explicit statement of threats to
validity, which in our case includes the conflict of interest and the absence of
a control group (see @sec:method and @sec:limitations).

## Gap {#sec:gap}

The existing literature either measures effects under controlled experimental
conditions [@luo2019; @schanke2021] or, in the SME context, calls for more
applied studies [@schwaeke2024; @oldemeyer2024]. What is missing is an applied,
production study of deploying an AI sales chatbot in a real SME setting with
measurable sales outcomes over an extended period. This paper fills that gap for
a single case, with an explicit acknowledgment of its limitations.

# System and Architecture {#sec:system}

The chatbot was implemented as a multi-component system on AWS infrastructure.
The aim of this description is to make the production figures verifiable as the
outcome of an engineering artifact, not merely as a business claim. The
architecture is described at the component level; internal resource identifiers
and access credentials are not disclosed.

The conversational agent runs on a managed agentic platform (AWS Bedrock
AgentCore [@awsbedrock]) with the Strands Agents SDK. Amazon Nova [@awsnova]
serves as the base model, supporting structured output and function calling.
Modern language models of this type rest on the Transformer architecture
[@vaswani2017attention]. Request processing flows from the user conversation
through session management, a fast path for structured steps of the sales
workflow, and, when needed, a full agentic step with enterprise-specific tools
(package selection, order creation, workflow orchestration).

Answering is based on retrieval over a controlled knowledge base (RAG)
[@lewis2020rag], where relevant content is found in a vector index built on a
similarity search library [@johnson2021faiss]. The knowledge base is built and
versioned automatically from the enterprise's content, which keeps prices and
information under control and reduces the risk of inaccurate answers. These
architectural choices (RAG on AWS, the choice of runtime environment) build on
the same team's earlier comparative evaluation
[@stojanovic2025aws; @vidakovic2025docker], so they are not ad hoc decisions.

Qualified leads and confirmations from conversations are sent to the team and the
user through an asynchronous notification service. A separate data platform
automatically analyzes the conversations (sentiment, topics, quality, outcome)
using Amazon Nova with structured output, and aggregates the metrics. This
platform is the measurement instrument behind the figures in this paper: it
defines what a single conversation is and classifies conversation outcomes.
@fig:arhitektura shows the system flow.

![Architecture of the AI sales chatbot and the data platform: a conversational agent on a managed platform with a RAG knowledge base, in-conversation purchasing through the sales API, and a separate data platform that analyzes conversations and aggregates metrics.](figures/arhitektura.svg){#fig:arhitektura width=90%}

# Method {#sec:method}

We apply a single-case study design [@runeson2009; @rashid2019]. The unit of
analysis is the deployment of an AI sales chatbot at Atlas24h (roadside
assistance), for the observed period from May to July 2026.

## Metric definitions {#sec:metric-definitions}

To make the results verifiable, we define the measures explicitly:

- **Qualified lead**: a conversation in which the user expressed intent and
  provided the data needed to continue the sales workflow.
- **Conversion**: the share of qualified leads that result in a confirmed sale,
  expressed as a percentage.
- **Confirmed sale**: a transaction recorded through the enterprise's production
  sales API.

## Data sources {#sec:data-sources}

The data come from two production sources: the enterprise's sales API (confirmed
sales and revenue) and the data platform described in @sec:system (classification
of conversation outcomes and aggregation of metrics). Revenue is expressed in
euros as verified in the internal case reports.

## Conflict of interest {#sec:conflict-of-interest}

The author is the implementer of the system under study. All data are the
enterprise's own production data, without an independent audit and without a
control group. Outcome classification and metric aggregation were performed with
instruments developed by the same team. This constitutes a conflict of interest
and a threat to validity that we state explicitly; its consequences for
interpreting the results are elaborated in @sec:limitations.

# Results {#sec:results}

Over the three observed months, sales generated through the AI sales chatbot grew
both in transaction count and in revenue (@tbl:rast). The number of confirmed
sales rose from 196 in May to 558 in June and 1,705 in July 2026, while verified
revenue rose from 15,200 to 38,700 and 113,722 euros per month.

| Month (2026) | Confirmed sales | Revenue (EUR) |
|--------------|-----------------|---------------|
| May          | 196             | 15,200        |
| June         | 558             | 38,700        |
| July         | 1,705           | 113,722       |

: Growth of confirmed sales and revenue through the AI sales chatbot, May to July 2026. {#tbl:rast}

In-conversation conversion rose from 43% to 61% (1,705 of 2,776 qualified leads,
that is 61.4%), coinciding with enabling purchasing within the chat itself, which
moved the channel from an informational to a transactional role. Before the AI
sales agent was introduced, the channel operated as a purely informational bot
and generated no revenue and no sales (0 euros and 0 confirmed sales), against
1,705 confirmed sales and 113,722 euros in July 2026. Of the 1,705 confirmed
sales in that month, 559 users completed the entire purchase within the chat
(in-chat completion) and 1,146 left contact details and converted through
follow-up, while 63% of all conversations were resolved without human
intervention. The close rate on in-chat purchases was 73%, the highest in the
funnel. Over the same period, the performance of the human call center remained
stable (a change of -3.8% year over year), with no increase in headcount. This
indicates that the growth generated through the chatbot represented additional
capacity rather than a redistribution of existing human output. Other AI channels
at the enterprise, such as the sales voicebot, fall outside the scope of this
paper and are the subject of future work (a master's thesis).

# Discussion {#sec:discussion}

The jump in conversion from 43% to 61% coincides in time with enabling purchases
in the conversation, which suggests that the key factor was removing the break
between intent and transaction, not conversation quality alone. This finding is
consistent with experimental evidence that conversational agents can achieve high
purchase rates [@luo2019] and that interaction design shapes outcomes
[@schanke2021]. Unlike those studies, our data come from continuous production in
a single enterprise over several months rather than from a controlled experiment.

The stable performance of the human team alongside the simultaneous growth of the
chatbot supports the claim that deploying such a system in an SME can increase
total capacity without new hiring, which is relevant to the adoption barriers
described in the literature [@oldemeyer2024; @schwaeke2024].

## Limitations {#sec:limitations}

The results should be interpreted with several serious limitations in mind.
First, there is a conflict of interest: the author is the implementer of the
system, and all data are the enterprise's production data without independent
verification (@sec:conflict-of-interest). Second, there is no control group, so
the observed growth cannot be attributed to the chatbot alone; seasonal effects,
marketing activities, and other factors are not isolated. Third, this is a single
case in a single domain, which limits generalizability [@runeson2009]. The
measurement instrument (outcome classification) was developed by the same team,
so the metric definitions themselves carry a risk of bias. We state these threats
to validity explicitly, in line with the methodological guidelines.

# Conclusion {#sec:conclusion}

This paper presented a production case study of deploying an AI sales chatbot in an
SME in Serbia, describing the architecture as an engineering
artifact, giving explicit measure definitions, and reporting three months of
production outcomes. The main finding is that enabling purchases in the
conversation was accompanied by a rise in conversion from 43% to 61% and growth
in the chatbot's revenue to 113,722 euros per month, with stable human
performance and no new hiring. The contribution is the first applied, production
step in a research program that has so far covered architecture and evaluation
[@stojanovic2025aws; @vidakovic2025docker], now directed at real business
outcomes. The findings are limited by the conflict of interest, the absence of a
control group, and reliance on a single case. Future work includes a comparative
analysis of four cases with aligned metrics within a master's thesis, which would
mitigate the threats to validity tied to a single case.

# References {-}

::: {#refs}
:::

---
title: It starts with identity
subtitle: 
date: 2023-01-17
---

It's no secret that, as a software professional moves through their career, they often find unique specialization along the way. Serendipitously, my work has required deep experience with "identity" in software; this includes authentication and authorization. Identity modeling and implementation shows tremendous variety across organizations. While some best-practices do exist, even specification-driven engineering still leaves a surprising amount of ambiguity and inconsistency between implementations (vendor and internal).

My first toe into the waters of identity systems was at a small startup in the food/beverage space. At the time, they were using a homespun OAuth 1.0-inspired token exchange for web service/machine-to-machine flows. SAML and SSO were not yet on the radar for this company; user sessions were managed via the web framework used by engineering, and that was that.

A while later, I was part of a team working configuring APIs via a 3rd-party Identity provider; this was pretty cutting edge as we were just seeing microservice patterns gain adoption at enterprise scale. The system worked at a gateway level and became my first deep dive into OAuth2, OIDC, and SAML. I was a pretty junior engineer at the time, so this was all drinking from a fire hose! As I moved through my career, identity kept coming up over and over again. I saw a _terrible_ implementation of identity at a startup, written in PHP. Essentially, a registration method set a user as _active,_ **then performed a database action**, and unset-the activation on error! If this flow gets interrupted for any reason, the result could be an active user with no way to log in/re-register! Through happy circumstance, integrating systems has come up over and over (disclaimer: somehow or another, I have never had to work with LDAP or Active Directory); SSO and OIDC became familiar to me. I even designed a decoupled "roles and permissions" system for a large enterprise in the media industry. The POC informed a lot of my thinking about identity and access control.

Some of my deepest, and most interesting, identity work involved connected device certificates integrating via mutual TLS with a public key infrastructure (PKI) certificates. In the same role, I got to work with front-end bot control, as well as GDPR-compliant login systems. In all of these cases, no consistent identity model existed across the organization.

Many medium-large orgs seem to decide on an identity provider, then use that provider and feel like the identity implementation for their system is complete: "We're using OAuth2." Only much later, when APIs are consuming APIs and crossing network/VPC boundaries across systems, does it become apparent how hard it is to track: _who has access to what, for what purpose?_ Security audits come along, and it takes _weeks of effort_ to catalog the various systems enforcing permissions and identity.

Why? For something as crucial to security and reliability, a cornerstone of trust for a company (encompassing end-users _and_ machine/automation entities), why does identity present such a unique challenge? Why is it hard to get it right? Identity presents challenges at the social, organization, and technical levels. The concern cuts across software layers and networks, and yet the implementation of identity largely gets fractured among multiple teams in an organization. Let's be real: investing in identity is unrewarding. The best identity implementations are nearly transparent to users and organization.

Most identity solutions implemented by organizations are fine-tuned and tailored to the situation that led to their creation/implementation. Many enterprise-level auth solutions still seem geared towards servicing individual use cases, never making the transition from "n of one" to "n of many." While OAuth2 and OIDC make _representing_ identity, and configuring user log ins for a web app, rather easy, the challenge of dealing with identity still presents a lot of open questions.

"Identity" encompasses multiple concerns; this can be tricky because several of the concerns which _should_ be managed by an identity system get adopted by other teams, usually in a tightly-scoped manner. For example, with GDPR and other privacy legislation initiatives either passing or in-the-works, a Data Privacy team often reviews architecture decisions and access patterns with multiple teams. Data access and authorization is often managed per-application; a database sometimes connects to multiple services which manage access independently! This can lead to a cross-system privilege escalation data access pattern. When dealing with internal and external access services, it's common to see issues with "data chain-of-custody." A user uses an SSO session to access a front end (say a Single Page Application [SPA] for this example). The SPA sends a JWT to a back-end API. 

```goat
SPA -> API: User JWT
API -> Backend Service: Service JWT
note over API, Backend Service: No record of initiating user
```

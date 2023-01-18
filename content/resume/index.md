---
title: Mickey's Resume
---

## Problem solver with a specialty in software-assisted automation

---

<img src="/img/me_pic.png" style="max-width: 150px; margin: 0 auto;" />

---

### Cultural values

- Collaboration
- Learning
- Quality
- Transparency

---

### Skills

- *Technical writing and communication*
- *Training/Mentoring*
- AWS/Cloud architecture
  - IAM and cross-account permissions
  - EC2 including load-balancing, auto-scaling groups, and AMIs
  - serverless: Lambda/API Gateway; Fargate; DynamoDB
  - VPC configuration
  - RDS administration including backup management
  - ECS container orchestration
  - CloudFront
  - Route53
- CI/CD administration and configuration
- Infrastructure as Code (IaC)
- Docker/containerization; docker-compose
- SQL and NoSQL database administration
- Product implementation and engineering best practices

---

### Languages

- bash
- python
- sql
- javascript (typescript; node; react)
- html/css and basic front-end skills
- C#/.NET Core (less recently)
- JSON/YAML/TOML/etc.

---

### Professional experience

**[Macroscope](https://macroscope.io)** | Boulder, CO  
Infrastructure Engineer  
Feb. 2022 - Jan. 2023  

- Pre-series-A startup environment
- Helped design and personally implemented AWS configurations for all application and vendor services
- *All* infrastructure captured in IaC
- Created proof-of-concept prototypes
- Wrote custom CLI Python apps for SlackBot + Buildkite integation; build-time configuration file generation; provisioning and deploying stack-sets to multiple regions
- Implemented data pipeline infrastructure including [Dask](https://www.dask.org), [Prefect](https://www.prefect.io)
- Interacted with vendors on issues with open-source software on GitHub

---

**[Trimble](https://trimble.com)** | Westminster, CO  
Systems Architect  
Jan. 2021 - Feb. 2022  

- Cloud core architect on the internal Identity team
- Developed features for internal SSO offerings
  - IoT device identity based on x509 certificates
  - GDPR-compliant architecture POC and proposals
  - Asynchronous invitation service to notify apps when users accept an invitation to a product
- Worked with international, multidisciplinary teams
- Tightly integrated with security teams to address overall security posture
- Interal platform development and delivery
- Architected delegated IAM to Systems Manager automations to enable support teams to perform runbook automations without escalated privileges

Lead Engineer, E-Tools  
Nov. 2019 - Jan. 2021  

- Provided interal services for over 6000 internationally-distributed users
- Oversaw systems administration on Atlassian apps; SonarQube; Artifactory
- Reworked single-server configuration to horizontally-scalablity
- Used Systems Manager to provide automatic security patching on all EC2 instances
- Developed automation to support process improvements
- Wrote and reviewed change/deployment planning
- PagerDuty and operational integrations
- Configured software to report metrics to vendor-provided services such as DataDog, SumoLogic, Splunk
- Authored Lambdas to automate operational concerns for repeated one-off actions

---

**[Spire Digital (now Kin + Carta)](https://www.kinandcarta.com/en-us/)** | Denver, CO  
Tech Lead; Senior Cloud Engineer  
Mar. 2019  Nov. 2019  

- Mentored less-experienced developers
- Ensured testing practices were met
- Developed IaC for all cloud infrastructure
- Configured CI/CD
- Design/management collaboration
- Presented tech options to clients; ran benchmarks to demonstrate trade-offs

---

**[Element3Health](https://element3health.com/)** | Denver, CO  
Senior Software Engineer  
Oct. 2018 - Mar. 2019  

- Practiced high-touch collaboration with pair-programming/TDD
- Containerized and migrated a legacy application to AWS
- Implemented API layer in .NET Core
- Configured ECS to deploy containerized solutions

---

**[Cognizant](https://www.cognizant.com/us/en)** | Boulder, CO  
Software Engineer  
Aug. 2017 - Oct. 2018  

- Served as tech lead on a team developing proof-of-concept/prototypes
- Containerized development and deployment environment
- Feature planning and development
- Machine learning: Internal [Kaggle](https://www.kaggle.com) competitions to devleop skills
- Connect4 bot just for fun
- Used Python/Flask and GraphQL

---

**[IHS Markit (now S&P 500)](https://www.spglobal.com/en/)** | Boulder, CO  
Software Engineer  
Jul. 2015 - Aug. 2017  

- Worked on a service-layer node API
- Automated CI/CD configuration for new projects
- Debugged memory leaks in nodejs
- Worked on .NET 4.5 APIs and MVC projects

---

**[TraceGains](https://www.tracegains.com)** | Westminster, CO  
Technical Specialist, Customer Success  
Nov. 2013 - Jul. 2015  

- Automated Excel -> product database upload process via C# .COM add-in invoking web services
- Wrote the web services integration manual
- Proposed product features such as a web-based OCR tagging app to reduce overhead

---

**[Apex Hi-Point/Sigma Cubed](https://www.apexpe.com)** | Centennial, CO  
Technical Specialist/Technical Writer  
Nov. 2010 - Nov. 2013  

- Wrote about highly technical, scientific concepts in a comprehensible and straightforward way
- Worked under a scientist with teaching experience in technical writing
- Coded Office macros to automate/streamline charts and graphics
- Integrated with other software as-needed

---

### Projects

#### GDPR-Compliant Architecture

GDPR stipulates that end-user data be stored in the European region if the user requests it. To accommodate for this, I helped design geo-isolated, globally integrated software. We architected a data portability service to ensure secure encryption while transferring data across geographic regions.

#### Device Identity and Authentication

I helped architect and build a token-based identity system using mutual TLS. The system enables device identity management and integrates with existing OIDC and SAML systems.

#### Banking Integration and Reporting System

Contract - Built an application which integrates with multiple 3rd party services (e.g., Plaid, SendGrid) and generates monthly, automated CSV reports. The API leverages Swagger/OpenAPI, TypeScript, Express, and Node.

#### Serverless Ticketing System for Cryptocurrency Conference

Contract - Built a serverless API which integrated with a SquareSpace instance to process credit card and cryptocurrency transactions. Used Stripe, Globee, and SendGrid to provide transactional functionality. Open source with permission from client. <https://github.com/BadAsstronaut/crytpo-con-website>

#### Financial Applications

Several groups and I collaborated on innovative finance projects including report generators for investment funds; an options trading screener; quotes and research applications; client-facing REST APIs; data-driven web pages.

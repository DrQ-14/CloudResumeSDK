<a name="top"></a>
[![Personal Cloud Platform](assets/banner.png)](https://tanager-solutions.com)

# Improved Readme
**Status: In Progress**

[![Static Badge](https://img.shields.io/badge/Online-%23F38020?style=for-the-badge&logo=cloudflare&label=live%20site)](https://www.tanager-solutions.com/)
[![Deploy to Azure Static Web App](https://img.shields.io/github/actions/workflow/status/DrQ-14/CloudResumeSDK/deploy.yml?style=for-the-badge)](https://github.com/DrQ-14/CloudResumeSDK/actions/workflows/deploy.yml)
[![Microsoft Azure](https://custom-icon-badges.demolab.com/badge/Microsoft%20Azure-0089D6?style=for-the-badge&logo=msazure&logoColor=white)](https://azure.microsoft.com/en-us)
[![Terraform](https://img.shields.io/badge/Terraform-844FBA?style=for-the-badge&logo=terraform&logoColor=fff)](https://developer.hashicorp.com/terraform)
[![.NET](https://img.shields.io/badge/.NET-8.0-512BD4?style=for-the-badge&)](https://dotnet.microsoft.com/en-us/)

## Table of Contents

- [About](#about-what-is-this)
- [Project Evaluation](#project-evaluation)
- [Architecture](#architecture-decisions-and-why-they-were-made)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact-me)

## About (What is this)

## About

**What is this?**  
This repository contains my personal cloud platform—a live, production-style system that demonstrates my skills in backend development, cloud infrastructure, and CI/CD.

**Why does it exist?**  
It provides a practical, real-world example of the technologies I use and the problems I can solve, rather than relying solely on a CV.

- Where can I see it?

    The static website can be found here: [tanager-solutions.com](https://www.tanager-solutions.com/) and the associated backend code for the website is found in this repo. An explanation of the full tech stack and why I made my decisions can be found below under [Architecture](#architecture-
    decisions-and-why-they-were-made), though it should be noted that I focus less on the frontend and more on the backend, the infrastructure and CI/CD pipeline.

**Where can I see it?**  
    The live platform is available at: [tanager-solutions.com](https://www.tanager-solutions.com/)
    This repository contains the backend, infrastructure, and deployment logic.  
    A detailed breakdown of the design decisions is available in the [Architecture](#architecture-decisions-and-why-they-were-made) section.

## Project Evaluation

**Who is this for?**  
Hiring managers and engineers who want a fast, practical way to evaluate my capabilities as a cloud engineer.

**What problem does it solve?**  
It replaces static CVs with a working system, making it easier to assess real skills without relying on documents that are often overlooked or hard to share internally.

**Why did I build it?**  
During previous hiring processes, my CV was often overlooked or indistinguishable from others. This platform ensures my skills are demonstrated through a tangible, accessible system instead.

## Architecture Decisions and Why They Were Made

### Testing Suite
- Unit tests:
    - Unit tests **validate business logic** in isolation by **mocking dependencies** like the repository. This keeps tests **fast and reliable** by **avoiding external systems** such as databases.
- Integration test components:
    - Integration testing is **split into fixtures, collections, and test types** to **separate setup, resource sharing, and validation.** This **improves maintainability** and makes failures easier to diagnose.
    - Fixture:
        - The fixture **manages setup and teardown** of the **Cosmos DB emulator, database, and container.** This **centralizes setup logic** and ensures a **consistent test environment.**
    - Collection:
        - The collection **groups tests that share a fixture instance.** This **reduces repeated initialization,** improving **performance and efficiency.**
    - Integration tests:
        - Integration tests **validate the full flow from service to database.** This ensures **components work together** correctly in a **real environment.**
    - Smoke tests:
        - Smoke tests **perform basic read/write operations** against the database. This quickly confirms the **environment works** and helps **distinguish infrastructure issues from logic failures.**

### Architectural redesign

- Redesign decision:
    - I replaced Cosmos DB triggers and bindings with a layered architecture using dependency injection. This **reduces coupling** and makes **debugging and testing more manageable.**

### Application (Function)

- Host configuration:
    - Sets up dependency injection and application wiring. This **reduces coupling** and **makes components easier to test and modify.**

- Function:
    - Handles request/response logic and calls the service. Keeping it minimal **improves testability** and **simplifies debugging.**

- Model:
    - Defines the counter structure used across the system. This **ensures consistency** and **simplifies testing** with a single source of truth.

- Repository:
    - Handles data access for Cosmos DB. This **isolates database logic** and **allows the storage layer to change without affecting other components.**

- Interface:
    - Defines a contract for repository operations. This **enables dependency inversion** and **easy swapping of implementations** for testing or future changes.

- Service:
    - Contains the business logic for incrementing the counter. This **centralizes logic, improving reuse** and **separation from infrastructure concerns.**

### Infrastructure decisions

- Bootstrap:
    - Initializes Terraform backend storage before deployments. This **ensures state is persisted** and **prevents conflicts or loss.**

- Modules:
    - Infrastructure is split into Core, Compute, Data, and Security modules. This **separates concerns, improving maintainability and reusability.**

- Core:
    - Provides shared foundational resources like resource groups and storage. This **avoids duplication** and **ensures consistency across modules.**

- Compute:
    - Defines runtime resources like the function app and monitoring. This **isolates application execution concerns** and **simplifies scaling.**

- Data:
    - Manages Cosmos DB resources. This **isolates persistence configuration** and **allows independent updates.**

- Security:
    - Handles identity and access control. This **centralizes permissions** and **reduces the risk of misconfiguration.**

- Root module:
    - Orchestrates all modules and passes outputs between them. This **centralizes configuration** and **ensures coordinated deployments.**

## License

- License info

## Contact

- LinkedIn: 
- Email: 

[Back to top](#top)
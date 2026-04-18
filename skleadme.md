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

- What is it called?

    This repo is called my personal cloud platform.

- Why does it exist?

    This platform exists as an easy way to share the cloud technology, praxis and problems that I am familiar with and capable of solving.

- Where do I find it again?

    The static website can be found here: [tanager-solutions.com](https://www.tanager-solutions.com/) and the associated backend code for the website is found in this repo. An explanation of the full tech stack and why I made my decisions can be found below under [Architecture](#architecture-decisions-and-why-they-were-made), though it should be noted that I focus less on the frontend and more on the backend, the infrastructure and CI/CD pipeline.

## Project Evaluation

- Who is this for?

    This platform is for hiring managers and engineers to quickly assess my capabilities as a cloud engineer and decide whether or not I am suitable for solving the problems that their company is currently working through. Sharing a link to a publicly available website is often faster than uploading, sending, downloading and assessing a CV, thus I have built my platform to be a more scalable solution to the problem of competency assessment by many different teams and organizations that have different needs, hiring processes and talent preferences.

- Who does this help?

    This platform helps any organizations that are in need of cloud talent and determine that I can solve problems that their organization is currently grappling with.

- Where did this come from?

    During the hiring process for many cloud engineer positions my resume was getting lost in translation and getting shoved into piles with other CVs. This platform intends to solve the issue of my skills and capabilites being overlooked due to looking the exact same as every other candidate, or my CV not getting passed around due to difficulty moving it between people.

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